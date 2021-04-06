

typeof(letters)

typeof(1:10)

length(letters)

class(letters)

#論理ベクトル
1:10 %% 3 ==0
c(T, T, F, NA)

#数値ベクトル
#実数
typeof(1)
#整数
typeof(1L)

#NULL: 空
#NA: 欠損値
#NaN: Not a number、非数

c(-1, 0, 1) / 0

x <- "This is a reasonably long string."
object_size(x)

y <- rep(x, 1000)
object_size(y)

NA_character_
NA_real_

#Ex.1
#NA、NaNの処理が逆になる
x <- NaN
is.finite(x)
!is.infinite(x)

#Ex.2
?near
#.Machine$double.eps^0.5の範囲で一致しているかどうか
near(1, 1)

#Ex.3
typeof(c(T, F, NA))
typeof(.Machine$integer.max)
typeof(-.Machine$integer.max)

typeof(.Machine$double.xmax)
typeof(-.Machine$double.xmax)


#Ex.4
x <- c(-2.4, -1.6, 0, 1.5, 2.5)

#四捨五入だが、五は偶数になるよう丸める
round(x)

floor(x) #超えない最大値
ceiling(x) #超える最小値
trunc(x) #ゼロに近くなるよう切り捨て
signif(x, digits = 1) #指定の有効桁数に丸める、round同様の計算

?round



#Ex.5
parse_logical(c("TRUE", "FALSE", "1", "0", "true", "t", "NA"))

parse_integer(c("1235", "0134", "NA"))

parse_integer(c("1000", "$1,000", "$1,000.11", "10.00", "NA"))

parse_number(c("1000", "$1,000", "$1,000.11", "10.00", "NA"))
parse_double(c("1000", "$1,000", "$1,000.11", "10.00", "NA"))


as.logical(c("TRUE", "FALSE", "1", "0", "true", "t", "NA"))
as.integer(c("1235", "0134", "NA"))




x <- sample(20, 100, replace=T)
y <- x > 10
sum(y)
mean(y)

typeof(c(T, 1L))
typeof(c(1.5, 1L))
typeof(c(1.5, "a"))

x <- letters[1:5]
x[c(1, 1, 5, 5, 2, 2)]

typeof(x[1])
str(x[1])

typeof(x[[1]])

#Ex.1
x <- c(0, NA, Inf, 5)

#NA、欠損値の割合
mean(is.na(x))

#有限でないデータ数
sum(!is.finite(x))
#無限のデータ数
sum(is.infinite(x))

#Ex.2
#指定の型（mode）のベクトルで、名前以外の属性を持っていない場合にTRUE
is.vector(x)

is.atomic(x)
#アトミックベクトルの場合にTRUE
?is.vector
?is.atomic



mode(x)
typeof(x)


#Ex.3
#ベクトルの要素に名前を設定する
?setNames

#setNames同様だが、より細かい指定が可能
?set_names


#Ex.4
#a
x <- letters[1:5]
str(x[length(x)])
str(x[[length(x)]])

lv <- function(x){
  x[length(x)]
}

lv(1:5)

#b
x <- LETTERS[1:20]

on <- function(x) {
  if(length(x)>1){
    x[seq(2, length(x), by=2)]
  } else {
    NA
  }
}

on <- function(x) {
  if(length(x)>1){
    x[seq_along(x) %% 2 == 0]
  } else {
    NA
  }
}

on(x)

#c
x <- LETTERS[1:20]

exlv <- function(x){
  x[-length(x)]
}

exlv(1)


#d
x <- sample(-10:10, 20)
od <- function(x) {
  x[x %% 2 == 0]
}

od(x)

#Ex.5
#Nanの取り扱いが異なる
x <- c(sample(-10:10, 20), Inf, -Inf, NA, NaN)

#該当する要素番号を取得
#NaNはNaNとしてそのまま表示される（x>0ではないため）
x[-which(x>0)]

#NaNはNA（x<=0の判定ができない）として表示される
x[x <= 0]

#Ex.6
#NAを返すかエラー
length(x)
x[25]
x[[25]]

#NAを返すかエラー
?set_names
y <- set_names(1:3, c("a", "b", "c"))
y["c"]
y[["d"]]


x <- list(1, 2, 3)
str(x)

x_named <- list(a=1, b=2, c=3)

y <- list("a", 1L, 1.5, TRUE)
z <- list(list(1, 2), list(3, 4))

a <- list(a=1:3, b="a string", c=pi, d=list(-1, -5))
#List of List
a[4]
#List
a[[4]]

a[1]
a[[1]]

a$a


#Ex.1
list(a, b, list(c, d), list(e, f))
list(list(list(list(list(list(a))))))

#Ex.2
str(mtcars)
mtcars_tbl <- tibble(mtcars)
str(mtcars_tbl[1])
typeof(mtcars_tbl[[1]])
mtcars_tbl$mpg

#tibbleは同じ長さのアトミックベクトルのみ要素として扱える

x <- 1:10
attributes(x)
names(x)
dim(x)
mode(x)
class(x)


#typeofとmodeはほぼ同じ
#modeはintegerとdoubleをnumericとする
x <- array(1:10)
typeof(x)
mode(x)
class(x)
str(x)
attributes(x)

as.Date
methods(as.Date)

getS3method("as.Date", "default")

print

#ジェネリック関数、入力のクラスに応じて振る舞いを（実行するメソッドを）変える関数
#クラスは属性として保持される


x <- factor(c("a", "b", "c"), levels=c("a", "b", "c"))
typeof(x)
mode(x)
attributes(x)
str(x)

x <- as.Date("1971-01-01")
x <- ymd_hm("1970-01-01 01:00")

attr(x, "tzone") <- "US/Pacific"

x <- as.POSIXlt(x)

y <- unclass(x)

tb <- tibble(x=1:5, y=5:1)
typeof(tb)

class(x)
typeof(x)
str(x)
attributes(x)

#Ex.1
#double型のスカラー
#units属性を持ち、secで管理されている
x <- hms::hms(3600)

#Ex.2
#各列の長さが異なるとエラーになる
tibble(a=1:3, b=1:5)

#Ex.3
#データフレームを含めて可能
x <- tibble(a=list(1:3), b=list(4:6))
y <- as.data.frame(x)

attributes(y)

x$a


View(y)
?hms::hms

is.vector(x)

x <- c("a", 1, NA, "b", 5)
mode(x)


library(pryr)
library(tidyverse)
library(lubridate)
