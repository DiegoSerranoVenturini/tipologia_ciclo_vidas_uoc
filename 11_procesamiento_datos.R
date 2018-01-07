# PROCESAMIENTO DATOS LEIDOS ----

#join de los datasets de restaurantes
df_stores            <- 
  full_join(df_store_id_relation, df_air_store_info %>% mutate(air_lat = latitude, air_long = longitude) %>% select(-latitude, -longitude), by=c("air_store_id")) %>%
  full_join(., df_hpg_store_info, by=c("hpg_store_id")) %>% 
  mutate(hpg_lat  = latitude, hpg_long = longitude) %>% 
  select(-latitude, -longitude) %>% 
  mutate(
    store_id    = ifelse(is.na(air_store_id), hpg_store_id, air_store_id)
    ,store_lat  = ifelse(is.na(air_lat),  hpg_lat,  ifelse(is.na(hpg_lat),  air_lat,  (hpg_lat + air_lat)/2 ))
    ,store_long = ifelse(is.na(air_long), hpg_long, ifelse(is.na(hpg_long), air_long, (hpg_long + air_long)/2 ))
    ,store_area = ifelse(is.na(air_area_name), hpg_area_name, air_area_name)
    ,store_city = substr(store_area, 0, regexpr(' ', store_area)-1)
    ,store_gen  = ifelse(is.na(air_genre_name), hpg_genre_name, air_genre_name)
  ) %>% 
  select(-air_store_id, -hpg_store_id, -hpg_area_name, -air_area_name, -air_lat, -air_long, -hpg_lat, -hpg_long, -hpg_genre_name, -air_genre_name)  

#join de las series temporales de las reservas
df_reserves <-
  full_join(df_store_id_relation, df_hpg_reserve, by = c("hpg_store_id")) %>% 
  mutate(reserve_visitors_hpg = reserve_visitors) %>% 
  select(-reserve_visitors, -reserve_datetime) %>% 
  full_join(., df_air_reserve, by = c('air_store_id', 'visit_datetime')) %>% 
  mutate(reserve_visitors_air = reserve_visitors) %>% 
  select(-reserve_visitors, -reserve_datetime) %>% 
  mutate(
    reserve_visitors_hpg = ifelse(is.na(reserve_visitors_hpg), 0, reserve_visitors_hpg)
    ,reserve_visitors_air = ifelse(is.na(reserve_visitors_air), 0, reserve_visitors_air)
    ,reserve_visitors     = reserve_visitors_air + reserve_visitors_hpg
    ,calendar_date        = visit_datetime %>% as.Date(format='%Y-%m-%d')
  ) %>% 
  left_join(., df_date_info %>% mutate(calendar_date = calendar_date %>% as.Date(format='%Y-%m-%d')), by = c('calendar_date')) %>% 
  mutate(store_id = ifelse(is.na(air_store_id), hpg_store_id, air_store_id)) %>% 
  select(-air_store_id, hpg_store_id)

df_city_reserves <- 
  df_reserves %>% 
  select(store_id, calendar_date, reserve_visitors, holiday_flg) %>% 
  group_by(store_id, calendar_date) %>% 
  summarise(
    reserve_visitors = sum(reserve_visitors, na.rm=TRUE)
    , holiday        = max(holiday_flg, na.rm =TRUE)) %>%
  left_join(df_stores, by=c('store_id')) %>% 
  group_by(store_city, calendar_date) %>% 
  summarise(reserve_visitors=sum(reserve_visitors, na.rm = TRUE), holiday = max(holiday, na.rm =TRUE)) %>% 
  arrange(store_city, calendar_date) %>% 
  mutate(
    wd       = weekdays(calendar_date)
    ,day_to  = lead(wd)
    ,hld_to  = lead(holiday)
    ,visper  = ifelse(holiday==0 & ( day_to == 'sábado' | hld_to ==1 ), 1, 0)  
  ) %>% 
  select(-day_to, -hld_to)

#limpieza de datos en memoria
remove(df_store_id_relation, df_air_store_info, df_hpg_store_info, df_date_info); gc()
