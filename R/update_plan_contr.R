#' Atualiza Plan Controle
#'
#' Recebe dois dfs e retorna um novo df com as informações consolidadas.
#'
#' @param x tibble.
#'
#' @export
update_plan_contr = function(x = controle2, y = cis2) {
  # ATUALIZAR PLAN CONTROLE - BIND
  novo_controle = dplyr::bind_rows(controle2, cis2)

  novo_controle$data_da_finalizacao = lubridate::ymd(novo_controle$data_da_finalizacao)
  novo_controle$data_da_solicitacao = lubridate::ymd(novo_controle$data_da_solicitacao)
  novo_controle$data_prazo = lubridate::ymd(novo_controle$data_prazo)
  novo_controle$data_da_ultima_parcial = lubridate::ymd(novo_controle$data_da_ultima_parcial)
}
