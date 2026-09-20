# Fase 1. Acceso y auditoría de fuentes

Esta fase comprobó que existe una serie municipal de emisiones utilizable entre 1990 y 2024. También localizó valor agregado, población y códigos oficiales. Aún no se construyó el panel ni se estimaron relaciones entre variables.

## Archivos y procedencia

El usuario descargó `INGEI_1990-2024.zip` y lo entregó en la carpeta Descargas del equipo. Se movió sin alterar a `data/raw/ideam/`. El enlace de OneDrive identifica la carpeta de publicación, pero requiere acceso institucional en la sesión probada. No conocemos la URL de descarga del ZIP individual ni hemos verificado su licencia. El ZIP pesa 13,26 GB y contiene 61 archivos. Se extrajeron solamente la tabla municipal GEI de 3,30 GB, un consolidado nacional y una infografía. Los demás archivos permanecen dentro del ZIP.

Se obtuvieron del sitio oficial de DANE cinco libros pequeños con valor agregado municipal y población por periodos, y un JSON de atributos de DIVIPOLA 2025 sin geometrías. `R/download/download_dane.R` conserva las direcciones exactas. El manifiesto `data/metadata/manifest.csv` anota fecha, tamaño y SHA-256 de los diez archivos conservados. Las licencias de redistribución siguen pendientes de revisión. Los originales están fuera de Git y se usan sin modificación.

## Qué muestran las tablas

La tabla GEI contiene 7.715.302 filas y cubre 1986–2024. Cada año de 1990 a 2024 incluye los mismos 1.122 códigos territoriales, sin códigos municipales ni valores de CO2 equivalente ausentes en las columnas auditadas. Los años 1986–1989 tienen solo 312 códigos y corresponden a registros de metano del sector residuos. Por ahora se dejan fuera de la ventana principal. La cobertura de una columna no garantiza que cada actividad o gas se mida con idéntico detalle en todos los años.

Los códigos de la tabla GEI coinciden exactamente con los 1.122 registros del servicio DIVIPOLA 2025 consultado. Este servicio clasifica 1.103 como municipios, 18 como áreas no municipalizadas y uno como isla. La decisión sobre el universo analítico, las geometrías y los cambios históricos corresponde a la Fase 2.

El libro DANE de valor agregado municipal cubre 2011–2024. Tiene 1.123 códigos con valores numéricos para cada año. Sus valores están a precios corrientes, en miles de millones de pesos y con referencia 2015. DANE distribuye valor agregado departamental entre municipios, de modo que no conviene describir esta cifra como un PIB municipal observado de forma independiente. Una variación nominal entre años no demuestra crecimiento económico real ni desacoplamiento. Habrá que elegir un ajuste de precios apropiado antes de construir esos indicadores.

La población se publica en cuatro libros que cubren 1985–1994, 1995–2004, 2005–2017 y 2018–2042. Los libros antiguos no tienen el mismo orden de columnas. El de 2018–2042 tiene 1.123 códigos en 2024. Tanto este libro como el de valor agregado incluyen el código adicional `94663`, ausente en IDEAM y en la consulta DIVIPOLA utilizada. Los libros de población anteriores a 2018 omiten el código `27493` presente en IDEAM y contienen `94663`. En consecuencia, la unión histórica requiere reglas explícitas y un recuento de pérdidas por año. No se harán uniones por nombre.

## Comprobación de magnitudes

Como control preliminar se sumó `Valor_CO2eq` y se separó `CO2_ABS` como absorciones. En 2024 la suma bruta es 297.058,7 kt CO2e, las absorciones son −20.325,9 kt CO2e y la suma neta es 276.732,8 kt CO2e. Coinciden, al redondeo publicado, con las cifras nacionales que [IDEAM divulgó para 2024](https://www.ideam.gov.co/index.php/sala-de-prensa/noticia/colombia-revela-por-primera-vez-34-anos-de-emisiones-de-gases-de-efecto-invernadero-con-cifras-para). En 1990 la misma operación da 230.777,1 kt brutas, −5.746,7 kt de absorciones y 225.030,4 kt netas. Esta conciliación comprueba unidades y alcance a nivel nacional, pero todavía no fija una definición analítica municipal para todos los sectores.

Los controles pequeños de cobertura, categorías, códigos y totales están en `data/metadata/`. Se regeneran con `R/cleaning/audit_ideam.R` y `R/cleaning/check_ideam_totals.R`. Los códigos se leen como texto para conservar los ceros iniciales.

## Puerta de avance y pendientes

Se cumple la condición de acceso a una tabla municipal GEI para 1990–2024 y existen fuentes núcleo DANE para 2011–2024. La obtención automática del ZIP IDEAM aún no es reproducible sin un enlace individual accesible; el manifiesto documenta la entrega manual y permite comprobar que se trabaja con los mismos bytes. Antes de publicar datos o materiales suplementarios hay que confirmar sus licencias y atribuciones. La Fase 2 deberá resolver el universo territorial, los códigos discordantes, los cambios de DIVIPOLA y las geometrías. La Fase 3 deberá conciliar las series, unidades y definiciones antes de producir indicadores. No se han estimado modelos ni se han extraído conclusiones de política pública.
