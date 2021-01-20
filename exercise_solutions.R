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
##!> there are multiple ways to do that
penguins %>% dim() 
penguins %>% glimpse() 
penguins %>% Hmisc::describe()

##!> Question 2: What proportion of the penguins in the dataset are from Torgersen island? ----
##!> there are multiple ways to do that
penguins %>% Hmisc::describe()

penguins %>% summary() #!> 52 out of 344 (see Q1)

##!> Question 3: How many male, female and un-sexed penguins are in the data set? ----
penguins %>% Hmisc::describe()
penguins %>% summary() 

##!> Question 4: What is the mean body mass? ----
penguins %>% Hmisc::describe()
penguins %>% summary() 

##!> Question 5: How much do the heaviest 5 penguins way? ----
penguins %>% 
  arrange(desc(body_mass_g)) %>% 
  head(5)

penguins %>% Hmisc::describe() 




## SUBSETTING ----
##!> Question 6: Filter the penguins dataset to only select observations from 2008 ----
penguins %>% filter(year == "2008")

##!> Question 7: Filter the penguins dataset for which "bill_length_mm" is > 40 and "bill_depth_mm" is > 20  ----
penguins %>% 
  filter(bill_length_mm > 40 & bill_depth_mm > 20)

penguins %>% 
  filter(bill_length_mm > 40, bill_depth_mm > 20)

##!> Question 8: Filter the penguins dataset for which "bill_length_mm" is > 35 but < 40; and "bill_depth_mm" is > 20 ----
penguins %>% 
  filter(between(bill_length_mm, 35, 40), bill_depth_mm > 20)

penguins %>% 
  filter(bill_length_mm > 35 & bill_length_mm < 40, bill_depth_mm > 20)

##!> Question 9: Filter the penguins dataset for bill_length_mm is > 40 OR bill_depth_mm is  20  ----
penguins %>% 
  filter(bill_length_mm > 40 | bill_depth_mm >20)

##!> Question 10: Select the first four columns of the dataset using their column names  ----
penguins %>%
  dplyr::select("species", "island", "bill_length_mm", "bill_depth_mm")

penguins %>%
  dplyr::select(-c("flipper_length_mm", "body_mass_g", "sex", "year"))

penguins %>%
  .[,1:4]

##!> Question 11: Select all columns except year  ----
penguins %>%
  dplyr::select(-"year")

##!> Question 12: Select the variables "species", "island", "year" and all other variables that are given in millimeters ----
penguins %>%
  dplyr::select(species,island, year, contains("_mm"))

penguins %>%
  dplyr::select(species,island, year, ends_with("_mm"))

## -- FILTER & SELECT -- 
##!> Question 13: Create a subset of the penguins dataset that includes the variables "species", "body_mass_g" and "sex",  ----
##   but only for female Chinstrap penguins with a bill length of either 42.4, 48.5, or 45.6 mm 

penguins %>% 
  filter(species=="Chinstrap", sex =="female", bill_length_mm %in% c(42.4, 48.5,45.6)) %>% 
  dplyr:: select(species, body_mass_g, sex)

## ADDING NEW VARIABLES ----
##!> Question 14: Add "hemisphere" as variable to the penguins dataset, stating "southern" for all observations ----
penguins %>% 
  add_column(hemisphere = "southern")

##!> Question 15: Add a column for bill_length_mm in cm ----
penguins %>% 
  mutate(bill_length_cm = bill_length_mm/10)

##!> Question 16: Add a column for the bill area (i.e., bill_length_mm x bill_depth_mm) in cm^2 ----
penguins %>% 
  mutate(bill_area_cm2 = (bill_length_mm/10)*(bill_length_mm/10))

penguins %>% 
  mutate(bill_area_cm2 = (bill_length_mm*bill_length_mm)/100)

##!> Question 17: Add a factor column "age_class" that categorize the penguins into adults and juveniles, based on their flipper length_mm (adults have flippers > 200 mm)---- 
penguins %>%
  mutate(age_class = as.factor(
    case_when(
      flipper_length_mm <= 200   ~ "juvenile",
      flipper_length_mm > 200   ~ "adult",
    )
  ))

## SUMMARISING ----
##!> Question 18: Calculate the average female and male weight per island and exclude all NA values ----
penguins %>% 
  drop_na() %>% 
  group_by(island, sex) %>% 
  summarise_at(vars(body_mass_g), lst(mean))

penguins %>% 
  drop_na() %>% 
  group_by(island, sex) %>% 
  summarise_at(c("body_mass_g"), mean)  

penguins %>%
  drop_na() %>% 
  dplyr::select(island, sex, body_mass_g) %>% 
  group_by(island, sex) %>% 
  summarise_if(is.numeric, mean, na.rm = TRUE)

##!> Question 19: Calculate the min and max values by island for ALL morphometric measurements (bill length, bill depth, flipper length and body mass)----
penguins %>% 
  dplyr::select(-c(species, sex, year)) %>% 
  group_by(island) %>% 
  summarise_all(lst(min, max), na.rm=T)

penguins %>% 
  group_by(island) %>% 
  summarise_at(vars(bill_length_mm:body_mass_g), lst(min, max), na.rm=T)


## RESHAPING DATA ----
##!> Question 20: Pivot the following dataframe to  wide format, so that female and male become separate columns and save the dataframe to "df_wide" ----
penguins %>% 
  drop_na() %>% 
  group_by(island, sex) %>% 
  summarise_at(vars(body_mass_g), lst(mean)) %>% 
  ungroup() %>% 
  pivot_wider(id_cols=island,names_from =sex, values_from=mean) -> df_wide

##!> Question 21: can you reshape "df_wide" to long format and safe it as "df_long"? ----
df_wide %>% 
  pivot_longer(cols=female:male, names_to ="sex", values_to = "body_mass_g") -> df_long

## MERGING DATA ----
##!> Question 21: For each species, add the mean bill length and depth (as two new columns) to the "penguins" dataset ----
##!> (hint start by creating a new summary dataframe called "df_sum" containing the mean values that you then join to "penguins")

penguins %>% 
  group_by(species ) %>% 
  summarise_at(vars(bill_length_mm:bill_depth_mm), lst(mean), na.rm=T) -> df_sum

penguins %>% left_join(df_sum, by="species") #!> right_join and full_join would work too

