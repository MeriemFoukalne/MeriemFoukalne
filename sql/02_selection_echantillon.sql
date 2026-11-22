-- =========================================================
-- 02 - Sélection de l'échantillon
-- Femmes de 20 à 44 ans, non enceintes, sans traitement hormonal,
-- sans hystérectomie ni ablation des ovaires,
-- avec les dosages d'exposition et d'hormones disponibles
-- =========================================================
-- Les jointures simples (JOIN) excluent volontairement les femmes
-- absentes de l'une des tables : analyse sur données complètes.


-- ---------------------------------------------------------
-- Cycle 2013-2014
-- ---------------------------------------------------------
CREATE TABLE echantillon_temp_1 AS (
SELECT
       d.seqn,
       b.bmiwaist,
       b.bmiwt,
       b.bmxbmi,
       b.bmxwaist,
       b.bmxwt,
       d.dmdborn4,
       d.dmdeduc2,
       d.dmdmartl,
       d.dmdyrsus,
       d.dmqadfc,
       d.indfmin2,
       d.indfmpir,
       d.indhhin2,
       d.riagendr,
       d.ridageyr,
       d.ridexprg,
       d.sdmvpsu,
       d.sdmvstra,
       bf.urxbup,
       bf.urdbphlc,
       bf.urxbph,
       p.lbdpfhsl,
       p.lbdpfual,
       p.lbxpfhs,
       p.lbxpfna,
       p.wtsb2yr,
       f.urdecplc,
       f.urdmbplc,
       f.urdmeplc,
       f.urdmhhlc,
       f.urdmhplc,
       f.urdmohlc,
       f.urxecp,
       f.urxmbp,
       f.urxmep,
       f.urxmhh,
       f.urxmhp,
       f.urxmoh,
       c.urxucr,
       rp.rhd043,
       rp.rhd143,
       rp.rhd173,
       rp.rhd180,
       rp.rhd190,
       rp.rhq031,
       rp.rhd280,   -- ces 2 champs, pour identifier celles qui ont fait une ablation des ovaires ou de l'utérus
       rp.rhq305,
       rp.rhq420,
       rp.rhq540,
       rp.rhq570,
       rp.rhq580,
       rp.rhq596,
       t.smd030,
       t.smd055,
       t.smd057,
       h.lbdestlc,
       h.lbdshglc,
       h.lbdtstlc,
       h.lbxest,
       h.lbxshbg,
       h.lbxtst,
       m.contraception
FROM population_1 d
JOIN physique_1 b               ON b.seqn = d.seqn
JOIN biph_para_1 bf             ON bf.seqn = d.seqn
JOIN pfas_1 p                   ON p.seqn = d.seqn
JOIN contam_phtalates_1 f       ON f.seqn = d.seqn
JOIN repoductive_health_1 rp    ON rp.seqn = d.seqn
JOIN tabac_1 t                  ON t.seqn = d.seqn
JOIN hormones_1 h               ON h.seqn = d.seqn
JOIN creatinine_1 c             ON c.seqn = d.seqn
LEFT JOIN contraception_1_distinct m ON m.seqn = d.seqn
WHERE p.lbxpfhs IS NOT NULL
  AND p.lbxpfna IS NOT NULL
  AND f.urxecp IS NOT NULL
  AND f.urxmbp IS NOT NULL
  AND d.ridageyr BETWEEN 20 AND 44
  AND h.lbxtst IS NOT NULL
  AND d.riagendr = 'Female'
  AND d.ridexprg = 'The participant was not pregnant at exam'
  AND m.contraception IS NULL      -- exclut les femmes sous traitement hormonal
  AND rp.rhd280 = 'No'             -- pas d'hystérectomie
  AND rp.rhq305 = 'No'             -- pas d'ablation des ovaires
);


-- ---------------------------------------------------------
-- Cycle 2015-2016
-- ---------------------------------------------------------
CREATE TABLE echantillon_temp_2 AS (
SELECT
       d.seqn,
       b.bmiwaist,
       b.bmiwt,
       b.bmxbmi,
       b.bmxwaist,
       b.bmxwt,
       d.dmdborn4,
       d.dmdeduc2,
       d.dmdmartl,
       d.dmdyrsus,
       d.dmqadfc,
       d.indfmin2,
       d.indfmpir,
       d.indhhin2,
       d.riagendr,
       d.ridageyr,
       d.ridexprg,
       d.sdmvpsu,
       d.sdmvstra,
       bf.urxbup,
       bf.urdbphlc,
       bf.urxbph,
       p.lbdpfhsl,
       p.lbdpfual,
       p.lbxpfhs,
       p.lbxpfna,
       p.wtsb2yr,
       f.urdecplc,
       f.urdmbplc,
       f.urdmeplc,
       f.urdmhhlc,
       f.urdmhplc,
       f.urdmohlc,
       f.urxecp,
       f.urxmbp,
       f.urxmep,
       f.urxmhh,
       f.urxmhp,
       f.urxmoh,
       c.urxucr,
       rp.rhd043,
       rp.rhd143,
       rp.rhd173,
       rp.rhd180,
       rp.rhd190,
       rp.rhq031,
       rp.rhd280,   -- ces 2 champs, pour identifier celles qui ont fait une ablation des ovaires ou de l'utérus
       rp.rhq305,
       rp.rhq420,
       rp.rhq540,
       rp.rhq570,
       rp.rhq580,
       rp.rhq596,
       t.smd030,
       t.smd055,
       t.smd057,
       h.lbdestlc,
       h.lbdshglc,
       h.lbdtstlc,
       h.lbxest,
       h.lbxshbg,
       h.lbxtst,
       m.contraception
FROM population_2 d
JOIN physique_2 b               ON b.seqn = d.seqn
JOIN biph_para_2 bf             ON bf.seqn = d.seqn
JOIN pfas_2 p                   ON p.seqn = d.seqn
JOIN contam_phtalates_2 f       ON f.seqn = d.seqn
JOIN repoductive_health_2 rp    ON rp.seqn = d.seqn
JOIN tabac_2 t                  ON t.seqn = d.seqn
JOIN hormones_2 h               ON h.seqn = d.seqn
JOIN creatinine_2 c             ON c.seqn = d.seqn
LEFT JOIN contraception_2_distinct m ON m.seqn = d.seqn
WHERE p.lbxpfhs IS NOT NULL
  AND p.lbxpfna IS NOT NULL
  AND f.urxecp IS NOT NULL
  AND f.urxmbp IS NOT NULL
  AND d.ridageyr BETWEEN 20 AND 44
  AND h.lbxtst IS NOT NULL
  AND d.riagendr = 'Female'
  AND d.ridexprg = 'The participant was not pregnant at exam'
  AND m.contraception IS NULL      -- exclut les femmes sous traitement hormonal
  AND rp.rhd280 = 'No'             -- pas d'hystérectomie
  AND rp.rhq305 = 'No'             -- pas d'ablation des ovaires
);


-- ---------------------------------------------------------
-- Réunion des deux cycles dans une seule table
-- ---------------------------------------------------------
CREATE TABLE echantillon AS (
SELECT *
FROM echantillon_temp_1
UNION ALL
SELECT *
FROM echantillon_temp_2
);

-- Contrôle : nombre de femmes dans l'échantillon final
SELECT COUNT(*)
FROM echantillon;
