
#dplyr

install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

#飛行機の運行記録
flights
View(flights)

#filter

filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 12, day == 25))
filter(flights, month == 11 | month == 12)
(nov_dec <- filter(flights, month %in% c(11, 12)))
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, (arr_delay <= 120 & dep_delay <= 120))

#Ex.1
#a
ans <- filter(flights, arr_delay >= 120)
#b
ans <- filter(flights, dest == 'IAH' | dest == 'HOU')
#c
ans <- filter(flights, carrier %in% c('UN', 'AA', 'DL'))
#d
ans <- filter(flights, month >= 7 & month <= 9)
#e
ans <- filter(flights, dep_delay <= 0 & arr_delay > 120)
#f
ans <- filter(flights, arr_delay > 60 & dep_delay - arr_delay > 30)
#g
ans <- filter(flights, dep_time <= 600 | dep_time == 2400)

#Ex.2
ans <- filter(flights, between(month, 7, 9))

#Ex.3
#欠航
#dep_time, dep_delay, arr_time, arr_delay, air_time
#tailnum
ans <- filter(flights, is.na(dep_time))

#Ex.4
NA ^ 0


#arrange

arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))

#Ex.1
ans <- arrange(flights, desc(is.na(dep_time)))

#Ex.2
ans <- arrange(flights, desc(arr_delay))
ans <- arrange(flights, dep_time)

#Ex.3
ans <- arrange(flights, desc(distance / (hour + minute / 60)))

#Ex.4
ans <- arrange(flights, desc(distance))


# select
# 列の選択

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

#Ex.1
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with('dep_'), starts_with('arr_'))

#Ex.2
#一列しか抽出しない
select(flights, year, year)

#Ex.3
vars <- c('year', 'month', 'day', 'dep_delay', 'arr_delay')
select(flights, one_of(vars))
#結果は同じだが警告が出る
select(flights, vars)

#Ex.4
#大文字と小文字の違いは無視される
ans <- select(flights, contains('TIME'))

# mutate

flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

transmute(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)


#Ex.1
ans <- mutate(flights, 
              dep_min=dep_time %/% 100 * 60 + dep_time %% 100,
              sched_dep_min=sched_dep_time %/% 100 * 60 + sched_dep_time %% 100)

#Ex.2
#一致しない
ans <- mutate(flights, air_time2=arr_time-dep_time)
select(flights, dep_time, arr_time, air_time) %>%
  mutate(air_time2=arr_time-dep_time)


#Ex.3
select(flights, dep_time, sched_dep_time, dep_delay) %>%
  mutate(calc_delay=
           (dep_time %/% 100 * 60 + dep_time %% 100) - (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100))

#Ex.4
ans <-select(flights, tailnum, arr_delay) %>%
          mutate(delay_rank=min_rank(desc(arr_delay))) %>%
          arrange(desc(arr_delay))

#Ex.5
#Recycling
1:3 + 1:10
1:2 + 1:10

#Ex.6
sin()
cos()
tan()


# グループ毎の要約
# summarize
summarize(flights, delay=mean(dep_delay, na.rm=T))

by_day <-group_by(flights, year, month, day)
summarize(by_day, delay=mean(dep_delay, na.rm=T))

# pipe
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest,
                   count=n(),
                   dist=mean(distance, na.rm=T),
                   delay=mean(arr_delay, na.rm=T))
delay <- filter(delay, count>20, dest!="HNL")

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size=count), alpha=1/3) +
  geom_smooth(se=F)

delay <- flights %>%
  group_by(dest) %>%
  summarize(count=n(),
            dist=mean(distance, na.rm=T),
            delay=mean(arr_delay, na.rm=T)) %>%
  filter(count>20, dest!="HNL")

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay=mean(arr_delay, na.rm=T),
            n=n())

ggplot(delays, aes(x=delay)) +
  geom_freqpoly(binwidth=10)
  
ggplot(delays, aes(n, delay)) +
  geom_point()

delays %>%
  filter(n>25) %>%
  ggplot(aes(n, delay)) +
    geom_point(alpha=1/10)


install.packages("Lahman")
batting <- as_tibble(Lahman::Batting)
batters <- batting %>%
  group_by(playerID) %>%
  summarize(ba=sum(H, na.rm=T) / sum(AB, na.rm=T),
            ab=sum(AB, na.rm=T))
batters %>%
  filter(ab > 100) %>%
  ggplot(aes(ab, ba)) +
    geom_point() +
    geom_smooth(se=F)

ans <- flights %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))


ans1 <- not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r=min_rank(desc(dep_time)))

ans2 <- not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r=min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers=n_distinct(carrier)) %>%
  arrange(desc(carriers))
  
not_cancelled %>%
  count(dest)

not_cancelled %>%
  count(tailnum, wt=distance)

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early=sum(dep_time < 500))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc=mean(arr_delay > 60))

daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights=n()))
(per_month <- summarize(per_day, flights=sum(flights)))
(per_year <- summarize(per_month, flights=sum(flights)))

daily %>%
  ungroup() %>%
  summarize(flights=n())

#Ex.1
#出発遅延dep_delay、到着遅延arr_delayを確認
#出発が早まることはない
#到着時刻は前後にずれる
flights %>% 
  transmute(dep_15_first=dep_delay < -15,
                      dep_15_delay=dep_delay > 15,
                      arr_15_first=arr_delay < -15,
                      arr_15_delay=arr_delay > 15) %>%
  summarize(dep_first_m=mean(dep_15_first, na.rm=T),
            dep_delay_m=mean(dep_15_delay, na.rm=T),
            arr_first_m=mean(arr_15_first, na.rm=T),
            arr_delay_m=mean(arr_15_delay, na.rm=T))

#出発も到着も10分遅れることはあまりない
flights %>% 
  transmute(dep_10_delay=dep_delay > 10,
            arr_10_delay=arr_delay >10) %>%
  summarize(dep_delay_m=mean(dep_10_delay, na.rm=T),
            arr_delay_m=mean(arr_10_delay, na.rm=T))

#到着は遅れることの方が多い
flights %>% 
  transmute(dep_30_first=dep_delay < -30,
            dep_30_delay=dep_delay > 30,
            arr_30_first=arr_delay < -30,
            arr_30_delay=arr_delay > 30) %>%
  summarize(dep_first_m=mean(dep_30_first, na.rm=T),
            dep_delay_m=mean(dep_30_delay, na.rm=T),
            arr_first_m=mean(arr_30_first, na.rm=T),
            arr_delay_m=mean(arr_30_delay, na.rm=T))

#時刻通りの到着は難しい
#出発も到着も大幅に遅れる可能性は低い
flights %>% 
  transmute(dep_on=dep_delay == 0,
            arr_on=arr_delay == 0,
            dep_120_delay=dep_delay > 120,
            arr_120_delay=arr_delay > 120) %>%
  summarize(dep_on_m=mean(dep_on, na.rm=T),
            arr_on_m=mean(arr_on, na.rm=T),
            dep_delay_m=mean(dep_120_delay, na.rm=T),
            arr_delay_m=mean(arr_120_delay, na.rm=T))

# Ex.2
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% count(dest)

not_cancelled %>% 
  group_by(dest) %>%
  summarize(n=n())

not_cancelled %>%
  count(tailnum, wt=distance)

not_cancelled %>% 
  group_by(tailnum) %>%
  summarize(n=sum(distance))

#Ex.3
#arr_delayがNullでキャンセル便でないものがある
ans <- filter(flights, is.na(arr_delay), !is.na(arr_time))
#キャンセル便
filter(flights, is.na(arr_time))

#Ex.4
group_by(flights, year, month, day) %>%
  summarize(cnt=sum(is.na(arr_time)), ratio=mean(is.na(arr_time)), arr_delay_m=mean(arr_delay, na.rm=T)) %>%
  ggplot(aes(x=arr_delay_m, y=ratio)) +
  geom_point()


library(lubridate)

group_by(flights, year, month, day) %>%
  summarize(cnt=sum(is.na(arr_time)), ratio=mean(is.na(arr_time)), arr_delay_m=mean(arr_delay, na.rm=T)) %>%
  mutate(date=ymd(year * 10000 + month * 100 + day)) %>%
  ggplot(aes(x=date, y=ratio)) +
  geom_line()


#Ex.5
#F9が見劣りする
mutate(flights, arr_delay_real=if_else(arr_delay > 0, arr_delay, 0)) %>%
  group_by(carrier) %>%
  summarize(delay_avg=mean(arr_delay_real, na.rm=T), 
            delay_max=max(arr_delay, na.rm=T),
            dalay_cnt=mean(arr_delay > 30, na.rm=T))


#キャリア毎の遅延時間の差を考慮した、各空港の遅延時間
#CAEに遅延が多い
mutate(flights, arr_delay_real=if_else(arr_delay > 0, arr_delay, 0)) %>%
  group_by(carrier) %>%
  mutate(dl_car=mean(arr_delay_real, na.rm=T), dl_diff=arr_delay_real-dl_car) %>%
  group_by(dest) %>%
  summarize(dl_dest=mean(dl_diff, na.rm=T)) %>%
  arrange(desc(dl_dest))

#キャリア毎の遅延時間の差を考慮した、各空港の遅延時間
#やはりF9が見劣りする
mutate(flights, arr_delay_real=if_else(arr_delay > 0, arr_delay, 0)) %>%
  group_by(dest) %>%
  mutate(dl_dest=mean(arr_delay_real, na.rm=T), dl_diff=arr_delay_real-dl_dest) %>%
  group_by(carrier) %>%
  summarize(dl_car=mean(dl_diff, na.rm=T)) %>%
  arrange(desc(dl_car))


#Ex.6
#Miss Type

#Ex.7
#カウントの結果を降順でソートする
flights %>% count(carrier, sort=T)


# グループごとの演算、抽出

#毎日の遅延上位
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

#便数が上位の空港
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)

#目的地別に各便の遅延時間が占める割合を出力
#下記のsumはpopular_destsに設定されたgroup_by(dest)に関して計算される
chk <- popular_dests %>% 
  filter(arr_delay > 0) %>%
  mutate(prop_delay=arr_delay/sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay) %>%
  arrange(dest, desc(arr_delay))


#Ex.1
#先にgroup_byを行っておくと、mutateやfilterはグループ毎に適用される

#Ex.2
#各便複数回フライトしている
count(flights, tailnum)
#dep_delayもしくはarr_delayが欠損のデータは除く
delay_data <- filter(flights, !is.na(dep_delay)&!is.na(arr_delay)) %>%
  arrange(arr_delay)
View(delay_data)
#フライトの最大は544

#出発遅延（10回以上のフライト）
mutate(delay_data, delay_only=ifelse(dep_delay>0, dep_delay, 0)) %>%
  group_by(tailnum) %>%
  summarize(dev=mean(dep_delay),
            delay=mean(delay_only),
            max=max(delay_only),
            ratio=mean(delay_only>15),
            count=n()) %>%
  filter(count>10) %>%
  arrange(desc(delay))
  
#到着遅延（10回以上のフライト）
mutate(delay_data, delay_only=ifelse(arr_delay>0, arr_delay, 0)) %>%
  group_by(tailnum) %>%
  summarize(dev=mean(arr_delay),
            delay=mean(delay_only),
            max=max(delay_only),
            ratio=mean(delay_only>15),
            count=n()) %>%
  filter(count>100) %>%
  arrange(desc(delay))

#Ex.3
#出発遅延
mutate(delay_data, delay_only=ifelse(dep_delay>0, dep_delay, 0)) %>%
  group_by(hour) %>%
  summarize(dev=mean(dep_delay),
            delay=mean(delay_only),
            max=max(delay_only),
            ratio=mean(delay_only>15),
            count=n())
  
#到着遅延
mutate(delay_data, delay_only=ifelse(arr_delay>0, arr_delay, 0)) %>%
  group_by(hour) %>%
  summarize(dev=mean(arr_delay),
            delay=mean(delay_only),
            max=max(delay_only),
            ratio=mean(delay_only>15),
            count=n())

#Ex.4
filter(flights, arr_delay>0) %>%
  group_by(origin, dest) %>%
  mutate(ratio=arr_delay/sum(arr_delay)) %>%
  group_by(origin, dest, tailnum) %>%
  summarize(sum_tail=sum(arr_delay), rto_tail=sum(ratio)) %>%
  arrange(dest, desc(rto_tail))


#Ex.5
filter(flights, !is.na(dep_delay)) %>%
  arrange(year, month, day, origin, dep_time) %>%
  group_by(year, month, day, origin) %>%
  mutate(dep_delay_l=lag(dep_delay)) %>%
  select(year, month, day, origin, dep_time, dep_delay, dep_delay_l) %>%
  filter(!is.na(dep_delay_l)) %>%
  group_by(dep_delay_l) %>%
  summarize(dep_delay=mean(dep_delay, na.rm=T), count=n()) %>%
  filter(count > 50) %>%
  ggplot(aes(dep_delay_l, dep_delay)) +
  geom_point()
  

#Ex.6
#最速便からの倍率を集計
#LGA-BOSが若干怪しい
arrange(flights, origin, dest, air_time) %>%
  group_by(origin, dest) %>%
  mutate(air_time_min=min(air_time, na.rm=T), air_time_mult=air_time/air_time_min) %>%
  filter(!is.na(air_time_mult)) %>%
  summarize(max=max(air_time_mult), mean=mean(air_time_mult), dbl_rto=mean(air_time_mult > 2)) %>%
  arrange(desc(dbl_rto))

chk <- filter(flights, origin=="LGA", dest=="BOS") %>%
  arrange(air_time)

#N955UWが遅延が多いように見えるが、LGA-BOS便であり、最速便の入力ミスの可能性がある
arrange(flights, origin, dest, air_time) %>%
  group_by(origin, dest) %>%
  mutate(air_time_min=min(air_time, na.rm=T), air_time_mult=air_time/air_time_min) %>%
  filter(!is.na(air_time_mult)) %>%
  group_by(tailnum) %>%
  summarize(max=max(air_time_mult), mean=mean(air_time_mult), dbl_rto=mean(air_time_mult > 2), count=n()) %>%
  filter(count>100) %>%
  arrange(desc(dbl_rto))

chk <- arrange(flights, origin, dest, air_time) %>%
  group_by(origin, dest) %>%
  mutate(air_time_min=min(air_time, na.rm=T), air_time_mult=air_time/air_time_min) %>%
  filter(!is.na(air_time_mult), tailnum=='N955UW')
  
filter(flights, !is.na(air_time)) %>%
  group_by(tailnum) %>%
  summarize(cnt=n()) %>%
  ggplot(aes(cnt)) +
  geom_histogram(bins=100, color='white') +
  scale_x_continuous(breaks=seq(0, 600, by=50))


#Ex.7
#少なくとも2つのcarrierが運航しているdestを主要空港と見做す
#主要空港に対する運航便の数で航空会社をランキングする
group_by(flights, dest, carrier) %>%
  summarize(count=n()) %>%
  group_by(dest) %>%
  mutate(car_cnt=n()) %>%
  filter(car_cnt>1) %>%
  group_by(carrier) %>%
  summarize(dest_cnt=n()) %>%
  arrange(desc(dest_cnt))

?flights
airlines
View(chk)



