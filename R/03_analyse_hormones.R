# =========================================================
# Perturbateurs endocriniens et hormones chez les femmes de 20 à 44 ans
# NHANES 2013-2014 et 2015-2016
# Régressions linéaires pondérées (package survey)
# =========================================================

library(DBI)
library(dplyr)
library(survey)

# La connexion "con" à la base Postgres est ouverte via l'onglet Connections de RStudio

# Si une strate ne contient qu'une seule grappe, on évite que R s'arrête
options(survey.lonely.psu = "adjust")


# ---- 1. Import de la table qui réunit les deux cycles ----
donnees <- dbReadTable(con, "echantillon")


# ---- 2. Préparation des variables ----
donnees <- donnees %>%
  mutate(
    # Poids divisé par 2 car on réunit deux cycles de deux ans
    poids      = as.numeric(wtsb2yr) / 2,
    # Expositions
    bpa        = as.numeric(urxbph),
    # Somme molaire des 4 métabolites du DEHP (µmol/L)
    somme_dehp = as.numeric(urxmhp) / 278.3 + as.numeric(urxmhh) / 294.3 +
                 as.numeric(urxmoh) / 292.3 + as.numeric(urxecp) / 308.3,
    # Hormones
    testosterone = as.numeric(lbxtst),
    estradiol    = as.numeric(lbxest),
    shbg         = as.numeric(lbxshbg),
    # Ajustements
    age        = as.numeric(ridageyr),
    imc        = as.numeric(bmxbmi),
    creatinine = as.numeric(urxucr)
  ) %>%
  # On garde les femmes qui ont toutes les valeurs, toutes > 0 (le log de 0 n'existe pas)
  filter(poids > 0,
         bpa > 0, somme_dehp > 0,
         testosterone > 0, estradiol > 0, shbg > 0,
         creatinine > 0,
         !is.na(age), !is.na(imc))

nrow(donnees)   # nombre de femmes dans l'analyse


# ---- 3. Déclaration du plan de sondage ----
plan <- svydesign(
  ids     = ~sdmvpsu,
  strata  = ~sdmvstra,
  weights = ~poids,
  nest    = TRUE,
  data    = donnees
)


# ---- 4. Les expositions sont-elles liées entre elles ? ----
# Corrélation de Spearman entre les 2 expositions
# (en dessous d'environ 0,6 : on peut les mettre ensemble dans un même modèle)
cor(donnees$bpa, donnees$somme_dehp, method = "spearman")


# ---- 5. Fonction : lire un résultat de modèle ----
# Transforme le coefficient en "% de variation de l'hormone quand l'exposition double"
lire_resultat <- function(modele, exposition) {
  coef_exp <- coef(modele)[paste0("log(", exposition, ")")]
  ic       <- confint(modele)[paste0("log(", exposition, ")"), ]
  p        <- summary(modele)$coefficients[paste0("log(", exposition, ")"), "Pr(>|t|)"]
  data.frame(
    exposition        = exposition,
    variation_pct     = round((2^coef_exp - 1) * 100, 1),
    ic_bas_pct        = round((2^ic[1] - 1) * 100, 1),
    ic_haut_pct       = round((2^ic[2] - 1) * 100, 1),
    p_value           = round(p, 3)
  )
}

expositions <- c("bpa", "somme_dehp")
hormones    <- c("testosterone", "estradiol", "shbg")


# ---- 6. Étape 1 : une exposition à la fois (6 modèles) ----
resultats_un_a_un <- data.frame()

for (h in hormones) {
  for (e in expositions) {
    formule <- as.formula(paste0("log(", h, ") ~ log(", e, ") + age + imc + log(creatinine)"))
    modele  <- svyglm(formule, design = plan)
    resultats_un_a_un <- rbind(resultats_un_a_un,
                               cbind(hormone = h, lire_resultat(modele, e)))
  }
}

print(resultats_un_a_un)


# ---- 7. Étape 2 : les 2 expositions ensemble (3 modèles) ----
resultats_ensemble <- data.frame()

for (h in hormones) {
  formule <- as.formula(paste0("log(", h, ") ~ log(bpa) + log(somme_dehp)",
                               " + age + imc + log(creatinine)"))
  modele  <- svyglm(formule, design = plan)
  for (e in expositions) {
    resultats_ensemble <- rbind(resultats_ensemble,
                                cbind(hormone = h, lire_resultat(modele, e)))
  }
}

print(resultats_ensemble)


# ---- 8. Enregistrement des résultats dans Postgres ----
dbWriteTable(con, "resultats_un_a_un", resultats_un_a_un, overwrite = TRUE)
dbWriteTable(con, "resultats_ensemble", resultats_ensemble, overwrite = TRUE)


# ---- 9. Graphique : forest plot des résultats (une exposition à la fois) ----
library(ggplot2)

graphique <- resultats_un_a_un %>%
  mutate(
    exposition = recode(exposition,
                        bpa        = "Bisphénol A",
                        somme_dehp = "Phtalates (somme DEHP)"),
    hormone    = recode(hormone,
                        testosterone = "Testostérone",
                        estradiol    = "Œstradiol",
                        shbg         = "SHBG")
  )

ggplot(graphique, aes(x = variation_pct, y = hormone)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey40") +
  geom_errorbar(aes(xmin = ic_bas_pct, xmax = ic_haut_pct), width = 0.2, orientation = "y") +
  geom_point(size = 3) +
  facet_wrap(~ exposition) +
  labs(x = "Variation de l'hormone quand l'exposition double (%)",
       y = NULL,
       title = "Perturbateurs endocriniens et hormones chez les femmes de 20 à 44 ans",
       subtitle = "NHANES 2013-2016, régressions pondérées ajustées sur l'âge, l'IMC et la créatinine") +
  theme_minimal()

# Enregistrement de l'image dans le dossier du projet
ggsave("forest_plot_hormones.png", width = 9, height = 4, dpi = 300)
