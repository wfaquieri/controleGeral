#' Import plan controle geral 
#'
#' Leitura dos dados de controle de solicitacoes
#'
#' @param x tibble.
#'
#' @export
read_contr = function(x=controle){
  # Planilha de Controle Geral de Solicitações
  controle = readxl::read_excel(dir(path = '.', pattern = "Controle-Geral_", full.names = TRUE),
                                col_types = c("text", "text", "text",
                                              "text", "text", "text", "text", "text",
                                              "text", "text", "text", "text", "date",
                                              "date", "text", "text", "numeric",
                                              "numeric", "text", "date", "date",
                                              "text", "text"))
}
