#-----------------------------------------------------#
#                                                     #
#   | Nansen Legacy - R workshop - 20.01.2021         #
#   | EXERCISES for "Data wrangling with tidyverse"   #
#   | with Johanna Myrseth Aarflot & Tom Langbehn     #
#   | code by Tom Langbehn - tom.langbehn@uib.no      #
#                                                     #
#-----------------------------------------------------#

## LOADING ESSENTIAL LIBRARIES 
library(tidyverse)
##!> load palmerpenguins package
library(palmerpenguins)

##!> the dataframe we will be working with is called "penguins"

## EXPLORING DATA 
##!> Question 1: Can you figure out the dimensions of the "penguins" dataframe? ----

##!> Question 2: What proportion of the penguins in the dataset are from Torgersen island? ----

##!> Question 3: How many male, female and un-sexed penguins are in the data set? ----

##!> Question 4: What is the mean body mass? ----

##!> Question 5: How much do the heaviest 5 penguins way? ----

## SUBSETTING ----
##!> Question 6: Filter the penguins dataset to only select observations from 2008 ----

##!> Question 7: Filter the penguins dataset for which "bill_length_mm" is > 40 and "bill_depth_mm" is > 20  ----

##!> Question 8: Filter the penguins dataset for which "bill_length_mm" is > 35 but < 40; and "bill_depth_mm" is > 20 ----

##!> Question 9: Filter the penguins dataset for bill_length_mm is > 40 OR bill_depth_mm is  20  ----

##!> Question 10: Select the first four columns of the dataset using their column names  ----

##!> Question 11: Select all columns except year  ----

##!> Question 12: Select the variables "species", "island", "year" and all other variables that are given in millimeters ----

## -- FILTER & SELECT -- 
##!> Question 13: Create a subset of the penguins dataset that includes the variables "species", "body_mass_g" and "sex",  ----
##   but only for female Chinstrap penguins with a bill length of either 42.4, 48.5, or 45.6 mm 

## ADDING NEW VARIABLES ----
##!> Question 14: Add "hemisphere" as variable to the penguins dataset, stating "southern" for all observations ----

##!> Question 15: Add a column for bill_length_mm in cm ----

##!> Question 16: Add a column for the bill area (i.e., bill_length_mm x bill_depth_mm) in cm^2 ----

##!> Question 17: Add a factor column "age_class" that categorize the penguins into adults and juveniles, based on their flipper length_mm (adults have flippers > 200 mm)---- 

## SUMMARISING ----
##!> Question 18: Calculate the average female and male weight per island and exclude all NA values ----

##!> Question 19: Calculate the min and max values by island for ALL morphometric measurements (bill length, bill depth, flipper length and body mass)----


## RESHAPING DATA ----
##!> Question 20: Pivot the following dataframe to  wide format, so that female and male become separate columns and save the dataframe to "df_wide" ----
penguins %>% 
  drop_na() %>% 
  group_by(island, sex) %>% 
  summarise_at(vars(body_mass_g), lst(mean)) %>% 
  ungroup() 

##!> Question 21: can you reshape "df_wide" to long format and safe it as "df_long"? ----

## MERGING DATA ----
##!> Question 21: For each species, add the mean bill length and depth (as two new columns) to the "penguins" dataset ----
##!> (hint start by creating a new summary dataframe called "df_sum" containing the mean values that you then join to "penguins")


