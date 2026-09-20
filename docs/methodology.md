# Metodología prevista y reglas de reproducibilidad

**Estado:** reglas generales. Las decisiones aplicadas al panel se explican en [Fase 3](phase3_quality.md) y en el [diccionario](phase3_dictionary.md). No contiene modelos ni parámetros estimados.

## Procedencia de archivos

Registrar cada descarga en un manifiesto con fuente oficial, URL exacta, fecha UTC, nombre original, tamaño en bytes, SHA-256, cobertura, nivel geográfico, período, licencia y notas. Conservar el original sin editar. Recalcular SHA-256 al ingresar y antes de procesar; si cambia el archivo de origen, asignar nueva versión y documentar diferencias. La plantilla está en `data/metadata/manifest_template.csv`. Nunca anotar un hash ilustrativo como real.

## Integración y controles

Unir por código DIVIPOLA, preservando ceros iniciales y documentando cambios temporales. El panel tendrá clave única municipio–año; se revisarán duplicados, años y códigos inesperados, población no positiva, faltantes, unidades y conciliación de agregados municipal/departamental/nacional. Las discrepancias no se ocultarán ni corregirán a mano. El diccionario de variables registrará fuente, definición, unidad y transformación.

## Emisiones e indicadores

Definir por separado emisiones brutas, absorciones y emisiones netas conforme a la contabilidad oficial. La identidad exacta se comprobará en el inventario; no se supondrá que una columna llamada «total» es bruta. Tasas por habitante e intensidad por valor agregado requieren denominadores positivos y compatibles. Emisiones netas cero o negativas invalidan logaritmos ordinarios y algunas tasas de cambio; se elegirá tratamiento explícito y se reportará su sensibilidad. El año 2020 se evaluará de forma separada en análisis de desacoplamiento.

## Trayectorias, espacio y modelos

La definición de desacoplamiento absoluto/relativo se basará en revisión bibliográfica y se probará con ventanas plurianuales. Los puntos de cambio y agrupaciones de trayectorias se evaluarán por estabilidad y significado, separando escala de forma. Pesos espaciales Queen/Rook o vecinos cercanos requieren justificación y tratamiento de unidades aisladas. Los modelos de referencia tendrán efectos municipales y temporales; una alternativa espacial o jerárquica se seleccionará tras evaluar estructura y diagnósticos. Toda afirmación será descriptiva o de asociación. Se analizará sensibilidad a definición de emisión, pandemia, municipios extremos, ventanas y vecindad.

## Ejecución futura

El flujo previsto usa R, `renv` para dependencias, `targets` para un pipeline y Quarto para informes. Solo se incorporarán archivos de configuración generados y probados en el entorno real. Tablas, figuras y números del manuscrito deben provenir del flujo reproducible. Las semillas aleatorias, versiones de paquetes, entorno y parámetros quedarán registrados al ejecutar análisis.
