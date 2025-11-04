# Create life tables using mx as input

# Load required libraries
library(readxl)
library(DemoTools)

# Death counts
ndx <- read_xlsx(path = "in/Pasig Data.xlsx", sheet = "Deaths_2020", skip = 2)
ndx[1, 1] <- "0"
ndx[81, 1] <- "80"
ndx$AGE <- as.numeric(ndx$AGE)

# For now, assume HH population is midyear population
popn <- read_xlsx(path = "in/Pasig Data.xlsx", sheet = "HHPop", skip = 2)
popn[1, 1] <- "0"
popn[81, 1] <- "80"
popn$AGE <- as.numeric(popn$AGE)

# Computing for nmx
nmx = ndx[2:4] / popn[11:13]

# Single-age life table using DemoTools
# Males
mlt <- lt_single_mx(nmx[, 1], Sex = "m")
round(mlt, 3)

# Females
flt <- lt_single_mx(nmx[, 2], Sex = "f")
round(flt, 3)

