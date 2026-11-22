# =========================================================
# 02 - Dictionnaire des variables NHANES
# Nom de chaque champ et sa description, enregistrés dans PostgreSQL
# =========================================================

library(nhanesA)
library(dplyr)
library(DBI)

# Liste des fichiers et de leur rubrique NHANES
mes_tables <- data.frame(
  table  = c("DEMO_H", "TST_H", "RHQ_H", "PHTHTE_H", "EPHPP_H",
             "PFAS_H", "ALB_CR_H", "BMX_H", "SMQ_H"),
  groupe = c("DEMO", "LAB", "Q", "LAB", "LAB",
             "LAB", "LAB", "EXAM", "Q")
)

# Pour chaque fichier : nom du champ + description
dictionnaire <- lapply(seq_len(nrow(mes_tables)), function(i) {
  vars <- nhanesTableVars(mes_tables$groupe[i], mes_tables$table[i])
  data.frame(
    table       = mes_tables$table[i],
    champ       = vars[[1]],
    explication = vars[[2]]
  )
}) %>%
  bind_rows()

# Enregistrement dans la base
dbWriteTable(con, "dictionnaire_nhanes", dictionnaire, overwrite = TRUE)
