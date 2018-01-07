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

#definición estilo:
theme_ctmz <- function(size_font=10, font='Helvetica')
{
  theme_classic(
    base_size = size_font, base_family = font)+
    theme(
      axis.line       = element_line(colour = "black", size = 0.5, linetype = "dashed"),
      legend.position = 'top',
      axis.text.x     = element_text(angle = 45, size = size_font)
    )
}

# funcion para la transformacion de las series temporales (limpiando outliers)
transform_series <- function(df)
{
  ts          <- df %>% as.data.frame %>% select(calendar_date, reserve_visitors) %>% mutate(reserve_visitors = (reserve_visitors))
  ts          <- ts(ts$reserve_visitors, start=c(2016,1,1), frequency=365)
  ts_outliers <- tsoutliers(ts)
  
  if(length(ts_outliers$index)>0)
  {
    ts_modified <- ts %>% as.data.frame() %>% mutate(index = row_number()) %>% left_join(., cbind(index=ts_outliers$index, replacement=ts_outliers$replacements) %>% as.data.frame(), by=c('index')) %>% 
      mutate(x = ifelse(is.na(replacement), x, replacement)) %>% pull(x) %>% as.vector()
  }else{
    ts_modified <- ts %>% as.vector()
  }
  
  df$reserve_visitors <- ts_modified
  
  return(df)
}
