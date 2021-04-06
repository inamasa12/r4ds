
library(tidyverse)


#tibbleの作成

as_tibble(iris)

tibble(
  x=1:5,
  y=1,
  z=x^2+y
)

tribble(
  ~x, ~y, ~z,
  "a", 2, 3.6,
  "b", 1, 8.5
)

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3), 
  e = sample(letters, 1e3, replace=T)
)

#全列表示、width
flights %>% print(n=10, width=Inf)
flights %>% View()



df <- tibble(
  x=runif(5),
  y=rnorm(5)
)

df$x
#要素
df[["x"]]
#tibbleの部分集合
df["x"]
df[[1]]

df %>% .$x
df %>% .[["x"]]

as.data.frame(df)

#Ex.1
class(mtcars)
as_tibble(mtcars)
is_tibble(mtcars)

#Ex.2

#dfは部分一致で抽出する

df <- data.frame(abc=1, xyz="a")
df$x
df[["xyz"]]
class(df[, "xyz"])
df[, c("abc", "xyz")]


tb <- as_tibble(df)
tb$x
class(tb[["xyz"]])
class(tb["xyz"])
tb[, c("abc", "xyz")]

#Ex.3
var <- "mpg"

mtc_tbl <- as_tibble(mtcars)

mtc_tbl[[var]]
mtc_tbl[var]
mtc_tbl[, var]


#eX.4
#`1`で変数名を表す
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying
annoying$`1`
annoying[["1"]]
annoying["1"]

ggplot(annoying) +
  geom_point(aes(`1`, `2`))

ann_rev <- annoying %>%
  mutate(`3`=`2` / `1`)

ann_rev %>%
  select(one=`1`, two=`2`, three=`3`)

#Ex.5
?enframe
#名前付きベクトルを名前付きデータフレームに変換

#Ex.6
#widthは表示の幅を指定する

options(tibble.width=NULL)
options("tibble.width")

flights %>% print(width=70)

#n_extraは最後に表示する列名の数を指定する
flights %>% print(width=70, n_extra=5)

#nは表示するデータ数（行数）を指定する
flights %>% print(width=70, n=5)

