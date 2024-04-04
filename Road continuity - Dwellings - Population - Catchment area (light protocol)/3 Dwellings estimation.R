################################################################################
#                                                                              #
#   3 . Estimation of number of dwellings                                      #
#                                                                              #
#   Project website : http://emc2-dut.org/                                     #
#   Data sample : XXX                                                          #
#                                                                              #
#   Author : PEREZ, J.* (2024)                                                 #
#   * UMR 7300 ESPACE-CNRS, Université Côte d'Azur, Nice, France.              #
#   Contact: Joan.PEREZ@univ-cotedazur.fr                                      #
#                                                                              #
#   Note : This script is aimed at estimating the number of dwellings within   #
#   buildings using a combination of machine learning techniques, specifically #
#   classification and regression models, based on building morphometry        #
#   indicators                                                                 #
#                                                                              #
# Packages, local filepaths & parameters                                       #
# R version 4.3.2 (2023-10-31 ucrt)                                            #
library(sf) # v.1.0.14                                                         #
library(dplyr) # v.1.1.3                                                       #
library(rpart) # v.4.1.21                                                      #
library(MASS) # v.7.3.60                                                       #
library(caret) # v.6.0.94                                                      #
#                                                                              #
# Load buildings with morphometry indicators                                   #
# Load either DPC_06.gpkg or DPC_59.gpkg within ""                             #
building <- st_read("", layer = "building_morpho")                  #
################################################################################

## 3.1 Classification model : evaluate building with/without dwellings for NULL
## values of number of dwellings

# duplicate with geometries (for later use)
building_geom <- building
# remove geometries 
st_geometry(building) = NULL

# Subset with NA values for number of dwellings "nombre_de_logements"
building_na <- subset(building, is.na(nombre_de_logements))

# Subset with values for number of dwellings (0 included)
building <- building[!is.na(building$nombre_de_logements), ]

# Column dwellings_yn : for buildings with values for dwellings, 
# difference between 0 and more than 0 (no = 0 ; yes = 1)
building$dwellings_yn <- building$nombre_de_logements
building$dwellings_yn[building$dwellings_yn != 0] <- 1

# Subset with only ID and morphology indicators for learning
temp <- building[,c(28:37)]

# set a seed for reproducibility
set.seed(1)

# Divide the dataset into data.train and data.test
indexes <- sample(1:nrow(temp), nrow(temp)*0.7)
data.train <- temp[indexes, ]
data.test <- temp[-indexes, ]

# Training dataset : predict dwellings_yn based on morphology indicators
tree <- rpart(dwellings_yn ~ ., data.train, method = "class")
summary(tree)

# Tree is applied on test dataset
pred <- predict(tree, data.test, type = "class")

# Construct the confusion matrix and print accuracy
conf <- table(data.test$dwellings_yn,pred)
sum(diag(conf))/sum(conf)

# Dataset with NA values for number of dwellings (nombre_de_logements) :  
# predict the presence of dwellings : y/n
building_na$dwellings_yn <- predict(tree, building_na, type = "class")

# Get predictions on main dataset
building <- rbind(building, building_na)

## 3.2 Regression model : estimate number of dwellings for buildings with 
## dwellings(dwellings_yn = 1) but NULL values of number of dwellings

temp <- building[building$dwellings_yn != 0,]
temp <- temp[,c(17,28:36)]
temp <- temp[complete.cases(temp), ]

# Set up repeated k-fold cross-validation
train.control <- trainControl(method = "cv", number = 10)
# Train the full model
step.model <- train(nombre_de_logements ~., data = temp,
                    method = "leapBackward", 
                    tuneGrid = data.frame(nvmax = 1:10),
                    trControl = train.control)
# Print evolution of R squared
step.model$results
# Look at predictor importances
summary(step.model$finalModel)

# Create a linear formula based on selected model
formula_lin <- nombre_de_logements ~ FL + FA

# Fit the model
model <- lm(formula_lin, temp)

# Print summary and R squared
summary(model) 

# get the predictions
building$prediction_dwellings <- round(predict(model, newdata=building))

# Put all negative predictions to 0 (sparse matrix leads to negative pred)
building$prediction_dwellings[building$prediction_dwellings < 0] <- 0

# Check if number of dwellings is NULL and pred dwellings is equal to 0,
# if both conditions are met, assign 0 to dwellings_estimate otherwise
# test if number of dwellings is NULL and pred dwellings is equal to 1,
# if both conditions are met, assign prediction_dwellings to dwellings_estimate,
# otherwise assign nombre_de_logements
building$dwellings_estimate <- ifelse(is.null(building$nombre_de_logements) &
                                        building$prediction_dwellings == 0,
                                      0,ifelse(is.null(building$nombre_de_logements) &
                                               building$prediction_dwellings == 1,
                                             building$prediction_dwellings, 
                                             building$nombre_de_logements))

building_geom <- cbind(building_geom, building$dwellings_estimate)

# Results are available in the sample data as a layer named "building_dwellings"
