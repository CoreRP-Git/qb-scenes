Config = {}

-- Kun administratorer kan plassere scener (true = kun admin, false = alle)
Config.AdminOnly = false  

-- Maksimal avstand man kan plassere en scene (i meter)
Config.MaxPlacementDistance = 10.0  

-- Hvor ofte skriptet skal sjekke etter utløpte scener (i millisekunder)
-- Standard: 1000 * 60 * 60 = hver 1. time
Config.AuditInterval = 1000 * 60 * 60  
