-- =========================================================
-- 01 - Identification des femmes sous traitement hormonal
-- (à exclure de l'analyse : la contraception hormonale modifie
--  fortement la testostérone et la SHBG)
-- =========================================================
-- Source : fichier des médicaments NHANES (RXQ_RX), une ligne par médicament.
-- Un médicament est retenu si l'un de ses 3 motifs de prescription parle d'hormones
-- OU si son nom contient une hormone contraceptive.


-- ---------------------------------------------------------
-- Contrôle : liste détaillée des médicaments retenus
-- (une ligne par médicament, pour vérifier à l'œil ce qui est sélectionné)
-- ---------------------------------------------------------
CREATE TABLE contraception_1 AS (
SELECT seqn, rxddrug, rxdrsd1
FROM medicaments_1
WHERE rxdrsd1 ILIKE '%hormon%'
   OR rxdrsd2 ILIKE '%hormon%'
   OR rxdrsd3 ILIKE '%hormon%'
   OR rxddrug ILIKE ANY (ARRAY['%ethinyl estradiol%', '%levonorgestrel%', '%norethindrone%',
                               '%drospirenone%', '%norgestimate%', '%desogestrel%',
                               '%medroxyprogesterone%', '%etonogestrel%']));

CREATE TABLE contraception_2 AS (
SELECT seqn, rxddrug, rxdrsd1
FROM medicaments_2
WHERE rxdrsd1 ILIKE '%hormon%'
   OR rxdrsd2 ILIKE '%hormon%'
   OR rxdrsd3 ILIKE '%hormon%'
   OR rxddrug ILIKE ANY (ARRAY['%ethinyl estradiol%', '%levonorgestrel%', '%norethindrone%',
                               '%drospirenone%', '%norgestimate%', '%desogestrel%',
                               '%medroxyprogesterone%', '%etonogestrel%']));


-- ---------------------------------------------------------
-- Une ligne = une femme qui prend des hormones
-- ---------------------------------------------------------
CREATE TABLE contraception_1_distinct AS (
SELECT seqn
FROM medicaments_1
WHERE rxdrsd1 ILIKE '%hormon%'
   OR rxdrsd2 ILIKE '%hormon%'
   OR rxdrsd3 ILIKE '%hormon%'
   OR rxddrug ILIKE ANY (ARRAY['%ethinyl estradiol%', '%levonorgestrel%', '%norethindrone%',
                               '%drospirenone%', '%norgestimate%', '%desogestrel%',
                               '%medroxyprogesterone%', '%etonogestrel%']));

CREATE TABLE contraception_2_distinct AS (
SELECT seqn
FROM medicaments_2
WHERE rxdrsd1 ILIKE '%hormon%'
   OR rxdrsd2 ILIKE '%hormon%'
   OR rxdrsd3 ILIKE '%hormon%'
   OR rxddrug ILIKE ANY (ARRAY['%ethinyl estradiol%', '%levonorgestrel%', '%norethindrone%',
                               '%drospirenone%', '%norgestimate%', '%desogestrel%',
                               '%medroxyprogesterone%', '%etonogestrel%']));


-- ---------------------------------------------------------
-- Ajout d'un champ "contraception" pour la jointure avec l'échantillon
-- ---------------------------------------------------------
ALTER TABLE contraception_1_distinct
ADD COLUMN contraception text;

UPDATE contraception_1_distinct
SET contraception = 'oui';

ALTER TABLE contraception_2_distinct
ADD COLUMN contraception text;

UPDATE contraception_2_distinct
SET contraception = 'oui';
