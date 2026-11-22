-- =========================================================
-- 03 - Création des variables
-- =========================================================

-- ---------------------------------------------------------
-- Somme molaire des 4 métabolites du DEHP (µmol/L)
-- Chaque concentration est divisée par la masse molaire du métabolite
-- (MEHP 278,3 ; MEHHP 294,3 ; MEOHP 292,3 ; MECPP 308,3 g/mol)
-- ---------------------------------------------------------
ALTER TABLE echantillon
ADD COLUMN phtalates_somme numeric;

UPDATE echantillon
SET phtalates_somme = urxmhp / 278.3 + urxmhh / 294.3 + urxmoh / 292.3 + urxecp / 308.3;
