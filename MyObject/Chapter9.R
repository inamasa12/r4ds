
library(tidyverse)

table1
table2
table3
table4a
table4b

table1 %>% mutate(rate=cases / population * 10000)
table1 %>% count(year, wt=cases)

library(ggplot2)
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group=country), color="grey50") +
  geom_point(aes(color=country))


#Ex.1

#Ex.2

table2 %>% 
  mutate(cases=ifelse(type=='cases', count, 0),
         poputation=ifelse(type=='population', count, 0)) %>%
  group_by(country, year) %>%
  summarize(cases=sum(cases),
            population=sum(poputation),
            rate=sum(cases)/sum(poputation))


inner_join(table4a, table4b, by=c('country')) %>%
  select(country, `1999`=`1999.x`/`1999.y`)
  
inner_join(table4a, table4b, by=c('country')) %>%
  rename(cases_99=`1999.x`, cases_00=`2000.x`, pops_99=`1999.y`, pops_00=`2000.y`) %>%
  mutate(rate_99=cases_99/pops_99, rate_00=cases_00/pops_00)

#Ex.4
table2 %>%
  mutate(cases=ifelse(type=="cases", count, 0), population=ifelse(type=="population", count, 0)) %>%
  group_by(country, year) %>%
  summarize(rate=sum(cases)/sum(population)) %>%
  ggplot(aes(x=year, y=rate)) +
  geom_line(aes(color=country))


#複数の列を集めて、一つの列にまとめる
tidy4a <- table4a %>%
  gather(`1999`, `2000`, key="year", value="cases")

tidy4b <- table4b %>%
  gather(`1999`, `2000`, key="year", value="population")

left_join(tidy4a, tidy4b)


#一つの列を複数の列に分散させる
table2 %>% spread(key=type, value=count)


library(tidyverse)

#Ex.1
#year列の型情報がspreadした（列名にした）段階で失われる
stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17))

stocks %>%
  spread(key=year, value=return) %>%
  gather("year", "return", `2015`:`2016`)

st <- stocks %>%
  spread(key=year, value=return)

st %>% gather(`2015`, `2016`, key="year", value="return")
?gather #povot_longerにリニューアルされている


#Ex.2
#数字そのままを列名として認識しない
table4a %>%
  gather(`1999`, `2000`, key="year", value="cases")

#Ex.3
people <- tribble(
  ~name, ~key, ~value,
  "Phillip Woods","age", 45,
  "Phillip Woods","height", 186,
  "Phillip Woods","age", 50,
  "Jessica Cordero","age", 37,
  "Jessica Cordero","height", 156
)

#展開後の各行が一意である必要がある
people %>%
  group_by(name, key) %>%
  mutate(id = row_number()) %>%
  spread(key=key, value=value)

#Ex.4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes", NA, 10,
  "no", 20, 12
)


preg %>%
  gather("male", "female", key="sex", value="cases") %>%
  spread(key=pregnant, value=cases)


table3 %>%
  separate(rate, into=c("cases", "population"), convert=T)


table3 %>%
  separate(year, into=c("century", "year"), sep=-1)

table3 %>%
  separate(year, into=c("a", "b", "c"), sep=c(1, 2))


#Ex1
#extra: 余りが出た時の処理
tibble(x=c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), fill="merge")

#fill: 足らないときの処理
tibble(x=c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill="right")

#Ex2
#remove: 元の列を残さない
table3 %>%
  separate(rate, into=c("cases", "population"), remove=T)

table1 %>%
  unite(rate, cases, population, sep="/", remove=F)

#Ex3
#extractは分割に用いる記号を正規表現で表す
?extract

df <- data.frame(x = c(NA, "a-b", "a-d", "b-c", "d-e"))
df %>% extract(x, "A")
df %>% extract(x, c("A", "B"), "([[:alnum:]]+)-([[:alnum:]]+)")

library(tidyverse)
?separate
?extract

stocks <- tibble(
  year=c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr=c(1, 2, 3, 4, 2, 3, 4),
  return=c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)

stocks %>%
  spread(key=year, value=return)

stocks %>%
  spread(key=year, value=return) %>%
  gather(`2015`, `2016`, key="year", value="return", na.rm=T)

stocks %>%
  complete(year, qtr)

stocks %>% fill(return)

c(1:2, 1)

#Ex.1
ともに補完に用いる値を指摘できる


#Ex.2
?fill
#.direction: 前後どちらの数値で補完するかを指定


#Case Study

who
View(who5)

#一旦リスト形式にまとめる
who %>%
  gather(new_sp_m014:newrel_f65, key="key", value="cases", na.rm=T) %>%
  mutate(key=stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "type", "sexage"), sep="_") %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep=1)




who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key="key",
         value="cases",
         na.rm=T)

#変数の確認
who_cnt <- who1 %>% count(key)


#変数名を統一する
who2 <- who1 %>%
  mutate(key=stringr::str_replace(key, "newrel", "new_rel"))

#文字列変数を分ける、細かくグルーピングできるように
who3 <- who2 %>%
  separate(key, c("new", "type", "sexage"), sep="_")

#不要な情報（列）を落とす
who3 %>% count(new)

who4 <- who3 %>%
  select(-new, -iso2, -iso3)

who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep=1)





#Ex1

#完全にない: 国として存在しない
#NA: 統計がない
#0: 症例がない
#NAは暗黙的欠損値である

View(who_chk3)
who_chk1 <- who %>%
  gather(new_sp_m014:newrel_f65, key="key",
         value="cases",
         na.rm=T) %>%
  count(country)

who_chk2 <- who %>%
  gather(new_sp_m014:newrel_f65, key="key",
         value="cases",
         na.rm=F) %>%
  count(country)

who_chk3 <- who %>% filter(country=="Serbia")

who_chk3 <- who %>% 
  group_by(year) %>%
  summarize(cnt=n())

#Ex.2
#separate時に不具合が生じる


#Ex.3
View(who_chk4)
who %>% 
  group_by(country) %>%
  summarize(cnt=n(), cnt_iso2=n_distinct(iso2), cnt_iso3=n_distinct(iso3)) %>%
  filter(cnt_iso2>1 | cnt_iso3>1)

#Ex.4
library(tidyverse)
who5_JP <- who5 %>% filter(country=="Japan")
View(who5_JP)

who5_JP %>% 
  group_by(year, type) %>%
  summarize(cases=sum(cases)) %>%
  spread(key=type, value=cases)

who5_JP %>%
  filter(type=="rel")

who5 %>%
  filter(type=="sp") %>%
  group_by(country, year, sex) %>%
  summarize(cases=sum(cases)) %>%
  ggplot() +
  geom_line(aes(x=year, y=cases, color=country)) +
  facet_wrap(~sex, ncol=1)



who5 %>%
  filter(type=="sp") %>%
  group_by(country) %>%
  summarize(sum_cases=sum(cases)) %>%
  arrange(desc(sum_cases))

who5 %>%
  filter(type=="sp", country %in% c("India", "China", "Indonesia", "South Africa", "Bangladesh")) %>%
  group_by(country, year, sex) %>%
  summarize(cases=sum(cases)) %>%
  ggplot() +
  geom_line(aes(x=year, y=cases, color=country)) +
  facet_wrap(~sex, ncol=1)

