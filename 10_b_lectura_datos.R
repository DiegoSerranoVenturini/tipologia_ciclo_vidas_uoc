# definición de la ruta a los conjuntos de datos
pathdata <- paste0(getwd(),'/data/')

# LECTURA DE DATOS ----

# *air_reserve.csv*: contiene las reservas realizadas en el sistema **air**
df_air_reserve       <- read.csv(file=paste0(pathdata, 'air_reserve.csv')) %>% mutate_if(is.factor, as.character)
# *hpg_reserve.csv*: contiene las reservas realizadas en el sistema **hgd**
df_hpg_reserve       <- read.csv(file=paste0(pathdata, 'hpg_reserve.csv')) %>% mutate_if(is.factor, as.character)
# *air_store_info.csv*: contiene información acerca de los restaurantes en **air**
df_air_store_info    <- read.csv(file=paste0(pathdata, 'air_store_info.csv')) %>% mutate_if(is.factor, as.character)
# *hgd_store_info.csv*: contiene información acerca de los restaurantes en **hgd**
df_hpg_store_info    <- read.csv(file=paste0(pathdata, 'hpg_store_info.csv')) %>% mutate_if(is.factor, as.character)
# *store_id_relation.csv*: contiene el cruce de claves de ambos sistemas
df_store_id_relation <- read.csv(file=paste0(pathdata, 'store_id_relation.csv')) %>% mutate_if(is.factor, as.character)
# *air_visit_data.csv*: contiene las visitas históricas del sistema **air**
df_air_visit_data    <- read.csv(file=paste0(pathdata, 'air_visit_data.csv')) %>% mutate_if(is.factor, as.character)
# *date_info.csv*: contiene información sobre las fechas y fiestas
df_date_info         <- read.csv(file=paste0(pathdata, 'date_info.csv')) %>% mutate_if(is.factor, as.character)








