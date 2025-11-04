# Install DemoTools
# https://timriffe.github.io/DemoTools/

install.packages("remotes")

# Development version of rstan
install.packages("rstan", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

library(rstan)
library(remotes)

remotes::install_github("timriffe/DemoTools")

library(DemoTools)

