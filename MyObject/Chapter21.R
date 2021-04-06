
#Ex.1
#チャンクの挿入はC Insertボタン

#Ex.2
#echo=TRUEは出力のタイプを制御

#Ex.3
#YAMLヘッダの項目に差異

#Ex.4
#html_document
#word_document
#pdf_document

![optional caption text](path/to/img.png)
plot(cars)

getwd()

#Ex.1

head(mtcars)

install.packages("knitr")
library(knitr)
knitr::kable(
  mtcars[1:5,],
  caption="A knitr kable."
)

??kinitr


library(tidyverse)

smaller <- diamonds %>% filter(carat <= 2.5)

smaller %>% 
  ggplot(aes(carat)) + 
  geom_freqpoly(binwidth = 0.01)

?diamonds
#carat: 重さ

smaller %>%
  ggplot(aes(cut, carat)) +
  geom_boxplot()

smaller %>%
  ggplot(aes(clarity, carat)) +
  geom_boxplot()

smaller %>%
  ggplot(aes(color, carat)) +
  geom_boxplot() +
  facet_grid(clarity~cut)


smaller %>%
  ggplot(aes(color, carat)) +
  geom_boxplot() +
  geom_point(
    data=top_n(smaller, 20, carat),
    size=2,
    color="red"
  ) +
  facet_grid(clarity~cut)


smaller %>%
  ggplot(aes(clarity, carat)) +
  geom_boxplot() +
  geom_point(
    data=top_n(smaller, 20, carat),
    size=2,
    color="red"
  )


smaller %>%
  ggplot(aes(carat, price)) +
  geom_point() +
  geom_point(
    data=top_n(smaller, 20, carat),
    size=2,
    color="red"
  ) +
  facet_grid(clarity~cut)


top_n(smaller, 20, carat)

lubridate::now()

lubridate::ymd("2015-01-01")
library(tidyverse)


install.packages("rmdshower")

pandoc

install.packages("stargazer")
library(stargazer)
