saving_plan = function(x=novo_controle) {

  novo_controle |>
    dplyr::mutate(duplicidades = ifelse(is.na(duplicidades),"N/A",duplicidades)) |>
    # writexl::write_xlsx(paste0('Controle-Geral_',format(Sys.time(), "%d%m%Y"),'.xlsx'))
    writexl::write_xlsx('Controle-Geral.xlsx')

  novo_controle |>
    dplyr::mutate(duplicidades = ifelse(is.na(duplicidades),"N/A",duplicidades)) |>
    saveRDS(paste0('dep/Controle-Geral_',format(Sys.time(), "%d%m%Y"),'.rds'))

}
