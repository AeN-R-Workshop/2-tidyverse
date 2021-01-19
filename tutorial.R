#-----------------------------------------------------#
#                                                     #
#   | Nansen Legacy - R workshop - 20.01.2021         #
#   | TUTORIAL for "Data wrangling with tidyverse"    #
#   | with Johanna Myrseth Aarflot & Tom Langbehn     #
#   | code by Tom Langbehn - tom.langbehn@uib.no      #
#                                                     #
#-----------------------------------------------------#

## !> useful shortkeys in Rstudio:
## !> ctrl+shift+m = "%>%"
## !> ctrl+shift+c = "#" "comments" or "un-comments" select lines by adding or removing the hashtag
## !> ctrl+shift+F10 restarts R session
## !> ctrl+L clears the console
## !> alt+O collapse all sections
## !> shift+alt+O expand all
## !> ctrl+1 move cursor to source
## !> ctrl+2 move cursor to console
## !> alt + left click allows you to drag the cursor over multiple lines

## LOADING ESSENTIAL LIBRARIES ----
library(tidyverse)
library(here)

## !> we are currently in the directory ".../data_wrangling_excercises"
## !> to navigate to the "rawdata" folder we use
here::here()
here::here("rawdata")

## !> what files are in the the rawdata directory?
list.files(here::here("rawdata"))

## READING DATA, alternative 1 ----
## !> reading a csv fie
dream <- read.csv(here::here("rawdata", "dream.csv"), sep = ",", header = T)
torgersen <- read.csv(here::here("rawdata", "torgersen.csv"), sep = ",", header = T)
biscoe <- read.csv(here::here("rawdata", "biscoe.csv"), sep = ",", header = T)

## !> lets look at the data
print(dream)
print(torgersen)
print(biscoe)

## !> now we use bind_rows to merge all three dataframe into one single dataframe
allislands_df <- bind_rows(biscoe, dream, torgersen)
print(allislands_df)

## !> we notice that that column names in "biscoe.csv" are inconsistent
## !> to clean the column names we load the "janitor" package that has a function called clean_names()
## !> clean_names() returns names that are unique and consist only of the "_" character, numbers, and letters.
## !> Capitalization preferences can be specified using the case parameter.

library(janitor)
biscoe %>%
  clean_names() -> biscoe

## !> lets try again merging the thee dataframes
allislands_df <- bind_rows(biscoe, dream, torgersen)
print(allislands_df)

## !> dataframes vs tibbles
## !> Tibbles are data.frames that are lazy and surly: they do less
## !> (i.e. they don't change variable names or types, and don't do partial matching)
## !> and complain more (e.g. when a variable does not exist).
## !> This forces you to confront problems earlier, typically leading to cleaner, more expressive code.

## READING DATA, alternative 2 ----
## !> list all csv files in directory
filenames_csv <- list.files(here::here("rawdata"), pattern = ".csv", full.names = T)

## !> read all csv files into one single dataframe using purrr::map_df
filenames_csv %>%
  map_df(~ read_csv(.)) %>%
  clean_names()

## !> note that some columns are duplicated because of the inconsistent column names
## !> instead we have to do
filenames_csv %>%
  map_df(~ clean_names(read_csv(.)))

## !> of course we can also use excel files directly
readxl::read_xlsx(here::here("rawdata", "dream.xlsx"))


## BREAK ?

## EXPLORING DATA ----

## !> load palmerpenguins package
library(palmerpenguins)

## !> check what datasets are included
data(package = "palmerpenguins")

## !> get a glimpse of your data
penguins %>% glimpse()

## !> or view full data set
penguins %>% view()

## !> if you use the base R dataframe head() can be useful
## !> it will show you the first X observations(by default 6) in a dataset
penguins %>%
  as.data.frame() %>%
  head(10)

## !> a tibble does that by default already
penguins

## !> sometimes it just helps already arranging the data
penguins %>% arrange(bill_length_mm) # !> default is ascending
penguins %>% arrange(desc(bill_length_mm))

## !> summary will give you some summary statistics, such as mean, median etc.
penguins %>% summary()

## !> many packages offer even more elaborate versions to "glimpse" your data
library(Hmisc)
penguins %>% Hmisc::describe()



## SUBSETTING ----

## !> CHECK POWERPOINT

## -- FILTER -- 
## !> Lets start by subsetting observations (rows)
## !> What if we not interested in males, but only females?
## !> "==" equal to
penguins %>%
  filter(sex == "female")

## !> OK, but we are not interested in individuals from Torgersen island either
## !> to exclude observations from Torgersen island we can add another filter 
penguins %>%
  filter(sex == "female") %>%
  filter(island %in% c("Dream", "Biscoe"))

## ! the different filters could also be combined
penguins %>%
  filter(sex == "female", island %in% c("Dream", "Biscoe"))
  # filter(sex == "female" | is.na(sex), island %in% c("Dream", "Biscoe"))

## !> note while %in% is defined, there is no equivalent "not in".
## !> but we can define this operator quickly ourselves
"%ni%" <- Negate("%in%")

## !> we could use also "Not equal to" (!=) instead...
penguins %>%
  filter(sex == "female", island != "Torgersen")

## !> note that we have not yet saved this new dataframe,
## !> to do that we have to define a new dataframe first

## !> we can do either with a left-hand assignment "<-", 
## !> (avoid "=" as an assignment operator)
females_df <- penguins %>%
  filter(sex == "female", island != "Torgersen")

## !> equally valid is the right-hand assignment "->"
penguins %>%
  filter(sex == "female", island != "Torgersen") -> females_df


## !> slices can be an alternative to filter if you know which rows you want to select
penguins %>%
  # !> first lets add row ids as a column so we see that we are doing the correct thing
  rowid_to_column() %>%
  # !> now we just select rows 10-20
  slice(10:20)


## -- SELECT -- 
## !> Next, lets try to subset variables (columns), to do that we use "select()"
## !> because several packages contain a function called "select it is smart to specify which one we intent to use.
## !> dplyr::select() means we want to use the select function form the dplyr package.

## !> Lets say we are only interested in the variables "species","island" and "bill_length_mm"
## !> then we can either specify the columns that we are interested in, like this:
penguins %>%
  dplyr::select(species, island, bill_length_mm)

## !> or we can "un-select" the columns that we are not interested in by adding a minus to the select command
penguins %>%
  dplyr::select(-bill_depth_mm, -flipper_length_mm, -body_mass_g, -sex, -year)

## !> to avoid typing the minus sign multiple times we can combine the variables into a vector
penguins %>%
  dplyr::select(-c(bill_depth_mm, flipper_length_mm, body_mass_g, sex, year))

## !> Of course, subsetting observations (rows, using filter) and variables (columns, using select) can also be combined in a pipe
## !> Lets try this. We want to select three columns and then remove any NA values in "bill_length_mm" from the dataset
penguins %>%
  dplyr::select(species, island, bill_length_mm) %>%
  filter(!is.na(bill_length_mm))

## !> An alternative approach is using "drop_na()", which removes all observations (rows) that contain "NA" in any variable (column)
penguins %>%
  dplyr::select(species, island, bill_length_mm) %>%
  drop_na()

## !> There might be cases where you want to replace all NA values,
## !> for example, because you know they are all "zeros"
## !> in this case you can use replace_na()

## !> Lets consider a more complicated example.
## !> We are interested in the variables "species", "island", "bill_length_mm", "bill_depth_mm"
## !> BUT only for individuals with a "bill_depth_mm" larger than the average,
## !> and "bill_length_mm" between 55 and 60 mm

## !> First, lets find the mean bill length.

bill_depth_mean_mm <- penguins %>%
  ## !> Other than select(), pull() extracts a single column as a vector
  pull(bill_depth_mm) %>%  
  ## !> pull(x) is equivalent to ".$"
  # .$bill_depth_mm %>% 
  ## !> We can then calculate the mean from the vector.
  ## !> Here it is important to include "rm.na = T" in the mean() function call, else NA will be returned
  mean(., na.rm = T)

## !> and now we can use this new variable to subset our dataframe
penguins %>%
  dplyr::select(species, island, contains("bill_")) %>%
  filter(bill_depth_mm > bill_depth_mean_mm & between(bill_length_mm, 50, 60))


## ADDING NEW VARIABLES ----
## !> we have three species all belonging to the genus "Pygoscelis", lets add a column for that
## !> in this case we additional specify that we want that column to be added before the species column
penguins_new <- penguins %>%
  add_column(genus = "Pygoscelis", .before = "species")

## !> lets add a new variable (column) with the weight in kg instead of gram using mutate()
penguins_new <- penguins_new %>%
  mutate(body_mass_kg = body_mass_g / 1000, .after = "body_mass_g")

## !> what if you want to group individuals into three weight classes ("light", "medium", "heavy") based on their body weight?
penguins_new <- penguins_new %>%
  mutate(weight_class = as.factor(
    case_when(
      body_mass_kg < 3.5 ~ "light",
      between(body_mass_kg, 3.5, 5.0) ~ "medium",
      body_mass_kg > 5.0 ~ "heavy"
    )
  ))


## !> piping data into plotting function
penguins_new %>%
  ## !> pipe into plotting function
  boxplot(bill_length_mm ~ weight_class, data = .)

## !> factors are in alphabetical, but not in logical order. Lets change that.
penguins_new %>%
  ## !> the factors are now in alphabetical order, lets put them in logical order
  mutate(weight_class = fct_reorder(weight_class, bill_length_mm)) %>%
  ## !> pipe into plotting function
  boxplot(bill_length_mm ~ weight_class, data = .)


## !> now lets try to summarize some of the data
## !> how many individuals are there in each of the weight classes?
## !> to answer this we first need to define a grouping, we do that using group_by
penguins_new <- penguins_new %>%
  group_by(weight_class) %>%
  add_count() %>%
  mutate(body_mass_kg_mean = mean(body_mass_kg))

## !> maybe we are also interested in the mean bill length ± SD for each of the weight classes
penguins_new %>%
  ## !> add grouping
  group_by(weight_class) %>%
  # group_by(island, weight_class) %>%
  ## !> calculate mean and sd for each group
  summarise(
    bill_length_mm_mean = mean(bill_length_mm, na.rm = T),
    bill_length_mm_sd = sd(bill_length_mm, na.rm = T)
  ) %>%
  ## !> we are not interested in the NA values, lets drop them
  drop_na()

## !> the warning message:`summarise()` ungrouping output (override with `.groups` argument)
## !> is just a friendly warning message. By default, if there is any grouping before the summarize,
## !> it drops one group variable i.e. the last one specified in the group_by.
## !> If there is only one grouping variable, there won't be any grouping attribute after the summarise and if there are more than one
## !> i.e. if it is two, the attribute for grouping is reduce to 1.

## !> summarize (and mutate) come in different flavors:
## !>> mutate_at(), summarize_at()
## !>> mutate_if(), summarize_if()
## !>> mutate_all(), summarize_all()

## !> what if we want the mean ± SD for each weight class not only for bill length but also bill depth?
penguins_new %>%
  ## !> add grouping
  group_by(weight_class) %>%
  # group_by(island, weight_class) %>%
  ## !> calculate mean and sd for each group
  summarise_at(vars(bill_length_mm, bill_depth_mm), lst(mean, sd)) %>%
  ## !> we are not interested in the NA values, lets drop them
  drop_na()

## !> or calculate the mean for all numeric variables in your dataset
penguins_sum <- penguins_new %>%
  ## !> add grouping
  group_by(weight_class) %>%
  # group_by(island, weight_class) %>%
  ## !> calculate mean and sd for each group
  summarise_if(is.numeric, lst(mean)) %>%
  ## !> we are not interested in the NA values, lets drop them
  drop_na() %>%
  ## !> now we also average or count ("n"), which doesn't matter because it is the same value for each observation in the group anyway
  ## !> but we might want to rename it, as the column name is miss leading
  rename(n = n_mean)

print(penguins_sum)

## RESHAPING DATA ----
## !> lets move from wide to long format
penguins_long <- penguins %>%
  dplyr::select(species, island, bill_length_mm, flipper_length_mm, body_mass_g) %>%
  drop_na() %>%
  # !add row id
  rowid_to_column() %>%
  # !> here is where we change from wide to long
  pivot_longer(cols = bill_length_mm:flipper_length_mm, names_to = "var", values_to = "val")

# !> This become soften useful when using ggplot and facets
penguins_long %>% 
ggplot(., aes(x = body_mass_g, y = val)) +
  geom_point() +
  facet_wrap(vars(var), scales = "free")

## !> when can of course also go from long back to a wide format
penguins_wide <- penguins_long %>%
  pivot_wider(id_cols = c(rowid, species, island, body_mass_g), names_from = "var", values_from = "val")

## !> NOTE pivot_longer() and pivot-wider() are an updated approach to gather() and spread,
## !> designed to be both simpler to use and to handle more use cases.
## !> We recommend you use pivot_longer() for new code; gather() and spread() aren't going away
## !> but are no longer under active development.


## MERGING DATA ----

## !> CHECK SLIDES IN POWERPOINT

## !> what if you have to datasets that you want to merge,
## !> e.g. the penguins dataframe and a dataframe that contains environmental data

## !> Lets first create a new mock dataset with environmental data

env_data <- expand_grid(year = c(2007, 2008, 2009), island = c("Torgersen", "Dream", "Biscoe", "Bouvet")) %>%
  # !> now we add some fake temperatures
  add_column(ann_mean_temp_C = runif(12, 5.0, 10.5))

## !> Now we want to join our temperature measurements with the penguin observations.
## !> Both datasets have the "year" and "islands" column in common,
## !> so we can join the two dataframes using those two columns as unique identifiers

## !> remember, left_join() keeps all rows in x
joint_df <- penguins %>% left_join(env_data, by = c("year", "island"))
print(joint_df, n = Inf)
