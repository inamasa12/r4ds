#Ex.1, Ex.2


x <- rnorm(100)

range(x)

rescale01 <- function(x) {
  rng <- range(x, na.rm=T)
  (x-rng[1]) / (rng[2]-rng[1])
}

rescale01 <- function(x, y) {
  rng <- range(x, na.rm=T, finite=y)
  (x-rng[1]) / (rng[2]-rng[1])
}

rescale01 <- function(x, y, z) {
  rng <- range(x, na.rm=y, finite=z)
  (x-rng[1]) / (rng[2]-rng[1])
}

rescale01 <- function(x, y, z) {
  rng <- range(x, na.rm=y, finite=z)
  norm <- (x-rng[1]) / (rng[2]-rng[1])
  ifelse(is.nan(norm) | is.infinite(norm), sign(x)*1, norm)
}

rng <- range(x, na.rm=T, finite=T)
norm <- (x-rng[1]) / (rng[2]-rng[1])
ifelse(is.infinite(x) & (is.nan(norm) | is.infinite(norm)), sign(x)*1, norm)

x <- c(-10, 0, 10)
x <- c(1:10, Inf)
x <- c(1:10, NA, Inf)

#finite=TでNAも計算対象から除外される
rescale01(x, F, F)


#Ex.3
x <- c(1:10)
x <- c(1:10, Inf)
x <- c(1:10, NA)
x <- c(1:10, NA, Inf)

#欠損値の割合
na_ratio <- function(x) {
  mean(is.na(x))
}
na_ratio(x)

#各要素が占める割合
ratio <- function(x) {
  x / sum(x, na.rm=T)
}
ratio(x)

#変動係数
varr <- function(x) {
  sd(x, na.rm=T) / mean(x, na.rm=T)
}
varr(x)

#Ex.4
var(x, na.rm=T)

var_calc <- function(x) {
  m <- mean(x, na.rm=T)
  sum((x-m)^2, na.rm=T) / (sum(!is.na(x))-1)
}
var_calc(x)


var_skew <- function(x) {
  m <- mean(x, na.rm=T)
  sum((x-m)^3, na.rm=T) / sum((x-m)^2, na.rm=T)^(3/2) * sum(!is.na(x))^(1/2)
}

var_skew(x)

install.packages("moments")
library(moments)
x <- c(1:9, 15)
skewness(x, na.rm=T)


#Ex.5
x <- sample(c(1, NA), 10, replace=T)
y <- sample(c(1, NA), 10, replace=T)

both_na <- function(x, y) {
  sum(is.na(x) & is.na(y))
}
both_na(x, y)

#Ex.6
#フォルダならT、ファイルならF
is_directory <- function(x) file.info(x)$isdir

is_directory("challenge_local.csv")
list.files()
file.info(list.files()[1])


?file.info
#読み取り可能ならT、不可能ならF
is_readable <- function(x) file.access(x, 4)==0
file.access(list.files()[4], 0)
is_readable(list.files()[2])

#Ex.7
library(stringr)

little_bunny <- function(foo_foo) {
  str_c("Little bunny", foo_foo, sep=" ")
}

forest <- function(forest) {
  str_c("the", forest, sep=" ")
}

field_mice <- function(field_mice) {
  str_c("the", field_mice, sep=" ")
}

head <- function(head) {
  str_c("the", head, sep=" ")
}


foo_foo <- little_bunny("Foo Foo")
forest <- forest("forest")
field_mice <- field_mice("field mice")
head <- head("head")

hop <- function(last, through=forest){
  last <- str_c(last, "\n")
  hop <- str_c("Went hopping through", through, sep=" ")
  str_c(last, hop)
}

scoop <- function(last, up=field_mice){
  last <- str_c(last, "\n")
  scoop <- str_c("Scooping up", up, sep=" ")
  str_c(last, scoop)
}

bop <- function(last, on=head){
  last <- str_c(last, "\n")
  bop <- str_c("And bopping them on", on, sep=" ")
  str_c(last, bop)
}


cat(hop(foo_foo, forest))
cat(scoop(foo_foo, field_mice))
cat(bop(foo_foo, head))

cat(
  foo_foo %>%
    hop(through=forest) %>%
    scoop(up=field_mice) %>%
    bop(on=head)
)


#Ex.1
#指定の接頭辞に一致する関数かどうか
f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}

nchar("px_")
substr("abcde", 1, 3)

#最後の要素をカットする
f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}

x <- c(1:5)
length(x)
x[-5]
y <- "a"
y <- c("a", "b", "c")

#xの要素に対応する数だけyを繰り返す
f3 <- function(x, y){
  rep(y, length.out=length(x))
}

rep(y, length.out=length(x))

#Ex.3

?rnorm(10)

MASS::mvrnorm(10, mu=0, Sigma=1)

library(MASS)
rnorm_mass <- function(n, mean=0, sd=1){
  mvrnorm(n, mu=mean, Sigma=sd)
}
rnorm_mass(10)

#Ex.4
#確率密度値を返す
#接頭辞が揃っていることで同じ正規分布に関する関数であることが分かる
dnorm(1)
dnorm(-1)

#逆に
#同じ機能を持った関数でまとめることができる




?`if`

x <- c(1:5)
y <- c("a", "b", "c")

a <- names(x)
is.null(a)
any(2>1, 3>1, 1>3)
all(2>1, 3>1, 1>3)

x <- c(T, F, F, F, F, F, F, F)
y <- c(T, T, F, F, F, F, F, F)
z <- c(1, 2, 3, 4, 5, 6, 7, 8)

#横着評価では先頭の要素同士で評価する
x && y
x || y 

#全要素を評価する
x & y
x | y 


#Ex.1
?ifelse

#Ex.2
library(lubridate)

greetings <- function() {
  t <- now()
  if (hour(t) >= 18) {
    "good evening"
  } else if(hour(t) >= 12) {
    "good afternoon"
  } else {
    "good morning"
  }
}

greetings()

#Ex.3

x <- 8
x <- c(1:20)

fizzbuzz <- function(x) {
  if (all(x%%3==0, x%%5==0)) {
    "fizzbuzz"
  } else if (all(x%%3==0, x%%5!=0)) {
    "fizz"
  } else if (all(x%%3!=0, x%%5==0)) {
    "buzz"
  } else {
    x
  }
}

fizzbuzz <- function(x) {
  if (x%%3==0 & x%%5==0) {
    "fizzbuzz"
  } else if (x%%3==0 & x%%5!=0) {
    "fizz"
  } else if (x%%3!=0 & x%%5==0) {
    "buzz"
  } else {
    x
  }
}

x <- 15
ifelse(x%%3==0 & x%%5==0, 
       "fizzbuzz", 
       ifelse(x%%3==0 & x%%5!=0,
              "fizz",
              ifelse(x%%3!=0 & x%%5==0,
                     "buzz",
                     x)))

fizzbuzz(x)

x %% 3

#Ex.4
#ベクトルにも使用できる
temp <- c(1:20)
temp <- 10
cut(temp, breaks=c(-Inf, 0, 10, 20, 30, Inf), labels=c("freezing", "cold", "cool", "warm", "hot"))
cut(temp, breaks=c(-Inf, 0, 10, 20, 30, Inf), right=F, labels=c("freezing", "cold", "cool", "warm", "hot"))


#Ex.5
#switch内では文字列的に使用する必要がある
x <- 1
switch(x,
       "1" = "a",
       "2" = "b",
       "3" = "c"
)

#これでもOK
x <- 3
switch(x, "a", "b", "c")

#Ex.6
#次の引数の値を返す
x <- "e"
switch(x,
       a = ,
       b = "ab",
       c = ,
       d = "cd"
)



qnorm(1)

runif(10)

letters
LETTERS


if(!is.na(logical(na.rm))){
  stop("`na.rm` must be logical")
}


stopifnot(is.logical(na.rm))


library(stringr)
commas <- function(...) str_c(..., collapse=", ")
commas(letters[1:10])

x <- "Important output"
paste0(x)

getOption("width")


paste0(letters[1:10])
chk <- paste0(c("a", "b"))
length(chk)
nchar(x)

title <- paste0(x)
width <- getOption("width") - nchar(title) - 5
str_dup("-", width)

rule <- function(..., pad="-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", str_dup(pad, width), "\n", sep="")
}

rule("Important output")
rule("a", "b", "c")

x <- c(1, 2)
sum(x, na.mr=T)

sum(x, na.rm=T)

commas(letters, collapse=", ")
str_c(letters, collapse=", ")
commas(letters, ", ")

#Ex.1
#全ての引数を連結しようとする

#Ex.2
rule <- function(..., pad="-") {
  title <- paste0(...)
  cnt <- str_count(pad)
  width <- (getOption("width") - nchar(title)) %/% cnt - 5
  cat(title, " ", str_dup(pad, width), "\n", sep="")
}

rule("Title", pad="-+")
rule("a", "b", "c", pad="-+")
str_count(pad)

#Ex.3
#trim範囲を除いた標本平均
?mean
mean(c(0:10, 1000), trim=0.1)
sum(c(1:10))

#Ex.4
#各種相関係数を選択できる
#デフォルトはピアソン
?cor


#Ex.5
str(relig)
#返り値を表示しない
invisible(relig)

str(mtcars)

show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep="")
  invisible(df)
}

mtcars %>%
  show_missings() %>%
  mutate(mpg=ifelse(mpg<20, NA, mpg)) %>%
  show_missings()

replicate(100, 1 + 2)







library(tidyverse)
