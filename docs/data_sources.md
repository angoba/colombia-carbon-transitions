# Fuentes de datos

La auditoría y sus hallazgos están en [Fase 1](phase1_data_audit.md). Las direcciones exactas, fechas, tamaños y hashes SHA-256 de cada archivo conservado están en `data/metadata/manifest.csv`. Los originales permanecen en `data/raw/` y no se suben a Git.

| Fuente | Archivo usado | Cobertura comprobada | Uso previsto y cuidado pendiente |
|---|---|---|---|
| IDEAM, INGEI | ZIP entregado por el usuario, tabla municipal GEI y consolidado nacional extraídos | 1.122 códigos, 1990–2024 completos en las columnas auditadas | Separar emisiones brutas y absorciones. Confirmar licencia, metodología y enlace directo de descarga. |
| DANE, valor agregado municipal | Anexo PIB departamental y VAM | 2011–2024, 1.123 códigos | Precios corrientes. Elegir tratamiento de inflación antes de estudiar desacoplamiento. |
| DANE, población municipal | Cuatro libros de proyecciones y series históricas | 1985–2042 en tramos; diferencias de códigos entre periodos | Homologar códigos y precisar población usada como denominador. |
| DANE, DIVIPOLA 2025 | Consulta de atributos del servicio geográfico | 1.122 códigos, sin geometrías | Decidir tratamiento de áreas no municipalizadas e isla, y revisar cambios históricos. |

La [carpeta IDEAM en OneDrive](https://ideamcol-my.sharepoint.com/personal/estudios_ideam_gov_co/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Festudios%5Fideam%5Fgov%5Fco%2FDocuments%2F600%20SEA%2FPublicaciones%2FINGEI%5F1990%2D2024&ga=1) no es una URL directa de descarga del archivo. La consulta institucional redirigió a inicio de sesión. El [sitio DANE de cuentas departamentales](https://www.dane.gov.co/index.php/estadisticas-por-tema/cuentas-nacionales/cuentas-nacionales-departamentales) y el [servicio DIVIPOLA](https://geoportal.dane.gov.co/mparcgis/rest/services/Divipola/Serv_DIVIPOLA_MGN_2025/FeatureServer/317) permiten localizar las otras fuentes. Bosque, minería y TerriData siguen como fuentes candidatas para fases posteriores.
