# Create a basic population pyramid

# Load required libraries
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# Read data from excel file
raw <- read_xlsx(path = "in/Pasig Data.xlsx", sheet = "HHPop", skip = 2)
raw[1, 1] <- "0"
raw[81, 1] <- "80"
raw$AGE <- as.numeric(raw$AGE)

# Define age groups
age_breaks <- c(seq(0, 80, by = 5), Inf)
age_labels <- c(paste(seq(0, 75, by = 5), seq(4, 79, by = 5), sep = "-"), "80+")

# Assign age group to each age
age_group <- cut(0:80, breaks = age_breaks, right = FALSE, labels = age_labels)

# Household population 2020, grouped
hp20 <- data.frame(Age = 0:80, AgeGrp = age_group, Male = M20, Female = F20)
hp20 <-
  hp20 %>% 
  group_by(AgeGrp) %>% 
  summarise(Male = sum(Male),
            Female = sum(Female), .groups = "drop")

data <-
  hp20 %>%
  pivot_longer(cols = -AgeGrp, names_to = "Sex", values_to = "Popn") %>% 
  mutate(Sex = factor(Sex, levels = unique(Sex), labels = c("Male", "Female")),
         Popn = Popn / 1000,
         Total = sum(Popn), 
         Pct = 100 * Popn / Total)

# Plot
# in thousands
plot1 <-
  data %>%
  ggplot(aes(
    x = AgeGrp,
    y = if_else(Sex == "Male", -Popn, Popn),
    fill = Sex
  )) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = abs) +
  labs(x = "Age Group", y = "Population (in thousands)") +
  scale_fill_manual(values = c("#0070C0", "#C84630")) +
  coord_flip()

# in percent
plot2 <-
  data %>%
  ggplot(aes(
    x = AgeGrp,
    y = if_else(Sex == "Male", -Pct, Pct),
    fill = Sex
  )) +
  geom_bar(stat = "identity") +
  scale_y_continuous(breaks = -5:5, labels = abs) +
  labs(x = "Age Group", y = "Population (in percent)") +
  scale_fill_manual(values = c("#0070C0", "#C84630")) +
  coord_flip()

theme <-
  theme(
    panel.background = element_blank(),
    panel.spacing.x = unit(10, "points"),
    axis.title.y = element_blank(),
    axis.ticks.length.y = unit(0, "points"),
    legend.title = element_blank(),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)
  )

plot1 + theme + ggtitle("Pasig City, 2020")
plot2 + theme + ggtitle("Pasig City, 2020")

