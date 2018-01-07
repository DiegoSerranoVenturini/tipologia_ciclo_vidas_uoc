ts_train <- 
  df_city_reserves %>% 
  dplyr::filter(store_city == city) %>% 
  # filter(calendar_date < '2017-01-01') %>% 
  pull(reserve_visitors) %>% 
  log() %>% 
  as.ts()

arima_fit <- auto.arima(ts)

ts_test <-
  df_city_reserves %>% 
  dplyr::filter(store_city == city) %>% 
  filter(calendar_date >= '2017-01-01') %>% 
  pull(reserve_visitors) %>% 
  as.ts()

accuracy((predict(arima_fit, n.ahead = 151))$pred %>% as.vector %>% log %>% as.ts, ts_test) 
