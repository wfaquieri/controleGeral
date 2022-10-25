#' Clean Description
#'
#' Recebe um df e retorna um df com a descricao solicitada em um formato 'clean'
#'
#' @param x tibble.
#'
#' @export
clean_descr = function(x = controle){
  controle2 = controle |>
    dplyr::mutate(
      descricao_solicitada = gsub("\\s+"," ", descricao_solicitada),
      descricao_solicitada = stringi::stri_trans_general(descricao_solicitada,"latin-ascii"),
      descricao_solicitada = stringr::str_to_upper(descricao_solicitada)
    )
}
