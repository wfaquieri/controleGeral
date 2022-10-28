# Planilha da demanda (extraída do sistema de Cis):

a = dir(path = 'input', pattern = "CI_", full.names = TRUE)

n <- length(a)

if (n<1) {
  stop(
    '\n \n \n \n \n \n \n \n \n \n A pasta de input se encontra vazia. Atualizar a pasta com a(s) planilha(s) extraída(s) do sistema de CIs.\n'
  )
}

cis =
  purrr::map_df(
    1:n,
    ~ readxl::read_xlsx(
      a[.x],
      range = readxl::cell_cols("A:AP"),
      col_types = "text"
    )
  )



# Planilha de Controle Geral de Solicitações

p = dir(path = '../', pattern = "Controle-Geral", full.names = TRUE)

if (length(p)>1) {
  stop(
    'O arquivo de Controle-Geral está aberto! Antes de rodar a aplicação, verifique se a planilha está sendo atualizada e após feche o arquivo.'
  )
}

controle = readxl::read_excel(
  p,
  col_types = c("text", "text", "text",
                "text", "text", "text", "text", "text",
                "text", "text", "text", "text", "date",
                "date", "text", "text", "numeric",
                "numeric", "text", "date", "date",
                "text", "text"))



# DATA WRANGLING ----------------------------------------------------------

controle = controle |>
  dplyr::mutate(
    descricao_solicitada = gsub("\\s+"," ", descricao_solicitada),
    descricao_solicitada = stringi::stri_trans_general(descricao_solicitada,"latin-ascii"),
    descricao_solicitada = stringr::str_to_upper(descricao_solicitada)
  )


col_names = names(controle)

cis = cis |>
  dplyr::select(1:12, 39, 40) |>
  dplyr::mutate(
    data = data |> stringr::str_sub(1, 10),
    data = paste(stringr::str_sub(data, 7, 10),
                 stringr::str_sub(data, 4, 5),
                 stringr::str_sub(data, 1, 2),
                 sep = "-"),
    cod_ci = paste0("CI ", cod_ci),
    cod_ci_ext = cod_ci_ext |> stringr::str_replace("-", ""),
    data_prazo = "",
    tipo_do_pedido = "",
    responsavel_pela_solicitacao = "",
    data_da_ultima_parcial = "",
    data_da_finalizacao = "",
    observacoes = "",
    duplicidades = ""
  )

cis = cis |>
  dplyr::group_by(cod_ci) |>
  dplyr::mutate(
    aux1 = cod_elem_insumo |> na.omit() |> dplyr::n_distinct(),
    aux2 = cod_ext_insumo |> na.omit() |> dplyr::n_distinct(),
    aux3 = descr_elem_insumo |> na.omit() |> dplyr::n_distinct(),
    quantidade_de_itens = max(aux1, aux2, aux3),
    aux = dplyr::if_else(uf_solicitada == 'BR', 27, 1) |> as.double(),
    quantidade_total_de_itens = sum(aux)
  ) |> dplyr::select(-dplyr::contains('aux')) |>
  dplyr::relocate(quantidade_de_itens, .before = responsavel_pela_solicitacao) |>
  dplyr::relocate(quantidade_total_de_itens, .before = responsavel_pela_solicitacao) |>
  dplyr::select(1:12, 14, 15:16, 13, 17:18, 19:23) |>
  purrr::set_names(col_names)



cis$data_da_finalizacao = as.Date(cis$data_da_finalizacao)
cis$data_da_solicitacao = as.Date(cis$data_da_solicitacao)
cis$data_prazo = as.Date(cis$data_prazo)
cis$data_da_ultima_parcial = as.Date(cis$data_da_ultima_parcial)

# Lista com a origem e o elementar para verificar se o item já havia
# sido solicitada anteriormente:

novos_ext_ = unique(cis$item_externo)
novos_elem_ = unique(cis$elementar)


duplicados = controle |> dplyr::select(origem, item_externo, elementar, data_da_solicitacao) |>
  dplyr::filter(item_externo %in% novos_ext_ | elementar %in% novos_elem_) |>
  dplyr::distinct() |>
  dplyr::mutate(dup_aux = paste0("Data da Solicitação: ",
                                data_da_solicitacao,"; Origem: ",origem)) |>
  dplyr::select(item_externo,elementar,dup_aux)

if (length(duplicados) > 0) {
  cat(crayon::red$bold(" \n \n \n  \n \n \n \n  \n \n \n  \n \n \n  \n \n \n Alerta de itens já solicitados!\n"))
}

cis2 = cis |>
  dplyr::left_join(duplicados, by = c("item_externo", "elementar")) |>
  dplyr::mutate(duplicidades = dplyr::if_else(is.na(dup_aux), duplicidades,dup_aux)) |>
  dplyr::select(-dup_aux)

# ATUALIZAR PLAN CONTROLE - BIND
novo_controle = dplyr::bind_rows(controle, cis2)

novo_controle$data_da_finalizacao = lubridate::ymd(novo_controle$data_da_finalizacao)
novo_controle$data_da_solicitacao = lubridate::ymd(novo_controle$data_da_solicitacao)
novo_controle$data_prazo = lubridate::ymd(novo_controle$data_prazo)
novo_controle$data_da_ultima_parcial = lubridate::ymd(novo_controle$data_da_ultima_parcial)

novo_controle |>
  dplyr::mutate(duplicidades = ifelse(is.na(duplicidades),"N/A",duplicidades)) |>
  writexl::write_xlsx('../Controle-Geral.xlsx')

novo_controle |>
  dplyr::mutate(duplicidades = ifelse(is.na(duplicidades),"N/A",duplicidades)) |>
  saveRDS(paste0('R/dep/Controle-Geral_',format(Sys.time(), "%d%m%Y"),'.rds'))

file.remove(a)

rm(list=ls())

cat("\014")

cat(crayon::green$bold(" \n \n \n  \n \n \n \n  \n \n \n  \n \n \n  \n \n \n Planilha de controle geral atualizada com sucesso!\n"))
