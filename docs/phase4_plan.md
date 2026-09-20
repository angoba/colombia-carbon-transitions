# Fase 4. Descripción de las trayectorias

## Pregunta y alcance

Queremos describir cómo cambiaron las emisiones entre territorios colombianos y qué diferencias aparecen al mirar sectores, población y actividad económica. Esta fase orienta las preguntas del artículo. No atribuye efectos a políticas ni estima modelos explicativos o predictivos.

La fuente de emisiones es el inventario municipal IDEAM 1990–2024. El panel de la fase 3 une población y valor agregado municipal (VAM) de DANE. El VAM disponible cubre 2011–2024 y está en precios corrientes. Las cifras monetarias se compararán entre municipios dentro de cada año. No se interpretará su cambio entre años como crecimiento real.

## Protocolo antes de mirar resultados

1. Comprobar los SHA-256 del panel y detalle sectorial con `data/metadata/phase3_products.csv`. Comprobar clave única, 1.122 códigos por cada año y conciliación con los controles nacionales y sectoriales de fase 3. Si falla un control, detener el análisis.
2. Mantener los 1.122 códigos del inventario para totales. Mostrar por separado los 1.103 clasificados como municipios en DIVIPOLA 2025, las 18 áreas no municipalizadas y la isla. La clasificación de 2025 es solo una referencia contemporánea.
3. Usar emisiones brutas, absorciones firmadas y emisiones netas en kt CO₂e. No tomar el logaritmo ordinario de emisiones netas, que pueden ser nulas o negativas. Distinguir siempre emisiones brutas de netas.
4. Presentar niveles y composición sectorial desde 1990 hasta 2024, con las cinco categorías IDEAM/IPCC. Examinar cambios de varios años y 2020 como año especial, sin darles una interpretación causal automática.
5. Para tasas por habitante, mostrar cobertura anual desde 1990 y usar 2008–2024 como ventana principal de alta cobertura. Usar 2001–2024 como sensibilidad. Los años previos se conservan para emisiones absolutas y se pueden mostrar con su cobertura explícita. La tasa agregada se calcula dividiendo la suma de emisiones admisibles por la suma de población admisible; no promediando tasas municipales.
6. Describir distribución territorial por año con mediana, cuantiles, extremos y concentración. Separar nivel absoluto de tasa por habitante. Los resultados sensibles a unidades pequeñas o denominadores serán señalados.
7. Describir trayectorias locales por nivel, dirección, variación y mezcla sectorial. Para ejemplos, declarar antes el criterio de selección y mostrar casos contrastantes. No definir todavía éxito, fracaso o desacoplamiento.
8. Leer las actividades económicas del archivo VAM ya conservado. Comprobar unidades, cobertura y si la suma de actividades reproduce el total antes de calcular participaciones primaria, secundaria y terciaria. Las categorías económicas no se equiparan automáticamente con las categorías IPCC.
9. Revisar los 30 saltos señalados en fase 3 por sector y fuente. Registrar qué se puede explicar con los archivos disponibles y qué queda incierto. No corregir valores sin evidencia documental.
10. Hacer mapas solo después de obtener una geometría oficial, verificar códigos, topología y licencia, y fechar la versión de límites. Si eso no se resuelve, la fase puede cerrar con figuras no espaciales y dejar los mapas como pendiente declarado.

## Productos

- Scripts R breves y ejecutables desde la raíz del proyecto para cada tabla y figura.
- Tablas pequeñas de cobertura, serie nacional, sectores, distribución y concentración, con unidades, muestra y fuente.
- Figuras legibles e informe Quarto que enlace cada cifra con su cálculo.
- Revisión de saltos y una bitácora de hallazgos, dudas y decisiones. Los derivados grandes siguen fuera de Git.

## Puerta de avance

Cada cifra y figura tendrá fuente, unidad, periodo, universo y número de observaciones claros. Las cifras nacionales volverán a conciliar con fase 3. Las excepciones territoriales y los años con denominadores débiles se verán en las salidas. Se revisarán los saltos destacados y se comprobará si las conclusiones descriptivas cambian al restringir ventanas o tipos de territorio. Solo entonces se propondrá la fase 5.

## Estado para retomar el trabajo

- **Aprobación**: el usuario aprobó la fase 4 el 20 de septiembre de 2026.
- **Último punto completado antes de empezar**: fase 3, commit `45b54cb`; panel y detalle sectorial locales, hashes registrados.
- **Orden de trabajo**: controles, series y distribución; composición y trayectorias; VAM y revisión de saltos; mapas si la geometría pasa controles; informe y sensibilidad.
- **Regla de seguimiento**: actualizar este apartado al cerrar cada bloque con archivos generados, controles superados, hallazgos y pendientes. No declarar cerrada la fase por tener solo las primeras figuras.

### Avance del 20 de septiembre de 2026

El script `R/figures/phase4_describe.R` ya comprueba SHA-256 de los dos productos de fase 3, clave única, cobertura anual, identidad bruto + absorciones = neto y conciliación nacional y sectorial. Escribe seis tablas en `outputs/tables/` y dos figuras en `outputs/figures/`. Estos productos permanecen fuera de Git y se regeneran con el script.

La primera lectura da 230.777 kt CO₂e brutas en 1990 y 297.059 en 2024, sumando los 1.122 códigos. Diez territorios concentran 27,47 % de las emisiones brutas en 1990 y 22,46 % en 2024. Son descripciones iniciales; aún falta estudiar cuánto depende la comparación del universo, la composición sectorial y los casos extremos.

Para tasas, `gross_without_rate_pct` incluye todo lo que no tiene tasa admisible, también la asignación histórica de Barrancominas. Por eso da 5,78 % en 1990 frente al 5,69 % de fase 3, que contaba solo población ausente o cero. La misma diferencia aparece en 2008 y 2011 aunque es pequeña. Ambas medidas deben llevar un nombre distinto en tablas y texto.

**Siguiente bloque**: revisar composición sectorial y distribución por tipos de territorio, estudiar trayectorias locales sin elegir ejemplos por conveniencia y abrir el libro VAM para comprobar las actividades económicas. Después revisar saltos, sensibilidad e informe. Mapas condicionados a geometría oficial validada. La fase sigue abierta.
