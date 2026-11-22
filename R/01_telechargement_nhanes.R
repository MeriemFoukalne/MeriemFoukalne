# =========================================================
# 01 - Téléchargement des fichiers NHANES et chargement dans PostgreSQL
# Suffixe _H = cycle 2013-2014 (tables _1) ; suffixe _I = cycle 2015-2016 (tables _2)
# =========================================================

library(nhanesA)
library(DBI)

# La connexion "con" à la base Postgres est ouverte via l'onglet Connections de RStudio

# ---- Démographie (âge, sexe, grossesse, plan de sondage) ----
population_1 <- nhanes("DEMO_H")
population_2 <- nhanes("DEMO_I")

# ---- Hormones (testostérone, œstradiol, SHBG) ----
hormones_1 <- nhanes("TST_H")
hormones_2 <- nhanes("TST_I")

# ---- Santé reproductive ----
repoductive_health_1 <- nhanes("RHQ_H")
repoductive_health_2 <- nhanes("RHQ_I")

# ---- Phtalates (urine) ----
contam_phtalates_1 <- nhanes("PHTHTE_H")
contam_phtalates_2 <- nhanes("PHTHTE_I")

# ---- Bisphénols et parabènes (urine) ----
biph_para_1 <- nhanes("EPHPP_H")
biph_para_2 <- nhanes("EPHPP_I")

# ---- PFAS (sang) ----
pfas_1 <- nhanes("PFAS_H")
pfas_2 <- nhanes("PFAS_I")

# ---- Créatinine urinaire (dilution des urines) ----
creatinine_1 <- nhanes("ALB_CR_H")
creatinine_2 <- nhanes("ALB_CR_I")

# ---- Facteurs à prendre en compte : poids, taille, IMC ----
physique_1 <- nhanes("BMX_H")
physique_2 <- nhanes("BMX_I")

# ---- Facteurs à prendre en compte : tabac ----
tabac_1 <- nhanes("SMQ_H")
tabac_2 <- nhanes("SMQ_I")

# ---- Médicaments (pour repérer la contraception hormonale) ----
medicaments_1 <- nhanes("RXQ_RX_H")
medicaments_2 <- nhanes("RXQ_RX_I")


# ---- Chargement dans PostgreSQL ----
# Chaque table a été passée en noms de colonnes minuscules,
# puis envoyée dans la base. Exemple pour la démographie :
names(population_1) <- tolower(names(population_1))
dbWriteTable(con, "population_1", population_1, overwrite = TRUE)
# (même opération pour chacune des tables ci-dessus)
