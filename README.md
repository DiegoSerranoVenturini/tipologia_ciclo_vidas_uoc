# Tipología y ciclo de vida de los datos

## Componentes

Este trabajo está realizado por Diego Serrano Venturini de forma individual

## Ficheros práctica 1 - *web scrapping*

Los siguientes ficheros constituyen la práctica 1:

- 00_funs.R : construye las funciones que se emplearán en el flujo de generación del dataset
- 01_require_packs.R : centraliza la gestión y carga de paquetes.
- 10_conect_to_APIs.R : inicializa la conexión con las API de dónde se compondrá el dataset.
- 11_download_data.R: decargan la información de las distintas fuentes.
- main.R: orquestan la llamada en orden de los ficheros anteriores.
- *nota* : en la carpeta `./ppts` se encuentra el código que genera el reporte solicitado para la entrega.

## Ficheros práctica 2 - *limpieza y validacion de los datos*

- 00_funs.R : construye las funciones que se emplearán en el flujo de generación del dataset
- 01_require_packs.R : centraliza la gestión y carga de paquetes.
- 10_b_lectura_datos.R : carga los .csv con la información para la realización de la práctica
- 11_procesamiento_datos.R : realiza la unión de los datasets así como las transformaciones necesarias para su explotación
- practica 2.Rmd : contiene el código que genera el informe final
- practica 2.html : contiene el informe final
- 20_exploracion_datos.R : contiene el EDA inicial realizado (no el definitivo incluido en el .Rmd) 
- 21_chequeos_estadisticos.R : contiene las pruebas para la ejecución de test estadísticos al dataset
- 30_modelo_serie_temporal : contien las pruebas para la construcción del modelo