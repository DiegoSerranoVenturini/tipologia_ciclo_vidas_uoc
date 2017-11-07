#fijamos aquellas empresas de las que queremos información
equities <- c('NVDA','AMD', 'INTC', 'TSLA')

# descargamos los datos relativos a las acciones, a búsquedas en google y a tweets en Twitte de las empresas de interés:
equities_ts <- data.frame()
for(equity in equities)
{
  equity_finance <- downloadEquities(equity)
  equity_finance <- equity_finance %>% mutate(Date = paste0(year(Date), '-', month(Date), '-01') %>% as.Date(format='%Y-%m-%d')) %>% 
    group_by(Date) %>% 
    summarise(Equity=equity, mCl=mean(Cl, na.rm = TRUE), sdCl = sd(Cl, na.rm = TRUE))
  
  equity_trend <- gtrends(equity, time = 'all', geo = 'US')
  equity_trend <- equity_trend$interest_over_time %>% select(date, hits) %>% set_names(c('Date', 'hits')) %>% mutate(Equity=equity)
  
  equity_tw    <- twitteR::searchTwitter(equity,  n = 1e6, retryOnRateLimit = 1e3) %>% 
    twListToDF() %>% 
    mutate(Date=created %>% as.Date(format='%Y-%m-%d'), Date = paste0(year(Date), '-', month(Date), '-01') %>% as.Date(format='%Y-%m-%d')) %>% 
    group_by(Date) %>% 
    summarise(num_tws = n(), num_rts = sum(retweetCount), Equity=equity)
  
  equity_df <- full_join(equity_finance, equity_trend, by=c('Date', 'Equity')) %>% full_join(., equity_tw, by=c('Date', 'Equity'))
  equities_ts <- rbind(equities_ts, equity_df)
}

save(list = 'equities_ts', file = 'equities_ts.RData')
write.csv(equities_ts, file = 'equities.csv')
