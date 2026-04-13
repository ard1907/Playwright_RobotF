FROM governikus/ausweisapp2

# Testperson-Karte direkt ins Image einbetten (kein Volume-Mount nötig)
# COPY Emma_Mustermann.json /sim/Emma_Mustermann.json
COPY docker2/Emma_Mustermann.json /sim/Emma_Mustermann.json

ENV AUSWEISAPP_AUTOMATIC_SIMULATOR=/sim/Emma_Mustermann.json
ENV AUSWEISAPP_AUTOMATIC_DEVELOPERMODE=true
ENV AUSWEISAPP_AUTOMATIC_PIN=123456
