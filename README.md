# QBOX Scenes

Scenes lar deg plassere drawtext hvor som helst i verden via en NUI-meny og laserpeker. Teksten kan inneholde emojis, være flersidig og støtter markdown. Du kan forhåndsvise og redigere scener før plassering.

## Oppsett

1. Importer `scenes.sql` i databasen.
2. Juster innstillinger i `shared/config.lua`.
3. (Valgfritt) Legg til `['scenes'] = 'webhookhere'` i `qb-logs` for logging.

## Funksjoner

* Lag og slett 3D drawtext med NUI og laserpeker
* Tilpass tekst, farge, synlighetsavstand, utløpstid, skriftstørrelse og stil
* Forhåndsvis og rediger scener før plassering
* Scener lagres i databasen og slettes automatisk ved utløp
* Markdown, emojis og flere linjer støttes

## Eksempel

![Interface](https://files.fivemerr.com/images/077ae227-ecee-47c3-afb3-84c6396951df.png)

## ToDo 
Bytte logging om til noe annet enn discord webhook 😠 xD (#Møkk)

## Kreditering

* Original ressurs: [ItsANoBrainer](https://github.com/ItsANoBrainer)
* Norsk oversettelse og UI-endringer: **corerp-git**

## Lisens

[GNU GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
