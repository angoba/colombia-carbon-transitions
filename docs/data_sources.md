# Fuentes de datos propuestas

**Estado:** inventario preliminar de Fase 0. Disponibilidad, cobertura, licencia, tamaño, ruta de descarga y nivel municipal aún requieren auditoría. Ningún dato se ha descargado.

| Fuente | Uso previsto | Ventana esperada | Comprobación necesaria |
|---|---|---|---|
| IDEAM / INGEI / SINGEI | Emisiones y absorciones GEI por municipio y sector | 1990–2024 | Verificar exportación municipal completa, formato, definiciones bruta/neta, revisión y licencia. |
| DANE, valor agregado municipal (VAM) | Actividad económica y denominador de intensidad | 2011–2024 | Verificar serie, precios, revisiones, desagregación sectorial y códigos. |
| DANE, población municipal | Tasas por habitante | 1990–2024 | Verificar estimaciones/proyecciones, cobertura y compatibilidad temporal. |
| DANE, DIVIPOLA / Marco Geoestadístico Nacional | Identificadores y geometrías | Variable | Verificar cambios de códigos, vigencia de geometrías y áreas no municipalizadas. |

**Acceso IDEAM mencionado por el equipo:** [carpeta INGEI 1990–2024 en OneDrive](https://ideamcol-my.sharepoint.com/personal/estudios_ideam_gov_co/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Festudios%5Fideam%5Fgov%5Fco%2FDocuments%2F600%20SEA%2FPublicaciones%2FINGEI%5F1990%2D2024&ga=1). Este enlace identifica una posible ubicación; no se ha validado el contenido ni la posibilidad de descarga programática. También se mencionó [Inventario Departamental GEI](https://www.datos.gov.co/Ambiente-y-Desarrollo-Sostenible/Inventario-Departamental-Gases-Efecto-Invernadero/sx6m-p6bv/about_data), cuyo nivel departamental no sustituye la tabla municipal requerida.

**Fuentes complementarias posteriores:** cobertura de bosque/uso del suelo IDEAM, minería ANM y TerriData. Se incluirán solo variables elegidas por su relación con la pregunta y con calidad suficiente. La matrícula de vehículos RUNT no se asumirá como medida directa de circulación o emisiones locales.

Para cada fuente, la Fase 1 completará URL oficial exacta, fecha de consulta, responsable, cobertura comprobada, licencia y notas de acceso en `config/sources.yml` y en el manifiesto de archivos.
