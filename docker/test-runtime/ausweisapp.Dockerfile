FROM governikus/ausweisapp2

COPY docker/tests/Emma_Mustermann.json /sim/Emma_Mustermann.json

ENV AUSWEISAPP_AUTOMATIC_SIMULATOR=/sim/Emma_Mustermann.json
ENV AUSWEISAPP_AUTOMATIC_DEVELOPERMODE=true
ENV AUSWEISAPP_AUTOMATIC_PIN=123456
