library(tidyverse)

getwd()

heights <- read_csv("../data/heights.csv")
rm(height)

read_csv("a, b, c
         1, 2, 3
         4, 5, 6")

#Ex.1
read_delim(file, delim="|")

#Ex.2
?read_csv
#全て共有

#Ex.3
?read_fwf
#col_positions

#Ex.4
x <- "x, y\n1, 'a, b'"
read_csv(x)
read_csv(x, quote="'")

#Ex.5
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\n1,b")
read_csv("a;b\n1;3")

read_csv("a,b\n\",1")


read_csv("a,b\n1,\"")
read_csv("a,b\n\',1,c,d")
read_csv("a,b\n\"1")
read_csv("a,b\n\"1\"")
read_csv("a,b\n\"1,c\",w")
read_csv("a,b\n\"1,c")

#ベクトルのパース
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

a <- parse_integer(c("123", "345", "abc", "123.45"))
problems(a)


#数字

parse_double("1.23")
parse_double("1,23", locale=locale(decimal_mark=","))
parse_number("$100")
parse_number("123.456.789",
             locale=locale(grouping_mark="."))

#文字列
charToRaw("Hadley")

x1 <- "El Ni\xf10 was particulary bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(x1, locale=locale(encoding="Latin1"))
parse_character(x2, locale=locale(encoding="Shift-JIS"))


guess_encoding(charToRaw(x1))

#16進数のベクトルに変換
?charToRaw

#Time Series
parse_datetime("2010-10-01T2010")
parse_datetime("20101001")
parse_date("2019-05-01")


library(hms)
parse_time("01:10 am")

parse_date("01/02/15", "%m/%d/%y")

parse_date("1 janvier 2015", "%d %B %Y", locale=locale("fr"))

#Ex.1
#国ごとの標準の設定を規定
locale("ja")


#Ex.2
parse_number("12.345,67", locale=locale(grouping_mark="."))
parse_number("12,345.67")

#一方を決めるともう一方が決まる
locale(grouping_mark=".")
locale(decimal_mark=",")
             
#Ex.3
#Ex.4
#日時の形式を設定
jp_locale <- locale(date_format="%Y年%m月%d日", time_format="%H時%M分%S秒")

parse_date("2002年5月5日", locale=jp_locale)
parse_time("20時46分35秒", locale=jp_locale)


#Ex.5
#read_csv: ,
#read_csv2: ;

#Ex.6
#Europe: Latin1
#Japan: Shift-JIS

#Ex.7
d1 <- "January 7, 2010"
parse_date(d1, "%B%e, %Y")

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")

d3 <- "08-Jun-2017"
parse_date(d3, "%d-%b-%Y")

d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")

d5 <- "12/30/14"
parse_date(d5, "%m/%d/%y")

t1 <- "1705"
parse_time(t1, "%H%M")

t2 <- "11:15:10.12 PM"
parse_time(t2, "%H:%M:%OS %p")


#ファイルのパース
library(tidyverse)
guess_parser("2010-10-01")

str(parse_guess("2010-10-01"))

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  ))

tail(challenge)
View(challenge)

?parse_xyz

challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max = 1001
)


#一旦文字で読んでからパースする
challenge3 <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(.default=col_character()))

tail(challenge3)
challenge3
type_convert(challenge3)




write_csv(challenge, "challenge_local.csv")
test <- read_csv("challenge_local.csv")

write_rds(challenge, "challenge_local.rds")
test <- read_rds("challenge_local.rds")

install.packages("feather")
library(feather)
write_feather(challenge, "challenge_local.feather")
test <- read_feather("challenge_local.feather")


