# Load required libraries
library(readxl)
library(DemoTools)
library(knitr)

# Set working directory
setwd("C:/Users/JKB/Documents/WFH/#Syntax")

# Read data from excel file
data <- read_xlsx(path = "Heaping.xlsx", sheet = "Data")
data[101,1] <- "100"
data$AGE <- as.numeric(data$AGE)

attach(data)

# Myer's Blended Index
# Original
mbo1 <- check_heaping_myers(Value = BS2000, Age = AGE, ageMin = 10, ageMax = 99, 
                            details = FALSE, method = "orig")
mbo2 <- check_heaping_myers(BS2010, AGE, 10, 99, FALSE, "orig")
mbo3 <- check_heaping_myers(BS2020, AGE, 10, 99, FALSE, "orig")

# PASEX
mbp1 <- check_heaping_myers(BS2000, AGE, 10, 99, FALSE, "pasex")
mbp2 <- check_heaping_myers(BS2010, AGE, 10, 99, FALSE, "pasex")
mbp3 <- check_heaping_myers(BS2020, AGE, 10, 99, FALSE, "pasex")

# Create table
mb <- matrix(c(round(mbo1,2), round(mbo2,2), round(mbo3,2), 
               round(mbp1,2), round(mbp2,2), round(mbp3,2)), ncol = 2)

colnames(mb) <- c("Original", "PASEX")
rownames(mb) <- c("2000", "2010", "2020")
kable(mb, caption = "Myer's Blended Index")

# Whipple's Index
# Terminal digit '0' and '5'
w051 <- 100*check_heaping_whipple(Value = BS2000, Age = AGE, ageMin = 25, ageMax = 60, digit = c(0,5))
w052 <- 100*check_heaping_whipple(BS2010, AGE, 25, 60)
w053 <- 100*check_heaping_whipple(BS2020, AGE, 25, 60)

# Terminal digit '0'
w001 <- 100*check_heaping_whipple(BS2000, AGE, 25, 60, 0)
w002 <- 100*check_heaping_whipple(BS2010, AGE, 25, 60, 0)
w003 <- 100*check_heaping_whipple(BS2020, AGE, 25, 60, 0)

# Create table
w <- matrix(c(round(w001,1), round(w051,1), 
              round(w002,1), round(w052,1),
              round(w003,1), round(w053,1)), 
             ncol = 3)

colnames(w) <- c("2000", "2010", "2020")
rownames(w) <- c("Terminal digit '0'", "Terminal digit '0' and '5'")
kable(w, caption = "Whipple's Index")