




# landscape
gapminder %>%
  ggplot(aes(year, lifeExp, group=country)) +
    geom_line(alpha=1/3)



# One Country

nz <- gapminder %>% filter(country=="New Zealand")

nz %>%
  ggplot(aes(year, lifeExp)) +
  geom_line() +
  ggtitle("Full data=")

nz_mod <- lm(lifeExp~year, data=nz)

nz %>%
  add_predictions(nz_mod) %>%
  ggplot(aes(year, pred)) +
  geom_line() +
  ggtitle("Linear trend +")

nz %>%
  add_residuals(nz_mod) %>%
  ggplot(aes(year, resid)) +
  geom_hline(yintercept=0, color="white", size=3) +
  geom_line() +
  ggtitle("Remaining pattern")


# by country
# make a list of DF
by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()

# DF of one country
by_country$data[1]

# function for one DF
country_model <- function(df) {
  lm(lifeExp~year, data=df)
}

# apply the function to all countries
# List
models <- map(by_country$data, country_model)

# a row of DF
by_country <- by_country %>%
  mutate(model=map(data, country_model))

# filter
by_country %>%
  filter(continent=="Europe")

# arrange
by_country %>%
  arrange(continent, country)


# Calculate Residuals
by_country <- by_country %>%
  mutate(
    resids=map2(data, model, add_residuals)
  )


# unnest
resids <- unnest(by_country, resids)


# visualize
resids %>%
  ggplot(aes(year, resid)) +
  geom_line(aes(group=country), alpha=1/3) +
  geom_smooth(se=F)


#by continent
resids %>%
  ggplot(aes(year, resid, group=country)) +
  geom_line(alpha=1/3) +
  facet_wrap(~continent)


#single country
broom::glance(nz_mod)

glance <- by_country %>%
  mutate(glance=map(model, broom::glance)) %>%
  unnest(glance, .drop=T)
?unnest


glance %>%
  arrange(r.squared)

glance %>%
  ggplot(aes(continent, r.squared)) +
  geom_jitter(width=0.5)


bad_fit <- filter(glance, r.squared < 0.25)


gapminder %>%
  semi_join(bad_fit, by="country") %>%
  ggplot(aes(year, lifeExp, color=country)) +
  geom_line()


#Ex.1
#All country data have 12 periods.
by_country2 <- gapminder %>%
  group_by(continent, country) %>%
  mutate(avg=mean(year), year_n=year-mean(year)) %>%
  nest()

#model
#D1
country_model1 <- function(df) {
  lm(lifeExp~year_n, data=df)
}
#D2
country_model2 <- function(df) {
  lm(lifeExp~year_n+I(year_n^2), data=df)
}

#Estimate, Residuals
by_country2 <- by_country2 %>%
  mutate(model1=map(data, country_model1),
         model2=map(data, country_model2),
         resid1=map2(data, model1, add_residuals),
         resid2=map2(data, model2, add_residuals),
         glance1=map(model1, broom::glance),
         glance2=map(model2, broom::glance),
         qt=map(model2, qt))


#二次の項に関する推定値を出力する関数
qt <- function(model) {
  tibble(coef=summary(model)$coef[3,1],
         t=summary(model)$coef[3,3])
}


#人口の増加は低減する、t値が有意な国が多い

#特に新興国
by_country2 %>%
  unnest(qt) %>%
  select(continent, country, coef, t) %>%
  ggplot(aes(continent, t)) +
  geom_jitter(width=0.2)


#Ex.2
by_country2 %>%
  unnest(glance1) %>%
  select(continent, country, adj.r.squared) %>%
  ggplot(aes(continent, adj.r.squared)) +
  geom_jitter(width=0.2)
  

by_country2 %>%
  unnest(glance1) %>%
  select(continent, country, adj.r.squared) %>%
  ggplot(aes(continent, adj.r.squared)) +
  geom_beeswarm()


#Ex.3
by_country2 %>%
  unnest(glance1) %>%
  select(continent, country, adj.r.squared, data) %>%
  filter(adj.r.squared < 0.25) %>%
  unnest(data) %>%
  ggplot(aes(year, lifeExp, color=country)) +
  geom_line()

chk %>% top_n(5, adj.r.squared)




data.frame(x=list(1:3, 3:5))

data.frame(x=I(list(1:3, 3:5)),
           y=c("1, 2", "3, 4, 5"))



tibble(
  x=list(1:3, 3:5),
  y=c("1, 2", "3, 4, 5")
)

tribble(
  ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5"
)


#リスト列の作成
#nest
#group_byを使用
gapminder %>%
  group_by(country, continent) %>%
  nest()
#リスト化するデータ列を指定
gapminder %>%
  nest(year:gdpPercap)


df <- tribble(
  ~x1,
  "a,b,c",
  "d,e,f,g"
)

#ベクトル化関数を各要素に適用
df %>%
  mutate(x2=stringr::str_split(x1, ",")) %>%

df %>%
  mutate(x2=stringr::str_split(x1, ",")) %>%
  unnest()

class(stringr::str_split("a,b,c", ","))

sim <- tribble(
  ~f, ~params,
  "runif", list(min=-1, max=-1),
  "rnorm", list(sd=5),
  "rpois", list(lambda=10)
)

sim %>%
  mutate(sims=invoke_map(f, params, n=10))

#多値要約からリスト列を作る
mtcars %>%
  group_by(cyl) %>%
  summarize(q=quantile(mpg))

chk <- mtcars %>%
  group_by(cyl) %>%
  summarize(q=list(quantile(mpg)))

probs <- c(0.01, 0.25, 0.5, 0.75, 0.99)

mtcars %>%
  group_by(cyl) %>%
  summarize(p=list(probs), q=list(quantile(mpg, probs))) %>%
  unnest(c(p, q))
  

#名前付きリストからリスト列を作る
#要素名（列名）を各列の要素、内容をリストとする、enframe()
x <- list(
  a=1:5,
  b=3:4,
  c=5:6
)


df <- enframe(x)

df$name[[1]]
df$value[[1]]

#.は各リスト要素を表す
df %>%
  mutate(
    smry=map2_chr(
      name,
      value,
      ~stringr::str_c(.x, ": ", .y[1])
    )
  )


#Ex.1
#色々

#Ex.2
#色々

#Ex.3
mtcars %>%
  group_by(cyl) %>%
  summarize(name=list(names(quantile(mpg))),
            q=list(quantile(mpg))) %>%
  unnest(c(name, q))

names(quantile(mtcars$mpg))


#Ex.4
#summarize_eachもしくはacrossを用いてリスト列を作成
mtcars %>%
  group_by(cyl) %>%
  summarize_each(funs(list), gear:carb)

mtcars %>%
  group_by(cyl) %>%
  summarize(across(gear:carb,list))


#リスト列を元に戻す

df <- tribble(
  ~x,
  letters[1:5],
  1:3,
  runif(5)
)


#要素毎に一意の値を返す処理を適用
df %>% mutate(
  type=map_chr(x, typeof),
  length=map_int(x, length)
)

df <- tribble(
  ~x,
  list(a=1, b=2),
  list(a=2, c=4)
)

#要素名で一意の値を抽出する
df %>%
  mutate(
    a=map_dbl(x, "a"),
    b=map_dbl(x, "b", .null=NA_real_)
  )


df <- tibble(x=1:2, y=list(1:4, 1))

#unnestを使用
df %>%
  unnest(y)


df1 <- tribble(
  ~x, ~y, ~z,
  1, c("a", "b"), 1:2,
  2, "C", 3
)

df1 %>% unnest(c(y, z))

df2 <- tribble(
  ~x, ~y, ~z,
  1, "a", 1:2,
  2, c("b", "c"), 3
)

df2 %>% unnest(c(y, z))



#以下は同じ
mtcars %>%
  split(mtcars$cyl)

mtcars %>%
  split(.$cyl)

#~で片側フォーミュラ（無名関数）
mtcars %>%
  split(.$cyl) %>%
  map(~lm(mpg~wt, data=.))


#Ex.1
#常に名前付き位置ベクトル（アトミックベクトル）を返すから？

#Ex.2
#リストは複数の型の要素の混在を許容する


#broomは滅茶苦茶使えそう
#モデルの推定量等をtibbleとして出力する


install.packages("ggbeeswarm")
library(ggbeeswarm)

library(gapminder)
install.packages("gapminder")

library(tidyverse)
library(modelr)

