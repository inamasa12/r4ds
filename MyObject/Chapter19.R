
#モデルを使用したデータの理解

diamonds

#一次元分布
#品質に劣るほど価格（中央値）が高いように見える
ggplot(diamonds, aes(cut, price)) + geom_boxplot()
ggplot(diamonds, aes(color, price)) + geom_boxplot()  
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()  

#二次元分布
#カラットが価格に与える影響が大きい
ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins=50)

#異常値カット、線形変換（対数化、底を２とする）
diamonds_mod <- diamonds %>%
  filter(carat <= 2.5) %>%
  mutate(lprice=log2(price), lcarat=log2(carat))

log2(4)

#二次元分布
ggplot(diamonds_mod, aes(lcarat, lprice)) +
  geom_hex(bins=50)

#線形モデルを推定
model_diamond <- lm(lprice~lcarat, data=diamonds_mod)

#20ポイントのグリッドに対して線形モデルの予測値を算出（列名lprice）
grid <- diamonds_mod %>%
  data_grid(carat=seq_range(carat, 20)) %>%
  mutate(lcarat=log2(carat)) %>%
  add_predictions(model_diamond, "lprice") %>%
  mutate(price=2^lprice)

#予測価格を併せて表示
ggplot(diamonds_mod, aes(carat, price)) +
  geom_hex(bins=50) +
  geom_line(data=grid, color="red", size=1)

#残差を算出
diamonds_mod <- diamonds_mod %>%
  add_residuals(model_diamond, "lresid")

diamonds_mod <- diamonds_mod %>%
  mutate(resid=2^lresid)

ggplot(diamonds_mod, aes(lcarat, lresid)) +
  geom_hex(bins=50)


#価格残差と各変数の関係
#品質と価格残差に正の関係が確認できる

ggplot(diamonds_mod, aes(cut, lresid)) + geom_boxplot()
ggplot(diamonds_mod, aes(cut, resid)) + geom_boxplot()

ggplot(diamonds_mod, aes(color, lresid)) + geom_boxplot()
ggplot(diamonds_mod, aes(color, resid)) + geom_boxplot()

ggplot(diamonds_mod, aes(clarity, lresid)) + geom_boxplot()
ggplot(diamonds_mod, aes(clarity, resid)) + geom_boxplot()


#モデルの拡張

#線形モデルを推定
rmodel_diamond <- lm(lprice~lcarat+color+cut+clarity, data=diamonds_mod)

#グリッドに対して線形モデルの予測値を算出
#.modelは指定していない説明変数について、代表値（中央値）をグリッドとする
grid <- diamonds_mod %>%
  data_grid(cut, .model=rmodel_diamond) %>%
  add_predictions(rmodel_diamond)

#cutに応じた予想価格の推移
ggplot(grid, aes(cut, pred)) +
  geom_point()

#新モデルによる残差を算出、表示
diamonds_mod <- diamonds_mod %>%
  add_residuals(rmodel_diamond, "lresid2")

ggplot(diamonds_mod, aes(lcarat, lresid2)) +
  geom_hex(bins=50)

#異常値の確認、実際の価格と予想価格の比較
diamonds_mod %>%
  filter(abs(lresid2) > 1) %>%
  add_predictions(rmodel_diamond) %>%
  mutate(pred=round(2^pred)) %>%
  select(price, pred, carat:table, x:z) %>%
  arrange(price)


#Ex.1
#特定のカラットの値にダイヤが集中している
ggplot(diamonds_mod, aes(lcarat, lprice)) +
  geom_hex(bins=50)

ggplot(diamonds_mod, aes(lcarat)) +
  geom_histogram()

#Ex.2
#caratに対するpriceの弾性を表す
#caratの変化率に対するpriceの変化率の関係


#Ex.3
#残差が最大
diamonds_mod %>%
  filter(lresid2==max(diamonds_mod$lresid2)) %>%
  add_predictions(rmodel_diamond) %>%
  mutate(pred=round(2^pred)) %>%
  select(price, pred, carat, color, clarity, depth, table, lresid2)

chk2 <- diamonds_mod %>%
  filter(carat==0.34)

View(chk2)

#同じ色、透明度、カットで揃える
chk <- diamonds_mod %>%
  filter(color=='F', clarity=='I1', cut=='Fair') %>%
  arrange(desc(lresid2))

#caratに比してpriceが異常に高いのは明らか
#caratが得に小さいダイヤではある、z（高さ）がない
ggplot(chk, aes(lcarat, lprice)) +
  geom_point() +
  geom_point(
    data=filter(chk, lresid2 > 1),
    size=2,
    color="red"
  )

#データエラーとは言えない
#割高なダイヤと言える
ggplot(chk, aes(carat, table)) +
  geom_point() +
  geom_point(
    data=filter(chk, lresid2>1),
    size=2,
    color="red"
  )

#cut及びclarityが間違って低いものが記録されているのかもしれない


#残差が最小
diamonds_mod %>%
  filter(lresid2==min(diamonds_mod$lresid2)) %>%
  add_predictions(rmodel_diamond) %>%
  mutate(pred=round(2^pred)) %>%
  select(price, pred, carat, color, clarity, cut, depth, table, lresid2)


chk2 <- diamonds_mod %>%
  filter(carat>=2.3)

View(chk2)

#同じ色、透明度、カットで揃える
chk <- diamonds_mod %>%
  filter(color=='E', clarity=='SI2', cut=='Premium') %>%
  arrange(lresid2) %>%
  select(price, carat, color, clarity, cut, depth, table, lresid2)

#caratに比してpriceが異常に低いのは明らか
#caratが得に大きいダイヤではある、z（高さ）がない
ggplot(chk, aes(lcarat, lprice)) +
  geom_point() +
  geom_point(
    data=filter(chk, lresid2 < -1),
    size=2,
    color="red"
  )

#データエラーとは言えない
#割安なダイヤと言える
ggplot(chk, aes(carat, depth)) +
  geom_point() +
  geom_point(
    data=filter(chk, lresid2 < -1),
    size=2,
    color="red"
  )


ggplot(chk, aes(carat, price)) +
  geom_point() +
  geom_point(
    data=filter(chk, lresid2 < -1),
    size=2,
    color="red"
  )


#Ex.4
#rmodelは予測に優れる
ggplot(diamonds_mod) +
  geom_point(aes(lcarat, lresid), color="blue", alpha=0.5) +
  geom_point(aes(lcarat, lresid2), color="red", alpha=0.5)

sum(diamonds_mod$lresid^2)
sum(diamonds_mod$lresid2^2)


#フライトデータ

#日次時系列フライト数
daily <- flights %>%
  mutate(date=make_date(year, month, day)) %>%
  group_by(date) %>%
  summarize(n=n())

#曜日効果がある
ggplot(daily, aes(date, n)) +
  geom_line()

#曜日データの確認
daily <- daily %>%
  mutate(wday=wday(date, label=T))

#土曜日のフライト数が少ない
ggplot(daily, aes(wday, n)) +
  geom_boxplot()

#曜日でフライト数を説明するモデル
mod <- lm(n~wday, data=daily)

#全グリッドについて予測
grid <- daily %>%
  data_grid(wday) %>%
  add_predictions(mod, "n")

#予測値、曜日毎の平均値
ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data=grid, color="red", size=4)

#残差の算出
daily <- daily %>%
  add_residuals(mod)

#残差の表示
daily %>% ggplot(aes(date, resid)) +
  geom_ref_line(h=0) +
  geom_line()

#曜日別の残差推移⇒土曜日が特殊
ggplot(daily, aes(date, resid, color=wday)) +
  geom_ref_line(h=0) +
  geom_line()

#極端に少ない日  
daily %>%
  filter(resid < -100)

#年間を通じての変動
daily %>%
  ggplot(aes(date, resid)) +
  geom_ref_line(h=0) +
  geom_line(color="grey50") +
  geom_smooth(se=F, span=0.2)

#土曜日の季節性を確認
daily %>%
  filter(wday=="土") %>%
  ggplot(aes(date, n)) +
  geom_point() +
  geom_line() +
  scale_x_date(
    NULL,
    date_breaks="1 months",
    date_labels="%b"
  )

#季節区分の関数
term <- function(date) {
  cut(date,
      breaks=ymd(20130101, 20130605, 20130825, 20140101),
      labels=c("spring", "summer", "fall"))
}


#季節区分
daily <- daily %>%
  mutate(term=term(date))

#区分ごとに表示

daily %>%
  filter(wday=="土") %>%
  ggplot(aes(date, n, color=term)) +
  geom_point(alpha=1/3) +
  geom_line() +
  scale_x_date(
    NULL, #凡例は表示しない
    date_breaks="1 months",
    date_labels="%B"
  )


#区分ごとの箱ひげ図
daily %>%
  ggplot(aes(wday, n, color=term)) +
  geom_boxplot()

#区分を考慮したモデル（交互作用効果あり）  
mod1 <- lm(n~wday, data=daily)
mod2 <- lm(n~wday*term, data=daily)

#夏の上振れがなくなる
daily %>%
  gather_residuals(without_term=mod1, with_term=mod2) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_line(alpha=0.75)

#区分考慮モデルでグリッド値に対して予想
grid <- daily %>%
  data_grid(wday, term) %>%
  add_predictions(mod2, "n")

#外れ値の影響を確認
ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data=grid, color="red") +
  facet_wrap(~term)

#外れ値に頑健なモデル
mod3 <- MASS::rlm(n~wday*term, data=daily)

#残差の列名が既にある場合は上書きする
daily %>% 
  add_residuals(mod3, "resid") %>%
  ggplot(aes(date, resid)) +
  geom_hline(yintercept=0, size=2, color="white") +
  geom_line()



#関数化
#区分と曜日列の付与
compute_vars <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T)
    )
}

#曜日を返す
wday2 <- function(x) wday(x, label=T)

#曜日と区分で便数を説明するモデル（交互作用あり）
mod3 <- lm(n~wday2(date)*term(date), data=daily)

compute_vars(daily)

wday2(daily$date)
term(daily$date)

mod3 <- lm(n~wday2(date)*term(date), data=daily)



#日次時系列フライト数
daily <- flights %>%
  mutate(date=make_date(year, month, day)) %>%
  group_by(date) %>%
  summarize(n=n())


dl <- compute_vars(daily)
mod <- MASS::rlm(n~wday*ns(date,5), data=dl)

dl %>%
  data_grid(wday, date=seq_range(date, n=13)) %>%
  add_predictions(mod) %>%
  ggplot(aes(date, pred, color=wday)) +
  geom_line() +
  geom_point()


seq_range(daily$date, n=13)


#Ex.1
#恐らく祝日の前日
timeDate::holiday(2013, "NewYearsDay")
tis::holidays(2013)
max(daily$date)

compute_vars2 <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T),
      hld=as.integer(date %in% (lubridate::ymd(holidays(c(year(date),year(date)+1))) - ddays(1)))
    )
}


#Ex.2

dl2 <- compute_vars2(daily)

dl2 %>%
  filter(date=="2013-01-20")

#モデルの推定
mod1 <- lm(n~wday, data=dl2)
mod2 <- lm(n~wday*term, data=dl2)
mod4 <- lm(n~wday*term*hld, data=dl2)

#各モデルの残差プロット
dl2 %>%
  gather_residuals(without_term=mod1, with_term=mod2, with_hol=mod4) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_line(alpha=0.75, size=0.5) +
  geom_point()

#各モデルの二乗平方和
dl2 %>%
  gather_residuals(without_term=mod1, with_term=mod2, with_hol=mod4) %>%
  group_by(model) %>%
  summarize(ser=sum(resid^2))
  

#Ex.3
#感謝祭の反動でその週末は便数増える
#年末の最後の土曜は便数が増える

dl2 %>%
  add_residuals(mod1, "resid") %>%
  top_n(5, resid) %>%
  arrange(desc(resid))


#special day
#wday: 土曜は7

#tidyverse, modelr, timeDate, lubridate, nycflights13を前提

term <- function(date) {
  cut(date,
      breaks=ymd(20130101, 20130605, 20130825, 20140101),
      labels=c("spring", "summer", "fall"))
}

ymd(daily$date[1])
spday(daily$date[1])

spday <- function(date){
  date <- daily$date[1]
  y <- year(date)
  #最後の土曜
  days <- seq(make_date(y,12,25), make_date(y,12,31), by="day")
  wdays <- wday(days)
  lsut <- days[wdays==7]
  #感謝祭明けの週末
  days <- seq(ymd(holiday(y, "USThanksgivingDay")), by="day", length.out=7)
  wdays <- wday(days)
  estwe1 <- days[wdays==7]
  estwe2 <- days[wdays==1]
  sdays <- c(lsut, estwe1, estwe2)
  as.integer(date %in% sdays)  
}

compute_vars3 <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T),
      hld=as.integer(date %in% (ymd(tis::holidays(c(year(date),year(date)+1))) - ddays(1))),
      spd=map_int(date, spday)
    )
}


dl3 <- compute_vars3(daily)
View(dl3)

dl3 %>% filter(spd==1)


#Ex.3
compute_vars4 <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T),
      wday_e=as.character(fct_recode(wday, Sun="日",
                                            Mon="月",
                                            Tue="火",
                                            Wed="水",
                                            Thr="木",
                                            Fri="金",
                                            Sat="土")),
      sterm=as.factor(ifelse(wday_e=="Sat", str_c(as.character(term), wday_e, sep="_"), wday_e))
    )
}

#case_when関数を用いても良い


dl4 <- compute_vars4(daily)

View(dl4)
str(dl4)
head(dl4)

mod2_4 <- lm(n~wday*term, data=dl4)
mod4_4 <- lm(n~sterm, data=dl4)

#各モデルの残差プロット
dl4 %>%
  gather_residuals(mod2=mod2_4, mod4=mod4_4) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_line(alpha=0.75, size=0.5) +
  geom_point()

#各モデルの二乗平方和
dl4 %>%
  gather_residuals(mod2=mod2_4, mod4=mod4_4) %>%
  group_by(model) %>%
  summarize(ser=sum(resid^2))

#wdayとtermの交差項モデルが上回る


#Ex.4
compute_vars5 <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T),
      wday_e=as.character(fct_recode(wday, Sun="日",
                                     Mon="月",
                                     Tue="火",
                                     Wed="水",
                                     Thr="木",
                                     Fri="金",
                                     Sat="土")),
      spd=map_int(date, spday),
      wday2=as.factor(ifelse(spd, "spd"
                            , ifelse(wday_e=="Sat", str_c(as.character(term), wday_e, sep="_"), wday_e))),
      hld=as.integer(date %in% (ymd(tis::holidays(c(year(date),year(date)+1))) - ddays(1))),
      wday3=as.factor(ifelse(hld, "hld"
                             , ifelse(wday_e=="Sat", str_c(as.character(term), wday_e, sep="_"), wday_e))),
      month=month(daily$date)
    )
}

month(daily$date)


dl5 <- compute_vars5(daily)
View(dl5)
str(dl5)
levels(dl5$wday3)

mod2 <- lm(n~wday*term, data=dl5)
mod5 <- lm(n~wday2, data=dl5)
mod6 <- lm(n~wday3, data=dl5)

#各モデルの残差プロット
dl5 %>%
  gather_residuals(mod2=mod2, mod5=mod5, mod6=mod6) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_line(alpha=0.75, size=0.5) +
  geom_point()

#各モデルの二乗平方和
dl5 %>%
  gather_residuals(mod2=mod2, mod5=mod5, mod6=mod6) %>%
  group_by(model) %>%
  summarize(ser=sum(resid^2))

#やはり交差項ありには劣るが特別日や祝日を考慮することで交差項モデルに精度が近づく


#Ex.5
#変数生成関数
compute_Ex5 <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T),
      wday_e=as.character(fct_recode(wday, Sun="日",
                                     Mon="月",
                                     Tue="火",
                                     Wed="水",
                                     Thr="木",
                                     Fri="金",
                                     Sat="土")),
      month=as.factor(month(daily$date))
    )
}

#変数算出
dt.Ex5 <- compute_Ex5(daily)
str(dt.Ex5)

#モデル算出
mod5_1 <- lm(n~wday*term, data=dt.Ex5)
mod5_2 <- lm(n~wday*month, data=dt.Ex5)

#各モデルの残差プロット
dt.Ex5 %>%
  gather_residuals(mod1=mod5_1, mod2=mod5_2) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_point() +
  geom_hline(yintercept=0)


#各モデルの二乗平方和
dt.Ex5 %>%
  gather_residuals(mod1=mod5_1, mod2=mod5_2) %>%
  group_by(model) %>%
  summarize(ser=sum(resid^2))

summary(mod5_1)
summary(mod5_2)


#役に立っているように見えるが
#自由度が低いか

#Ex.6
#スプライン関数を適用する
head(daily)
mod6_1 <- lm(n~wday*ns(date, 5), data=dt.Ex5)
mod6_2 <- lm(n~wday+ns(date, 5), data=dt.Ex5)


#各モデルの残差プロット
dt.Ex5 %>%
  gather_residuals(mod1=mod6_1, mod2=mod6_2) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_point(alpha=0.3) +
  geom_hline(yintercept=0)

#各モデルの二乗平方和
dt.Ex5 %>%
  gather_residuals(mod1=mod6_1, mod2=mod6_2) %>%
  group_by(model) %>%
  summarize(ser=sum(resid^2))

#Ex.7
#日曜の午後は飛距離の長い便が多い、という仮説

compute_Ex7 <- function(data){
  data %>%
    mutate(
      term=term(date),
      wday=wday(date, label=T),
      wday_e=as.factor(fct_recode(wday, Sun="日",
                              Mon="月",
                              Tue="火",
                              Wed="水",
                              Thr="木",
                              Fri="金",
                              Sat="土")),
      dh=as.factor(ifelse(hour<12, "a.m", "p.m"))
    )
}

dist <- flights %>%
  mutate(date=make_date(year, month, day)) %>%
  select(date, hour, distance)

dist_v <- compute_Ex7(dist)
str(dist_v)

mod7_1 <- lm(distance~wday_e*dh, dist_v)
mod7_2 <- lm(distance~wday_e+dh, dist_v)
summary(mod7_1)

dist_v %>%
  group_by(wday_e, dh) %>%
  summarize(avg=mean(distance))


#L, Q, C, 4, 5, 6の順


#平均的に日曜午後便の飛行距離は決して長くはない
#但し、元々、日曜や午後の飛行距離は短いため、その割に飛行距離は長いと言える

dist_v %>% 
  mutate(var=str_c(wday_e, dh, sep="_")) %>%
  ggplot(aes(distance)) +
  geom_histogram(aes(y=..density..), binwidth = 40) +
  facet_grid(dh ~ wday_e)
  

dist_v %>% 
  mutate(var=str_c(wday_e, dh, sep="_")) %>%
  ggplot(aes(var, distance)) +
  geom_boxplot()

dist_v %>% 
  mutate(var=str_c(wday_e, dh, sep="_")) %>%
  group_by(var) %>%
  summarize(dis_avg=mean(distance), dis_med=median(distance))
  


#Ex.8
dist_v %>% 
  ggplot(aes(fct_relevel(wday_e, "Sun", after=Inf), distance)) +
  geom_boxplot()









#ロケール、OSで異なる
#Japanese_Japan.932、言語＋領域＋文字コード（Shift-JIS）
#デフォルト設定: Sys.setlocale(locale="Japanese_Japan.932")
#Sys.setlocale("LC_ALL", 'English_Japan.932')
#Sys.setlocale("LC_ALL", 'Japanese_Japan.932')







Sys.timezone()
Sys.getlocale()

options()





library(tidyverse)
library(modelr)
library(nycflights13)
library(lubridate)
library(timeDate)
library(stringr)

library(splines)
library(tis)
