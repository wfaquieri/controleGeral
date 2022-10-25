#' Import cis
#'
#' Recebe um df e retorna um novo df transformado.
#'
#' @param x tibble.
#'
#' @export
wrangling_cis = function(x = cis){

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

# Matriz com a origem e o elementar:
w = unique(controle[,c(1,5)])

# date format
cis$data_da_finalizacao = as.Date(cis$data_da_finalizacao)
cis$data_da_solicitacao = as.Date(cis$data_da_solicitacao)
cis$data_prazo = as.Date(cis$data_prazo)
cis$data_da_ultima_parcial = as.Date(cis$data_da_ultima_parcial)

# Preencher a coluna de duplicidade com a origem anterior:
cis2 = cis |>
  dplyr::left_join(w, by = "elementar") |>
  dplyr::mutate(
    duplicidades = ifelse(is.na(origem.y),duplicidades, origem.y)
  ) |> dplyr::select(-origem.y) |> dplyr::rename(origem = origem.x)

}
