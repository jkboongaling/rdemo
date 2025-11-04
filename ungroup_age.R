# Ungroup data using graduation methods e.g., Sprague, Beers, PCLM

# Load required libraries
library(readxl)
library(DemoTools)
library(dplyr)
library(stringr)
library(knitr)

# Read data from excel file
data <- read_xlsx(path = "in/Pasig Data.xlsx", sheet = "HHPop", skip = 2)
data[1, 1] <- "0"
data[81, 1] <- "80"
data$AGE <- as.numeric(data$AGE)

attach(data)

# To illustrate, single-year age data is first grouped
# Define age groups
age_breaks <- c(seq(0, 80, by = 5), Inf)
age_labels <- c(paste(seq(0, 75, by = 5), seq(4, 79, by = 5), sep = "-"), "80+")

# Assign age group to each age
age_group <- cut(0:80, breaks = age_breaks, right = FALSE, labels = age_labels)

# Male household population 2020, grouped
hp20 <- data.frame(Age = 0:80, AgeGrp = age_group, Value = M20)
hp20 <-
  hp20 %>% 
  group_by(AgeGrp) %>% 
  summarise(Value = sum(Value), .groups = "drop") %>% 
  mutate(Age = as.numeric(str_extract(AgeGrp, "^[0-9]+")))

attach(hp20)

# Ungroup
sprague <- graduate(Value, Age, method = "sprague")
beers <- graduate(Value, Age, method = "beers(mod)")
pclm <- graduate(Value, Age, method = "pclm")

# Checks
# Totals
sum(data$M20)
sum(sprague)
sum(beers)
sum(pclm)

# Estimates, grouped
est <- data.frame(Age = 0:80, AgeGrp = age_group, orig = M20,
                   sprague = sprague, beers = beers, pclm = pclm)
est <-
  est %>% 
  group_by(AgeGrp) %>% 
  summarise(orig = sum(orig), 
            sprague = sum(sprague), 
            beers = round(sum(beers)), 
            pclm = round(sum(pclm)), .groups = "drop")

# Plot comparison
plot(data$AGE, data$M20, type = 'l',
     ylab = 'Population',
     xlab = 'Age',
     main = 'Graduation with multiple methods')

lines(data$AGE, sprague, col = "red")
lines(data$AGE, beers.modified, col = "blue")
lines(data$AGE, pclm.grad, col = "green")

