
diamonds <- ggplot2::diamonds


diamonds2 <- diamonds %>%
                mutate(price_per_carat=price/carat)

diamonds$carat[1] <- NA

object_size(diamonds)
object_size(diamonds2)
object_size(diamonds, diamonds2)


environment()

stop("!")

assign("x", 10)
x

"x" %>% assign(100)

rnorm(100) %>%
  matrix(ncol=2) %>%
  plot() %>%
  str()

rnorm(100) %>%
  matrix(ncol=2) %T>%
  plot() %>%
  str()


mtcars %$%
  cor(disp, mpg)

mtcars %>%
  cor(disp, mpg)

mtcars <- mtcars %>%
  transform(cyl=cyl*2)

mtcars %<>% transform(cyl=cyl*2)



install.packages("pryr")
library(pryr)
library(tidyverse)
