

string1 <- 'This is a string'
string2 <- 'To put a "quote" inside a string, use single quoter'

string3 <- '\''
writeLines(string3)

string4 <- '\u00b5'


str_length(c('abc', 'def'))


#連結
str_c('x', 'y')
str_c('x', 'y', sep=', ')




x <- c('abc', NA)
y <- c('abc', 'def')
str_c('|-', x, '-|') #NAは処理できない
str_replace_na(x) #NAを文字列に変換する



name <- 'Hadley'
time_of_day <- 'morning'
birthday <- T
str_c(
  'Good ', time_of_day, ' ', name,
  if(birthday) ' and HAPPY BIRTHDAY',
  '.'
)

#文字のベクトルをまとめる
str_c(c('x', 'y', 'z'), collapse=', ')

x <- c('Apple', 'Banana', 'Pear')
str_sub(x, 1, 3)
str_sub('Apple', 1, 3)

str_sub(x, -3, -1)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

str_to_title(x)

str_to_upper('i')
str_to_upper('i', locale='tr')


x <- c('apple', 'eggplant', 'banana')
str_sort(x, locale='en')
str_sort(x, locale='haw')


#Ex.1, 2
#sep: 文字を連結
paste('x', 'y')
str_c('x', 'y', sep=' ')

paste0('x', 'y')
str_c('x', 'y', 'z')
str_c(c('a', 'b'), c('x', 'y'))


paste('x', NA)
str_c('x', str_replace_na(NA), sep=' ')


#collapse: ベクトルの要素を連結
paste(c('x', 'y'), collapse='_')

#Ex3
x <- c('abc', 'abcd', 'abcdf')
str_sub(x, (str_length(x)+1)%/%2, (str_length(x)+1)%/%2 +(str_length(x)+1)%%2)
str_length(x)

#Ex.4
#表示する文の長さを指定する
thanks_path <- file.path(R.home("doc"), "THANKS")
thanks <- str_c(readLines(thanks_path), collapse = "\n")
thanks <- word(thanks, 1, 3, fixed("\n\n"))

cat(str_wrap(thanks, width=90))

#Ex.5
#端の空白を取り除く
str_trim(' abc ')
#端に指定の文字を入れる
str_pad('abc', 5, pad='$')

#Ex.6
x <- c()
x <- c('a')
x <- c('a', 'b')
x <- c('a', 'b', 'c')

str_c(x, collapse=', ')


x <- c('apple', 'banana', 'pear')

str_view(x, 'an')
str_view(x, '.a.')

#正規表現における\と、それを文字列表現するための\の二つが必要になる
dot <- '\\.'
dot <- '\''
cat(dot)
str_view(c("abc","a.c", "bef"), "a\\.c")

y <- "a\\b"
cat(y)
reg <- "\\\\"
cat(reg)
str_view(y, reg)


#Ex.1
str <- "\\"
cat(str)
reg <- "\\"
cat(reg)
str_view(str, reg)
#"\"は文字列として認識されない
#"\\"は文字列\として認識されるが、正規表現においてはエスケープのみとなり認識されない
#"\\\"も文字列としてにんしきされない


#Ex.2
#文字列"'\

x <- "\"'\\"
cat(x)
str_view(x, "\\\\")
str_view(x, "\\'")
str_view(x, '\\"')
str_view(x, "\"'\\\\")

y <- '\\"'
z <- "\"'\\\\"

cat(y)
cat(z)

#Ex.3
#正規表現, \..\..\..
#恐らく、.〇.〇.〇
#この正規表現を文字列で表現する
x <- "1.2.3.4.5"
cat("\\..\\..\\..")

str_view(x, "\\..\\..\\..")


x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
#完全一致
str_view(x, "^apple$")

str_view_all(x, "e")
str_view_all(x, "\\bp")

cat("\\ba")


#Ex.1
cat("\\$\\^\\$")
str_view("$^$", "\\$\\^\\$")

#Ex.2
str_view(words[970:980], "^y")
str_view(words[1:30], "t$")
str_view(words[1:30], "^...$")
str_view(words, ".......", match=T)


#Ex.1
str_view(words, "^[aiueo]", match=T)
str_view(words, "^[^aiueo]+$", match=T)
str_view(words, "[^e]ed$", match=T)
str_view(words, "(ing$|ize$)", match=T)

#Ex.2
str_view(words, "(ci|ie)", match=F)
str_view(words, "[^c]i[^e]", match=T)
str_view(words, "(cei|[^c]ie)", match=T)
str_view(words, "cie", match=T) #ある

#Ex.3
#ない
str_view(words, "q[^u]", match=T)

#Ex.4
str_view(words, "ise", match=T)
str_view("080-5049-3734", "\\d\\d\\d-\\d\\d\\d\\d-\\d\\d\\d\\d", match=T)


x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "C+")

x <- "CCC CC CCCC C CCCCC"

#Ex.1
str_view_all(x, "C?")
str_view(x, "CC?")
str_view_all(x, "CCC?")
str_view_all(x, "CC+")
str_view_all(x, "CC*")

str_view_all(x, "CC?")
str_view_all(x, "CC{0,1}")

str_view_all(x, "CC+")
str_view_all(x, "CC{1,}")

str_view_all(x, "CC*")
str_view_all(x, "CC{0,}")

#Ex.2
#全て
r_str <- "^.*$"
cat(r_str)
str_view_all(words, r_str, match=T)

r_str <- "\\{.+\\}"
cat(r_str)
str_view_all("{aaa}", r_str)

r_str <- "\\d{4}-\\d{2}-\\d{2}"
cat(r_str)
str_view_all("1234-56-78", r_str)

r_str <- "\\\\{4}"
cat(r_str)
str_view_all("\\\\\\\\", r_str)

#Ex.3
str_view(words, "^[^aiueo]{3}", match=T)
str_view(words, "[aiueo]{3,}", match=T)
str_view(words, "([aiueo][^aiueo]){2,}", match=T)

str_view("*/", ".?.+")
str_view("**", "[*]+")


str_view(fruit, "(..)\\1", match=T)
cat("(..)\\1")
fruit


#Ex.1
str_r <- "(.)\\1\\1"
cat(str_r)
str_view("bazoooka", str_r, match=T)

str_r <- "(.)(.)\\2\\1"
cat(str_r)
str_view(words, str_r, match=T)

str_r <- "(.).\\1.\\1"
cat(str_r)
str_view(words, str_r, match=T)

str_r <- "(.)(.)(.).*\\3\\2\\1"
cat(str_r)
str_view("abcdefgfedcba", str_r, match=T)



#Ex.2
str_view(words, "^(.).*\\1$", match=T)
str_view(words, "(..).*\\1", match=T)
str_view(words, "(.).*\\1.*\\1", match=T)


x <- c("apple", "banana", "pear")

#マッチするか否か
str_detect(x, "e")
sum(str_detect(words, "^t"))
mean(str_detect(words, "^t"))

no_vowels_1 <- !str_detect(words, "[aeiou]")
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

words[str_detect(words, "x$")]
str_subset(words, "x$")

seq_along(words)

df <- tibble(
  word=words,
  i=seq_along(words)
)

df %>%
  filter(str_detect(words, "x$"))

mean(str_count(words, "[aeiou]"))


#Ex.1
str_subset(words, "(^x.*|.*x$)")

cond1 <- str_subset(words, "^x.*")
cond2 <- str_subset(words, ".*x$")
union(cond1, cond2)

str_subset(words, "^[aeiou].*[^aeiou]$")
cond1 <- str_subset(words, "^[aeiou]")
cond2 <- str_subset(words, "[^aeiou]$")
intersect(cond1, cond2)

#ない
cond1 <- str_subset(words, ".*a.*")
cond2 <- str_subset(words, ".*e.*")
cond3 <- str_subset(words, ".*i.*")
cond4 <- str_subset(words, ".*o.*")
cond5 <- str_subset(words, ".*u.*")
intersect(intersect(intersect(intersect(cond1, cond2), cond3), cond4), cond5)

words[str_count(words, "[aeiou]")==max(str_count(words, "[aeiou]"))]
max(str_count(words, "[aeiou]") / str_length(words))

words[str_count(words, "[aeiou]") / str_length(words) == 1]

sentences

colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse="|")
has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)

more <- sentences[str_count(sentences, color_match)>1]
str_view_all(more, color_match)
str_extract(more, color_match)

str_extract_all(more, color_match)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify=T)



#Ex.1
colors <- c("\\bred\\b", "\\borange\\b", "\\byellow\\b", "\\bgreen\\b", "\\bblue\\b", "\\bpurple\\b")
color_match <- str_c(colors, collapse="|")
str_view_all(sentences, color_match, match=T)

#Ex.2
head(sentences)
length(sentences)

str_extract(sentences, "^.+?\\b")
str_extract(sentences, "\\b[a-zA-Z]+ing\\b")
str_view(sentences, "\\b\\w+(s|es)\\b")

noun <- "(a|the) ([^ ]+)"
cat(noun)
has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)

#先頭の完全マッチを抽出
has_noun %>%
  str_extract(noun)

has_noun %>%
  str_match(noun)

has_noun %>%
  str_match_all(noun)


tibble(sentence=sentences) %>%
  extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove=F
  )


#Ex.1
number <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
str_number <- str_c(number, collapse="|")
str_view(sentences, str_c("\\b(", str_number, ")", " ([^ ]+)"), match=T)
str_match(sentences, str_c("\\b(", str_number, ")", " ([a-zA-Z]+)"))

#Ex.2
str_view(sentences, "'", match=T)
str_match(sentences, "(\\b[a-zA-Z]+)'([a-zA-Z]+\\b)")



x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1"="one", "2"="two", "3"="three"))

sentences %>%
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2")

#Ex.1
str_replace("a/b", "/", "\\")
cat(str_replace_all("a/b, c/d", "/", "\\\\"))


#Ex.2
str_to_lower("ABC")
str_replace_all("ABC", c("A"="a", "B"="b", "C"="c"))

#Ex.3
str_replace(words, "^(.).*(.)$", "\\2.*\\1")
str_replace(words, "^(.)(.*)(.)$", "\\3\\2\\1")
words[str_replace(words, "^(.)(.*)(.)$", "\\3\\2\\1")==words]



sentences %>%
  head(5) %>%
  str_split(" ")


#リストを返す
"a|b|c|d" %>%
  str_split("\\|") %>%
  .[1]

#リストの要素を返す
"a|b|c|d" %>%
  str_split("\\|") %>%
  .[[1]]

sentences %>%
  head(5) %>%
  str_split(" ", simplify=T)

sentences %>%
  head(5) %>%
  str_split("\\b", simplify=T)


sentences %>%
  head(5) %>%
  str_split("\\b", n=10, simplify=T)

sentences %>%
  head(5) %>%
  str_split(boundary("word"), n=20, simplify=T)

boundary("word")


#Ex.1
x <- "apples, pears, and bananas"
str_split(x, "(,| )")
str_split(x, boundary("word"))

#Ex.2
#句読点が残る

#Ex.3
str_split(x, "")


#マッチするポジションを返す
str_locate_all(x, "a")
str_locate_all(c("apple", "banana", "pear", "pineapple"), "$")
str_locate_all(c("apple", "banana", "pear", "pineapple"), c("a", "b", "e", "i"))

#指定するポジション区間の文字列を返す
hw <- "Hadley Wickham"
str_view(bananas, "banana")
str_sub(hw, 8, 14)



str_view(fruit, "nana", match=T)
str_view(fruit, regex("nana"), match=T)

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case=T))

x <- "Line 1\nLine 2\nLine 3"
cat(x)
str_extract_all(x, "^Line")
str_extract_all(x, regex("^Line", multiline=T))

phone <- regex("
               \\(?     # オプションの開き括弧
               (\\d{3}) # エリア番号
               [-) ]?  # オプションの閉じ括弧、ダッシュ、空白
               (\\d{3}) # 3桁の番号
               [ -]?    # オプションの空白かダッシュ
               (\\d{3}) # 3桁の番号
               ", comments=TRUE)

phone <- regex("\\(?(\\d{3})[-) ]?(\\d{3})[ -]?(\\d{3})")
x <- "\\(?(\\d{3})[-) ]?(\\d{3})[ -]?(\\d{3})"
cat(x)
regex(x)

y <- "[-) ]"
str_match("(514)791-8141", x)
str_match("(514)791-8141", phone)

install.packages("microbenchmark")

microbenchmark::microbenchmark(
  fixed=str_detect(sentences, fixed("the")),
  regex=str_detect(sentences, "the"),
  times=20)


a1 <- "\u00e1"
a2 <- "a\u0301"
a1 == a2

str_detect(a1, fixed(a2))
str_detect(a1, coll(a2))

install.packages("stringi")
stringi::stri_locale_info()

x <- "This is a sentence."
str_view_all(x, boundary("word"))
str_extract_all(x, boundary("word"))
str_split(x, boundary("word"))


#文字境界、文字範囲を定義する関数
?boundary


#Ex.1
x <- "ab\\de fg\\ij"
cat(x)
str_view_all(x, ".*(\\\\|.).*")
str_view_all(x, ".*")
str_view_all(x, boundary("word"))
str_view_all(x, "(\\\\*|ab)")

#regex
x_r <- "\\\\"
#fixed
x_r <- "\\"
str_view_all(x, regex(x_r))
str_view_all(x, fixed(x_r))


#Ex.2
wd <- str_to_lower(unlist(str_split(sentences, boundary("word"))))

tibble(wd) %>%
  count(wd, sort=T)


apropos("replace")

head(dir(pattern="\\.R$"))

getwd()

library(stringi)

apropos("stri_")

stri_count_words(head(sentences))
stri_duplicated(str_to_lower(unlist(str_split(sentences[1], boundary("word")))))
stri_rand_strings(4, 5)

#使用できない
st <- c("hladny", "chladny")
stri_sort(st, locale="pl_PL")
stri_sort(st, locale="sk_SK")
st <- c("n10", "n2")

stri_sort(st, opts_collator=stri_opts_collator(numeric=T))
stri_sort(st)


library(help=stringr)
vignette("stringr")


#library(tidyverse)
#library(stringr)
#library(stringi)

library()
