#fijamos aquellas empresas de las que queremos información
equities <- c('NVDA','AMD', 'INTC', 'TSLA')

# descargamos los datos relativos a las acciones de interés:
equities_ts <- data.frame()
for(equity in equities)
{
  equities_ts <- rbind(equities_ts, downloadEquities(equity))
}

# descargamos los datos relativos a búsquedas en google de las empresas elegidas:
lang_trend <- gtrends(c("Nvidia", "Intel", 'AMD', 'Tesla'), time = 'all')

# descargamos los datos relativos a tweets en Twitter de las empresas elegidas
tw = twitteR::searchTwitter("Nvidia", n = 1e4, retryOnRateLimit = 1e3)
d = twitteR::twListToDF(tw)
