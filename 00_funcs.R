#funcion encargada de cargar o instalar los paquetes necesarios
loadOrInstallLibraries <- function(.library)
{
  if(require(.library, character.only = TRUE)==FALSE)
  {
    install.packages(.library)
    require(.library, character.only = TRUE)
  }else
  {
    require(.library, character.only = TRUE)
  }
}

#funcion para la descarga de acciones
# descarga historico -----
downloadEquities <- function(equity, src='WIKI', window.start='1800-01-01', window.end='9999-12-31')
{
  start_time <- Sys.time()
  print(paste('Descargando: ', equity))
  
  code          <- paste0(src, '/', equity)
  equity_var    <- 'Adj. Close'; 
  Date          <- 'Date'
  
  tryCatch(
    {
      df.downloaded <- 
        Quandl(code = code, collapse = 'daily', transform = 'rdiff') %>% 
        select(Date, matches(equity_var)) %>% 
        set_names(c('Date', 'Cl')) %>% 
        mutate(Equity=equity) %>% 
        filter( (Date > (window.start %>% as.Date)) & (Date < (window.end %>% as.Date))) %>% 
        mutate(Date= Date %>% as.Date())
      return(df.downloaded)
    },
    error = function(e) 
    {
      return(data.frame)
    })
}
