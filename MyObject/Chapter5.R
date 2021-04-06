
library(tidyverse)

## 変動

#離散

ggplot(diamonds) +
  geom_bar(aes(cut))

diamonds %>% count(cut)

#連続

ggplot(diamonds) +
  geom_histogram(aes(carat), binwidth=0.5)

diamonds %>% count(cut_width(carat, 0.5))


smaller <- diamonds %>%
  filter(carat < 3)

ggplot(smaller) +
  geom_histogram(aes(carat), binwidth=0.1, color="white")

ggplot(diamonds, aes(x=carat, color=cut)) +
  geom_freqpoly(binwidth=0.1)

ggplot(smaller, aes(carat)) +
  geom_histogram(binwidth=0.01)

ggplot(faithful, aes(eruptions)) +
  geom_histogram(binwidth=0.25)


#異常値

ggplot(diamonds, aes(y)) +
  geom_histogram(binwidth=0.1) +
  coord_cartesian(ylim=c(0, 50))

unusual <- diamonds %>%
  filter(y < 3 | y > 20) %>%
  select(price, x, y, z) %>%
  arrange(y)

View(unusual)



library(tidyverse)
library(devtools)
library(patchwork)
devtools::install_github("thomasp85/patchwork")

#Ex.1
#レベルの異なるzが高さ

g1 <- ggplot(diamonds, aes(x)) +
  geom_histogram(binwidth=0.05, color="white") +
  coord_cartesian(xlim=c(0, 10), ylim=c(0, 4000))

g2 <- ggplot(diamonds, aes(y)) +
  geom_histogram(binwidth=0.05, color="white") +
  coord_cartesian(xlim=c(0, 10), ylim=c(0, 4000))

g3 <- ggplot(diamonds, aes(z)) +
  geom_histogram(binwidth=0.05, color="white") +
  coord_cartesian(xlim=c(0, 10), ylim=c(0, 4000))


g1 + g2 + g3 + plot_layout(ncol=1, byrow=T)

select(diamonds, x, y, z) %>%
  summary()

#Ex.2
select(diamonds, price) %>% summary()
ggplot(diamonds, aes(price)) +
  geom_histogram(binwidth=10, color="white") +
  coord_cartesian(xlim=c(0, 2000))

#Ex.3

View(diamonds)

select(diamonds, carat) %>%
  summary()

ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth=0.01) +
  coord_cartesian(xlim=c(0, 4)) +
  scale_x_continuous(breaks=seq(0, 4, 0.5))

mutate(diamonds, car_0.99 = carat==0.99, car_1.00 = carat==1.00) %>%
  summarize(car_0.99=sum(car_0.99), car_1.00=sum(car_1.00), cnt=n())

#Ex.4
g1 <- ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth=0.01)

#指定の範囲にフォーカス  
g2 <- ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth=0.01) +
  coord_cartesian(xlim=c(0, 2))

#指定の範囲に限定
g3 <- ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth=0.01) +
  xlim(0, 2)

#指定の範囲にフォーカス
g4 <- ggplot(diamonds, aes(carat)) +
  geom_histogram() +
  coord_cartesian(xlim=c(0, 2))

#指定の範囲に限定
g5 <- ggplot(diamonds, aes(carat)) +
  geom_histogram() +
  xlim(0, 2)

install.packages("gridExtra")  
gridExtra::grid.arrange(g1, g3, g5, nrow=3)
gridExtra::grid.arrange(g1, g2, g4, nrow=3)
gridExtra::grid.arrange(g1, g2, g3, nrow=3)
gridExtra::grid.arrange(g1, g4, g5, nrow=3)


#欠損値

diamonds2 <- diamonds %>%
  mutate(y=ifelse(y<3 | y>20, NA, y)) %>%
  arrange(y)

ggplot(diamonds2, aes(x, y)) +
  geom_point()


#Ex.1

#ヒストグラムで欠損値は除外される
g1 <- ggplot(diamonds2, aes(x=y)) +
  geom_histogram(binwidth=0.2)

g2 <- diamonds2 %>% 
    count(cut_width(y, 0.2)) %>% 
    select(x=1, y=2) %>%
    ggplot(aes(x, y)) +
    geom_bar(stat="identity") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

grid.arrange(g1, g2, nrow=2)


#Ex.2
View(diamonds2)
diamonds2 %>% summarize(cnt=n(), mean=mean(y), sum=sum(y))
diamonds2 %>% summarize(cnt=n(), mean=mean(y, na.rm=T), sum=sum(y, na.rm=T))


# 共変動
ggplot(diamonds, aes(price)) +
  geom_histogram(binwidth=500)

ggplot(diamonds, aes(price)) +
  geom_freqpoly(aes(color=cut, binwidth=500))

ggplot(diamonds) +
  geom_bar(aes(cut))

ggplot(diamonds, aes(x=price, y=..density..)) +
  geom_histogram(binwidth=500)

ggplot(diamonds, aes(x=price, y=..density..)) +
  geom_freqpoly(aes(color=cut,binwidth=500))

ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot()

ggplot(mpg) +
  geom_boxplot(
    aes(x=reorder(class, hwy, FUN=median),
        y=hwy)) +
  coord_flip()


#Ex.1

#やはり3タイプに分類（出発前にキャンセル、出発後にキャンセル、運航）
# DC: 出発前にキャンセル、AC: 出発後にキャンセル
# 15時以降にキャンセルが多い

mutate(flights,
  fl=ifelse(is.na(dep_time), 'DC', ifelse(is.na(arr_time), 'AC', 'FL')),
  dep_hour=sched_dep_time %/% 100,
  dep_min=sched_dep_time %% 100,
  dep=dep_hour+dep_min/60) %>%
  ggplot(aes(x=dep, y=..density..)) +
    geom_freqpoly(aes(color=fl), binwidth=0.5)

mutate(flights,
       fl=ifelse(is.na(dep_time), 'DC', ifelse(is.na(arr_time), 'AC', 'FL')),
       dep_hour=sched_dep_time %/% 100,
       dep_min=sched_dep_time %% 100,
       dep=dep_hour+dep_min/60) %>%
  ggplot(aes(x=fl, y=dep)) +
  geom_boxplot()

mutate(flights,
       fl=ifelse(is.na(dep_time), 'DC', ifelse(is.na(arr_time), 'AC', 'FL')),
       dep_hour=sched_dep_time %/% 100,
       dep_min=sched_dep_time %% 100,
       dep=dep_hour+dep_min/60) %>%
  ggplot(aes(x=fl, y=dep)) +
  geom_boxplot()


#Ex.2

#品質の劣るカットに価格の高い高カラットのダイヤが多い

ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()

ggplot(diamonds, aes(cut, carat)) +
  geom_boxplot()

ggplot(diamonds) +
  geom_point(aes(x=carat, y=price, color=cut))


#Ex.3

# clarity: a measurement of how clear the diamond
#   I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best)
# Clarityに関しても、透明性が低いほどカラットの大きなダイヤが多い

library(devtools)
devtools::install_github("lionel-/ggstance")

ggplot(diamonds, aes(x=clarity, y=price)) +
  geom_boxplot()

g1 <- ggplot(diamonds, aes(x=clarity, y=carat)) +
  geom_boxplot() +
  coord_flip()

g2 <- ggplot(diamonds) +
  geom_boxploth(aes(x=carat, y=clarity))
  
library(gridExtra)
grid.arrange(g1, g2, ncol=1)


#Ex.4

install.packages("lvplot")
library(lvplot)

g1 <- ggplot(diamonds) +
  geom_boxplot(aes(x=cut, y=price))

g2 <- ggplot(diamonds) +
  geom_lv(aes(x=cut, y=price))

grid.arrange(g1, g2, ncol=1)


#Ex.5
#バイオリンプロットの情報量が多い

g1 <- ggplot(diamonds) +
  geom_violin(aes(x=cut, y=price))

g2 <- ggplot(diamonds, aes(x=price, y=..density..)) +
  geom_histogram(aes(fill=cut), position="dodge")

g3 <- ggplot(diamonds, aes(x=price, y=..density..)) +
  geom_freqpoly(aes(color=cut))

grid.arrange(g1, g2, g3, ncol=1)


#Ex.6

#caratが高いほど、cutやclarityの質が高いほど、priceは高い

#これも分かり易い
ggplot(diamonds) +
  geom_point(aes(x=carat, y=price, color=cut))

#これが最も分かり易い
ggplot(diamonds) +
  geom_point(aes(x=carat, y=price, color=clarity))

#点をずらして表示し、データの頻度をイメージし易くしている
ggplot(diamonds) +
  geom_jitter(aes(x=cut, y=price, color=clarity))

grid.arrange(g1, g2, ncol=1)


#clarityとcutの関係を見たい
#正の関係があるように見える

ggplot(diamonds) +
  geom_bar(aes(x=clarity, y=..prop.., group=1)) +
  facet_wrap(~cut, nrow=2)

ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group=1)) +
  facet_wrap(~clarity, nrow=2) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  


#２つのカテゴリ変数
ggplot(diamonds) +
  geom_count(aes(cut, color))

ggplot(diamonds) +
  geom_count(aes(cut, clarity))


diamonds %>%
  count(color, cut) %>%
  ggplot(aes(color, cut)) +
    geom_tile(aes(fill=n))


#Ex.1
#colorとカットについて
#比率に換算

#カラー別のcutの割合
diamonds %>% 
  group_by(color) %>%
  mutate(sum_color=n()) %>%
  group_by(color, cut) %>%
  summarize(ratio=sum(1/sum_color)) %>%
  ggplot(aes(color, cut)) +
    geom_tile(aes(fill=ratio))
  
#カラー別のcutの割合
diamonds %>% 
  group_by(cut) %>%
  mutate(sum_cut=n()) %>%
  group_by(cut, color) %>%
  summarize(ratio=sum(1/sum_cut)) %>%
  ggplot(aes(cut, color)) +
  geom_tile(aes(fill=ratio))
  


#Ex.2
flights
#arr_delayを集計対象
flights %>% 
  filter(!is.na(arr_delay)) %>%
  mutate(month=as.factor(month)) %>%
  group_by(dest, month) %>%
  summarize(delay=mean(arr_delay)) %>%
  ggplot(aes(dest, month)) +
    geom_tile(aes(fill=delay)) +
    theme(axis.text.x = element_text(size=5, angle=90, hjust=1))  

#Ex.3
#x軸にカテゴリ数が多い変数をとると見やすいらしい

#見にくいとされる
g1 <- diamonds %>%
  count(cut, color) %>%
  ggplot(aes(cut, color)) +
  geom_tile(aes(fill=n))

#見やすいとされる
g2 <- diamonds %>%
  count(color, cut) %>%
  ggplot(aes(color, cut)) +
  geom_tile(aes(fill=n))

grid.arrange(g1, g2, ncol=2)


# 連続変数同士

ggplot(diamonds) +
  geom_point(aes(x=carat, y=price), alpha=0.1)

ggplot(smaller) +
  geom_bin2d(aes(x=carat, y=price))

install.packages("hexbin")
library(hexbin)

ggplot(smaller) +
  geom_hex(aes(x=carat, y=price))

ggplot(smaller, aes(carat, price)) +
  geom_boxplot(aes(group=cut_width(carat, 0.1)))

ggplot(smaller, aes(carat, price)) +
  geom_boxplot(aes(group=cut_number(carat, 20)))


#Ex.1
#carat, price
#1カラット刻み
ggplot(diamonds, aes(x=price)) +
  geom_freqpoly(aes(color=cut_width(carat, 1)))
  
#同じサンプル数に5等分
ggplot(diamonds, aes(x=price)) +
  geom_freqpoly(aes(color=cut_number(carat, 5)))

#Ex.2
#価格が高いほど高カラットに分布
ggplot(diamonds, aes(x=carat)) +
  geom_freqpoly(aes(color=cut_width(price, 5000)))

#価格が高いほど高カラットに分布
ggplot(diamonds, aes(x=carat)) +
  geom_boxplot(aes(group=cut_width(price, 5000)))

#Ex.3
mutate(diamonds, cap=x*y*z) %>%
  filter(cap < 1000) %>%
  ggplot(aes(x=price)) +
    geom_boxplot(aes(group=cut_number(cap, 5))) 

mutate(diamonds, cap=x*y*z) %>%
  filter(cap < 1000) %>%
  ggplot(aes(x=price)) +
    geom_freqpoly(aes(color=cut_width(cap, 100)))


#Ex.4
#cut, carat, price

#caratの影響を中立化して、cutとpriceの関係
ggplot(diamonds, aes(x=cut, y=price)) +
  geom_boxplot(aes(group=cut_number(carat, 10)))
               
ggplot(diamonds, aes(y=price)) +
  geom_boxplot(aes(group=cut_number(carat, 10)))

ggplot(diamonds) +
  geom_boxplot(aes(x=cut, y=price)) +
  facet_wrap(~cut_number(carat, 5), nrow=1)


ggplot(diamonds) +
  geom_boxplot(aes(x=cut, y=price)) +
  facet_wrap(cut_number(carat, 5)~clarity, nrow=3)

#Ex.5
ggplot(diamonds) +
  geom_point(aes(x, y)) +
  coord_cartesian(xlim=c(4, 11), ylim=c(4, 11))

ggplot(diamonds) +
  geom_boxplot(aes(x))

ggplot(diamonds) +
  geom_boxplot(aes(y))

ggplot(diamonds) +
  geom_point(aes(x, y))

ggplot(diamonds) +
    geom_bin2d(aes(x=x, y=y))

ggplot(diamonds) +
  geom_hex(aes(x=x, y=y))



ggplot(diamonds) +
  geom_bar(aes(x=cut))

ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..count..))

#group=1はデータ全体を表し、propはデータ全体を対象に計算される
ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group=1))

ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group=1, fill='clarity'), position="dodge")


ggplot(diamonds, aes(x=cut, y=..prop.., group=1)) +
  geom_bar(aes(fill='clarity'), position="dodge")


# パターンとモデル

ggplot(faithful) +
  geom_point(aes(eruptions, waiting))



library(modelr)

mod <- lm(log(price)~log(carat), data=diamonds)
diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid=exp(resid))

ggplot(diamonds2) +
  geom_point(aes(carat, resid))

ggplot(diamonds2) +
  geom_boxplot(aes(x=cut, y=resid))


ggplot(faithful, aes(eruptions)) +
  geom_freqpoly(binwidth=0.25)


diamonds %>%
  count(cut, clarity) %>%
  ggplot(aes(clarity, cut, fill=n)) +
    geom_tile()




library(tidyverse)
