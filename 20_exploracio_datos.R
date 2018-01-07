# EXPLORACION DE LOS DATOS -----

#exploracion dataset de establecimientos
df_stores %>% descriptive()

df_stores %>% filter(!(is.na(store_gen)))  %>% ggplot(data=.) +  aes(x = store_gen) +  geom_bar() +  theme_ctmz()
df_stores %>% filter(!(is.na(store_area))) %>% ggplot(data=.)  +  aes(x = store_area)  +  geom_bar() +  theme_ctmz() + coord_flip()

df_reserves %>% 
  select(store_id, calendar_date, reserve_visitors) %>% 
  group_by(store_id, calendar_date) %>% 
  summarise(reserve_visitors = sum(reserve_visitors, na.rm=TRUE)) %>%
  left_join(df_stores, by=c('store_id')) %>% 
  group_by(store_city, calendar_date) %>% 
  mutate(city_reserve_visitors=mean(reserve_visitors, na.rm = TRUE)) %>% 
  dplyr::filter(store_city == 'Tōkyō-to') %>% 
  unique %>% 
  na.omit %>% 
  ggplot(data=.) +
  geom_line(aes(x = calendar_date, y = log(reserve_visitors), group = store_id), colour='black', alpha=0.1) +  
  geom_line(aes(x = calendar_date, y = log(city_reserve_visitors)), colour='#226666', size=2) +  
  theme_ctmz() + scale_x_date(date_breaks = "1 month")

df_reserves %>% 
  select(store_id, calendar_date, reserve_visitors) %>% 
  group_by(store_id, calendar_date) %>% 
  summarise(reserve_visitors = sum(reserve_visitors, na.rm=TRUE)) %>%
  left_join(df_stores, by=c('store_id')) %>% 
  group_by(store_gen, calendar_date) %>% 
  summarise(type_reserve_visitors=mean(reserve_visitors, na.rm = TRUE)) %>% 
  na.omit %>% 
  ggplot(data=.) +
  geom_line(aes(x = calendar_date, y = (type_reserve_visitors), group = store_gen, colour=store_gen)) +  
  theme_ctmz() + scale_x_date(date_breaks = "1 month")

df_reserves %>% 
  select(store_id, calendar_date, reserve_visitors) %>% 
  group_by(store_id, calendar_date) %>% 
  summarise(reserve_visitors = sum(reserve_visitors, na.rm=TRUE)) %>%
  left_join(df_stores, by=c('store_id')) %>% 
  group_by(store_gen, calendar_date) %>% 
  summarise(type_reserve_visitors=mean(reserve_visitors, na.rm = TRUE)) %>% 
  na.omit %>% 
  ggplot(data=.) +
  stat_smooth(aes(x = calendar_date, y = (type_reserve_visitors), group = store_gen, colour=store_gen)) +  
  theme_ctmz() + scale_x_date(date_breaks = "1 month")

df_city_reserves %>% 
  na.omit %>% 
  ggplot(data=.) +  aes(x = calendar_date, y =reserve_visitors)  +  
  geom_line(aes(group=store_city, colour=store_city)) +  
  geom_point(aes(colour=store_city), alpha=.4) +  
  theme_ctmz() 

df_city_reserves %>% 
  dplyr::filter(store_city != 'Tōkyō-to') %>% 
  na.omit %>% 
  ggplot(data=.) +  aes(x = calendar_date, y =reserve_visitors)  +  
  geom_line(aes(group=store_city, colour=store_city)) +  
  geom_point(aes(colour=store_city), alpha=.4)  +  
  theme_ctmz() + scale_x_date(date_breaks = "1 month")

df_city_reserves %>% 
  dplyr::filter(store_city == 'Tōkyō-to') %>% 
  na.omit %>% 
  ggplot(data=.) +  aes(x = calendar_date, y =reserve_visitors)  +  
  geom_line(aes(group=store_city, colour=store_city)) +  
  geom_point(aes(colour=store_city), alpha=.4) +  
  theme_ctmz() + scale_x_date(date_breaks = "1 month")
