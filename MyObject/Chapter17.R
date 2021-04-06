

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

output <- vector("double", ncol(df))
typeof(output)

for (i in seq_along(df)) {
  output[[i]] <- median(df[[i]])
}

typeof(df[[1]])


y <- vector("double", 0)

for (i in seq_along(y)) {
  print(i)
}

for (i in 1:length(y)) {
  print(i)
}


#Ex.1
#a
length(mtcars)
op <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
  op[[i]] <- mean(mtcars[[i]])
}
names(mtcars)

op <- vector("double", ncol(mtcars))
names(op) <- names(mtcars)
for (i in names(mtcars)) {
  op[[i]] <- mean(mtcars[[i]])
}

#b
flights

op_type <- vector("list", ncol(flights))
names(op_type) <- names(flights)
for (i in names(flights)) {
  op_type[[i]] <- class(flights[[i]])
}

#c
str(iris)
names(iris)
uniq_cnt <- vector("integer", ncol(iris))
names(uniq_cnt) <- names(iris)
for (i in names(iris)) {
  uniq_cnt[[i]] <- length(unique(iris[[i]]))
}

length(unique(iris[[names(iris)[1]]]))
names(iris)[1]

#d
rnorm_v <- list()
mu <- c(-10, 0, 10, 100)
for (i in seq_along(mu)) {
  rnorm_v[[i]] <- rnorm(10, mean=mu[i], sd=1)
}

mu <- c(-10, 0, 10, 100)
rnorm_v <- vector("list", length(mu))
for (i in seq_along(mu)) {
  rnorm_v[[i]] <- rnorm(10, mean=mu[i], sd=1)
}

#Ex.2
out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}

out2 <- stringr::str_c(letters, collapse="")
str_c(letters, collapse="")
paste(letters, collapse="")

#標本標準偏差
x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
  sd <- sd + (x[i] - mean(x)) ^ 2
}
sd <- sqrt(sd / (length(x) - 1))

sqrt(sum((x - mean(x)) ^ 2) / (length(x) - 1))
sd(x)

#累和
x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
  out[i] <- out[i-1] + x[i]
}

cumsum(x)

#Ex.3
#a
Alice <- function(x) {
  for (i in 1:3) {
    print(paste(c("Alice the camel has ", x, ifelse(x=="one", " hump", " humps")), collapse=""))
  }
  print(ifelse(x=="no", "Now Alice is a horse.", "So go, Alice, go.")) 
}
Alice("two")


for (i in c("five", "four", "three", "two", "one", "no")) {
  Alice(i)
}


#b

bed <- function(x) {
  cat(paste(c("There ",
              ifelse(x=="one", "was ", "were "),
              x, 
              " in the bed\n"
  ), collapse=""))
  cat("And the little one said, \n")
}

bed("ten")
bed("one")

roll <- function(x) {
  if(x == "one") {
    cat("\nAlone at last!\n")
  } else {
    cat("Roll over! Roll over!\nSo they all rolled over and one fell out\n")
  }
}

roll("one")
roll("ten")

for (i in c("ten", "nine", "eight", "seven", "six", "five", "four", "three", "two", "one")) {
  bed(i)
  roll(i)
}

#c
# beer
10:1

x <- 1
y <- "beer"


bottle <- function(x, y) {
  cat(x, ifelse(x==1, "bottle", "bottles"), "of", y, "on the wall,\n")
  cat(x, ifelse(x==1, " bottle", " bottles"), " of ", y, "!\n", sep="")
  cat(ifelse(x==1, "Take it down,\n","Take 1 down\n"))
  cat("Pass it around,\n")
  cat(ifelse(x-1==0, "No more", x-1), ifelse(x==2, "bottle", "bottles"), "of", y, "on the wall!\n")
}

bottle(x, y)


#d
x <- 1:10000

f1 <- function(x) {
  output <- vector("integer", 0)
  for (i in seq_along(x)) {
    output <- c(output, length(x[[i]]))
  }
  output
}

f2 <- function(x) {
  output <- vector("integer", length(x))
  for (i in seq_along(x)) {
    output[[i]] <- length(x[[i]])
  }
  output
}

op <- f1(x)
op <- f2(x)

microbenchmark(f1(x), f2(x), times=100)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

rescale01 <- function(x) {
  rng <- range(x, na.rm=T)
  (x - rng[1]) / (rng[2] - rng[1])
}

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}

class(df[[1]])
sample(100, 1)


dir("/data/", pattern="\\.csv$", full.names=T)

#Ex.1

files <- dir("../data", pattern="\\.csv$", full.names=T)
out <- vector("list", length(files))
for (i in seq_along(files)) {
  out[[i]] <- read_csv(files[i])
}
out_last <- bind_rows(out)

#Ex.2
#一部だけの場合はNA、全く設定されていない場合はNULLの扱い

x <- 1:10
y <- 1:10
names(x) <- c(letters[1:9], NULL)
names(x)
names(x) <- NULL
names(y)
x <- set_names(x[6:10], letters[1:5])

for (nm in names(x)) {
  print(nm)
}


names(x[6]) <- NULL
names(x)[6] <- NULL


#Ex.3
mean(iris)
str(iris)

mean_df <- function(df) {
  for(i in seq_along(df)) {
    if(is.numeric(df[[i]])) {
      cat(sprintf("%s: %3.2f\n", names(df[i]), mean(df[[i]])))
    }
  }
}

mean_df(iris)

#Ex.4
#特定のデータフレーム列に適用する関数リストの設定と実行
trans <- list(
  disp = function(x) x*0.0163871,
  am = function(x) {
    factor(x, labels=c("auto", "manual"))
  }
)
for (var in names(trans)) {
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}

head(mtcars_copy)
head(mtcars)



df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)


output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}

col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[[i]] <- mean(df[[i]])
  }
  output
}


col_summary(df, median)
col_summary(df, mean)

#関数名を変数にできる
col_summary <- function(df, x) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- x(df[[i]])
  }
  out
}

col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}



#Ex.1
#行、列方向のループ
?apply

x <- cbind(x1 = 3, x2 = c(4:1, 2:5))
dimnames(x)[[1]] <- letters[1:8]
apply(x, 2, mean, trim = .2)



#Ex.2
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10),
  e = letters[1:10]
)

col_summary2 <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    if(is.numeric(df[[i]])) {
      out[i] <- fun(df[[i]])
    } else {
      out[[i]] <- NA
    }
  }
  out
}


col_summary3 <- function(df, fun) {
  out <- vector("double", length(df))
  out_col <- vector("logical", length(df))
  for (i in seq_along(df)) {
    if(is.numeric(df[[i]])) {
      out[i] <- fun(df[[i]])
      out_col[i] <- T
    } else {
      out[i] <- NA
      out_col[i] <- F
    }
  }
  out[out_col]
}

#Trueの要素番号
which(c(T, F))

?is_numeric
is.numeric(df[[5]])

?which

col_summary3(df, mean)



which(LETTERS == "R")



df
#dfの列毎に処理
map_dbl(df, mean)

df %>% map_dbl(median)

mtcars

?map_dbl


models <- mtcars %>%
  split(.$cyl) %>%
  map(~lm(mpg~wt, data=.))

models %>%
  map(summary) %>%
  map_dbl(~.$r.squared)

chk[[1]]$r.squared

x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x %>%
  map_dbl(2)



#Ex.1
#a
mtcars %>%
  map_dbl(mean)

#Ex.2
#b
flights %>%
  map_chr(mode)
flights %>%
  map_chr(typeof)

#c
head(iris)
length(unique(iris$Sepal.Length))

iris %>%
  map_int(function(l) length(unique(l)))

iris %>%
  map(unique) %>%
  map_int(length)

#d
#リストの要素だけではなく、ベクトルの各要素にmapを適用することもできる
mu <- list(-10, 0, 10, 100)
mu <- c(-10, 0, 10, 100)
mu %>%
  map(function(l) rnorm(10, l))

mu %>%
  map(~rnorm(10, .))


#Ex.2
diamonds %>%
  map_lgl(~is.factor(.))

iris %>%
  map_lgl(~is.factor(.))

#Ex.3
#同様に機能する
map(1:5, runif)

#Ex.4
#ベクトルで指定した値を平均値とする5個の乱数を生成
#第二引数以下は関数指定の後に変数名とともに追加していく
map(-2:2, rnorm, n=5)

#Ex.5
mtcars %>%
  split(.$am) %>%
  map(function(df) lm(mpg~wt, data=df))

mtcars %>%
  split(.$am) %>%
  map(~lm(mpg~wt, data=.))


#mapはデータ、パラメータのどちらでもループできる

safe_log <- safely(log)
str(safe_log(10))
str(safe_log("a"))

x <- list(1, 10, "a")
x %>% log
x %>% map(log)
x %>% map(safe_log)
x %>% 
  map(safe_log) %>% 
  transpose()

y <- x %>% 
  map(safe_log) %>% 
  transpose()

is_ok <- y$error %>%
  map_lgl(is_null)

x[is_ok]
x[!is_ok]

#エラー時に指定の値を返す
x %>%
  map_dbl(possibly(log, NA_real_))

#エラー時にメッセージを出力する
c(1, -1) %>%
  map(quietly(log))

#複数変数
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)

seq_along(mu) %>%
  map(~rnorm(5, mu[[.]]), sigma[[.]]) %>%
  str()

#リストの要素番号をイテレーションする
seq_along(mu) %>%
  map_dbl(~mu[[.]])

map2(mu, sigma, rnorm, n=5) %>% str()

n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)

args1 %>%
  pmap(rnorm) %>%
  str()

args2 <- list(mean=mu, sd=sigma, n=n)
args2 %>%
  pmap(rnorm) %>%
  str()


#変数列をDFで
params <- tribble(
  ~mean, ~sd, ~n,
  5, 1, 1,
  10, 5, 3,
  -3, 10, 5
)

params %>%
  pmap(rnorm) %>%
  str()


#関数をループさせる
f <- c("runif", "rnorm", "rpois")
#各関数のパラメータ
param <- list(
  list(min=-1, max=1),
  list(sd=5),
  list(lambda=10)
)

invoke_map(f, param, n=5) %>% str()

sim <- tribble(
  ~f, ~params,
  "runif", list(min=-1, max=1),
  "rnorm", list(sd=5),
  "rpois", list(lambda=10)
)

chk <- sim %>%
  mutate(sim=invoke_map(f, params, n=10))

chk$sim


#map3はない
?map3


x <- list(1, "a", 3)
x %>% print
x %>% walk(print)

chk1 <- print(x)
cnk2 <- walk(x, print)



plots <- mtcars %>%
  split(.$cyl) %>%
  map(~ggplot(., aes(mpg, wt)) + geom_point())
paths <- str_c(names(plots), ".pdf")

pwalk(list(paths, plots), ggsave, path=tempdir())
pmap(list(paths, plots), ggsave, path=tempdir())


head(iris)

iris %>%
  keep(is.factor) %>%
  str()

iris %>%
  discard(is.factor) %>%
  str()

x <- list(1:5, letters, list(10))
is_character(x)

x %>% is_character()

x %>% map(is_character)
x %>% some(is_character)
x %>% every(is_character)


#真となる最初の要素、要素番号を返す
x <- sample(10)
x %>% detect(~. >5)
x %>% detect_index(~. >5)


#真となる先頭もしくは末尾からの要素列
x %>% head_while(~. >5)
x %>% tail_while(~. >5)



dfs <- list(
  age=tibble(name="John", age=30),
  sex=tibble(name=c("John", "Mary"), sex=c("M", "F")),
  trt=tibble(name="Mary", treatment="A")
)


#各要素のペアに順次関数を適用
dfs$age
dfs$sex
dfs$trt
full_join(dfs$age, dfs$sex) %>%
  full_join(dfs$trt)

a <- full_join(dfs$age, dfs$sex)
full_join(a, dfs$trt)

dfs %>% reduce(full_join)

vs <- list(
  c(1, 3, 5, 6, 10),
  c(1, 2, 3, 7, 8, 10),
  c(1, 2, 3, 4, 8, 9, 10)
)

vs %>% reduce(intersect)

#accumulateも同様だが各段階の演算結果を保持する
x <- sample(10)
x %>% accumulate(`+`)

#Ex.1
x <- list(1:5, letters, list(10))
x %>% every(is_character)
y <- list("a", "b", "c")

every_ori <- function(x) {
  resv <- vector("logical", length(x))
  for (i in seq_along(x)) {
    resv[i] <- is_character(x[[i]])  
  }
  all(resv)
}

every_ori(x)
every_ori(y)

i <- 1
x[[i]]

resv[1]

#Ex.2
?col_sum

col_summary3 <- function(df, fun) {
  out <- vector("double", length(df))
  out_col <- vector("logical", length(df))
  for (i in seq_along(df)) {
    if(is.numeric(df[[i]])) {
      out[i] <- fun(df[[i]])
      out_col[i] <- T
    } else {
      out[i] <- NA
      out_col[i] <- F
    }
  }
  out[out_col]
}


df %>% 
  keep(is.numeric) %>%
  map_dbl(mean)

col_summary4 <- function(df, fun) {
  keep(df, is.numeric) %>%
    map_dbl(fun)
}

col_summary4(df, mean)


#Ex.3

df <- tibble(
  x = 1:3,
  y = 3:1,
  z = c("a", "b", "c")
)
length(df)

for (nm in names(df)) {
  print(df[[nm]])
}


#spplyは要素の名前付きベクトルを返す
col_sum3 <- function(df, f) {
  #is_num <- sapply(df, is.numeric)
  is_num <- ifelse(is.list(sapply(df, is.numeric)),
                   0,
                   sapply(df, is.numeric))
  df_num <- df[, is_num]
  sapply(df_num, mean)
}

#解が無い場合、sapplyは空のリストを返す

col_sum3(df, mean)
col_sum3(df[1:2], mean)
col_sum3(df[1], mean)
col_sum3(df[0], mean)

is.list(sapply(df, is.numeric))
is.list(sapply(df, is.numeric))

is_num <- ifelse(is.numeric(sapply(df[0], is.numeric)),
                 sapply(df[0], is.numeric),
                 0)

df_num <- df[, is_num]
sapply(df_num, f)

df_num <- df[, 0]
sapply(df_num, f)

typeof(is_num)

sapply(df_num, mean)
str(is_num)





test <- function(x) {
  x 1
}


library(stringr)
library(purrr)
library(microbenchmark)
library(nycflights13)
library(tidyverse)
library(lubridate)