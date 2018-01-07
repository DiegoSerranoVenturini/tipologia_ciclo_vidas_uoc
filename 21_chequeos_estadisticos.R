# ANALISIS DE LOS DATOS -----
df_city_reserves %>% 
  na.omit %>% 
  ggplot(data=.) +  aes(x = log(reserve_visitors))  +  
  geom_density(aes(group=store_city, fill=store_city), alpha=.4)


## chequeos estadísticos ----

# Puesto que se trata de una serie temporal vamos a realizar los siguientes tests:
# 1. Normalidad de la serie: nos indicara si la serie temporal tiene una estructura 'blanca'
# 2. Normalidad del logaritmo de la serie: cuando los valores de la serie varia en órdenes de magnitud de 10E3 es conveniente analizar el logaritmo para 'normalizar' los posibles valores extremos
# 3. Autocorrelación de la serie: nos indica si los valores de la serie dependen de momentos en el pasado de la misma
# 4. Varianza condicional de la serie: muchas series temporales muestran autocorrelación no solo en los valores de la propia serie si no en la varianza de la misma. Esto se muestra frecuentemente en series con mucha inercia como los activos financieros, las ventas de productos
# de moda, etc. A menudo la metodología de testeo es constuir un modelo arima y chequear si existen efectos 'ARCH' en los residuos. Es posible también anticipar estos efectos analizando la autocorrelación de la varianza de la serie 'de-tendenciada'.

# resultados tests

for(city in (df_city_reserves %>% na.omit %>% pull(store_city) %>% unique))
{
  shapiro_test <- 
    df_city_reserves %>% 
    dplyr::filter(store_city == city) %>% pull(reserve_visitors) %>% 
    shapiro.test()
  
  if(shapiro_test$p.value<0.05)
  {
    cat(paste0('Las reservas en ', city, ' no se distribuyen siguiendo una normal.\n'))
  }else{
    cat(paste0('Las reservas en ', city, ' se distribuyen siguiendo una normal.\n'))
  }
  
  shapiro_test <- 
    df_city_reserves %>% 
    dplyr::filter(store_city == city) %>% pull(reserve_visitors) %>% log %>% 
    shapiro.test()
  
  if(shapiro_test$p.value<0.05)
  {
    cat(paste0('El log de las reservas en ', city, ' no se distribuyen siguiendo una normal.\n'))
  }else{
    cat(paste0('El log de las reservas en ', city, ' se distribuyen siguiendo una normal.\n'))
  }
  
  ts <- 
    df_city_reserves %>% 
    dplyr::filter(store_city == city) %>% 
    pull(reserve_visitors) %>% 
    log() %>% 
    as.ts()
  
  p <- acf(ts)
  plot(p, main = paste0(city, ': plot correlación temporal'))
  
  box_tst <- Box.test(ts)
  
  if(box_tst$p.value<0.05)
  {
    cat(paste0('El log de las reservas en ', city, ' muestran correlación temporal.\n'))
  }else{
    cat(paste0('El log de las reservas en ', city, ' no muestran correlación temporal.\n'))
  }
  
  ret <- diff(ts)
  var=(ret-mean(ret))^2
  plot(var, main = paste0(city, ': varianza de la diferencia entre días'))
  
  box_tst1 <- Box.test(var,lag=26,type='Ljung')
  
  if(box_tst1$p.value<0.05)
  {
    cat(paste0('la serie de las reservas en ', city, ' muestran efectos de varianza condicionada.\n'))
  }else{
    cat(paste0('la serie de las reservas en ', city, ' no muestran efectos de varianza condicionada.\n'))
  }
  
  cat('\n----------------------------------------------------------------------------------\n\n')  
}

