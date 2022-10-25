#' Import cis
#'
#' Leitura dos dados de cis
#'
#' @param x tibble.
#'
#' @export
read_cis = function(x=cis){
  a = dir(path = 'input', pattern = "CI_", full.names = TRUE)

  n <- length(a)

  cis =
    purrr::map_df(
      1:n,
      ~ readxl::read_xlsx(
        a[.x],
        range = readxl::cell_cols("A:AP"),
        col_types = "text"
      )
    )
}
