

today()
now()

#文字列から
ymd("2017-01-31")
ymd("2017-01-31", tz="UTC")

#数値から
ymd(20170131)

mdy("January 31st, 2017")
dmy("31-Jan-2017")



ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")


flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure=make_datetime(year, month, day, hour, minute))


make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}



flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time=make_datetime_100(year, month, day, dep_time),
    arr_time=make_datetime_100(year, month, day, arr_time),
    sched_dep_time=make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time=make_datetime_100(year, month, day, sched_arr_time)) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))

View(flights_dt)

#Every 1day
flights_dt %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth=86400)

#Every 10min
flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth=600)

#日付時刻に変換
as_datetime(today())

#日付に変換
as_date(now())

#UNIX標準時刻を起点
as_datetime(60*60*10)
as_date(365*10+2)

#Ex.1
#NAを返す
ymd(c("2010-10-10", "bananas"))

#Ex.2
today("UTC")
now("UTC")

#Ex.3
d1 <- "January 15, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14"
#locale="C"はC言語用のデフォルトフォーマットで北米の使用に準じる
mdy(d1, locale="C")
ymd(d2)
dmy(d3)
mdy(d4, locale="C")
mdy(d5)

datetime <- ymd_hms("2016-07-08 12:34:56")
year(datetime)
month(datetime)
mday(datetime)
#年初からの日数
yday(datetime)
wday(datetime)


month(datetime, label=T, locale="C")
wday(datetime, label=T, locale="C", abbr=F)

flights_dt %>%
  mutate(wday=wday(dep_time, label=T)) %>%
  ggplot(aes(x=wday)) +
  geom_bar()

flights_dt %>%
  mutate(minute=minute(dep_time)) %>%
  group_by(minute) %>%
  summarize(avg_delay=mean(dep_delay, na.rm=T),
            n=n()) %>%
  ggplot(aes(minute, avg_delay)) +
  geom_line()

flights_dt %>%
  mutate(minute=minute(sched_dep_time)) %>%
  group_by(minute) %>%
  summarize(avg_delay=mean(dep_delay, na.rm=T),
            n=n()) %>%
  #ggplot(aes(minute, avg_delay)) +
  ggplot(aes(minute, n)) +
  geom_line()

ggplot(sched_dep, aes())

flights_dt %>%
  count(week=floor_date(dep_time, "week")) %>%
  ggplot(aes(week, n)) +
  geom_line()

td <- ymd(20201116)
round_date(td, "month")


#アクセサ関数で操作できる
datetime <- ymd_hms("2016-07-08 12:34:56")
month(datetime) <- 1
hour(datetime) <- hour(datetime) + 1

update(datetime, year=2020, month=2, mday=2, hour=2)

ymd("2015-02-01") %>%
  update(mday=30)

flights_dt %>%
  #全て1/1にする
  mutate(dep_hour=update(dep_time, yday=1)) %>%
  ggplot(aes(dep_hour)) +
  #300sec=5min毎にまとめる
  geom_freqpoly(binwidth=300)

View(chk)

#Ex.1
#時間帯別（dep_time）のフライト数を集計、時系列グラフ化
#夏場は夜のフライトが増える
#集計対象はファクタになっている必要がある
flights_dt %>%
  mutate(date=floor_date(dep_time, "day"), hour=as.factor(hour(floor_date(dep_time, "4 hours")))) %>%
  count(date, hour) %>%
  ggplot(aes(x=date, y=n)) +
  geom_line(aes(color=hour), size=0.5)

#Ex.2
#dep_timeは正しく日付処理が行われていない
flights_dt %>%
  mutate(act_dep_time=update(sched_dep_time, minute=(minute(sched_dep_time) + dep_delay))) %>%
  select(sched_dep_time, dep_delay, dep_time, act_dep_time) %>%
  filter(dep_time!=act_dep_time)

flights_dt %>%
  mutate(act_dep_time=sched_dep_time + dep_delay * 60) %>%
  select(sched_dep_time, dep_delay, dep_time, act_dep_time) %>%
  filter(dep_time!=act_dep_time)

#Ex.3
#air_timeは分表示
#dep_time、arr_timeは現地時間となっており、標準時のずれがあるものと思われる
flights_dt %>%
  mutate(flight1 = arr_time - dep_time,
         flight2 = arr_time - sched_dep_time,
         flight3 = sched_arr_time - dep_time,
         flight4 = sched_arr_time - sched_dep_time) %>%
  select(air_time, flight1) %>%
  arrange(flight1)

flights %>%
  select(origin, dest, dep_time, arr_time, air_time) %>%
  filter(air_time < 30)

#Ex.4
#時間帯別の平均遅延時間
#dep_delay, dep_time or sched_dep_time
#sched_dep_timeを用いるべき、dep_timeには遅延時間が含まれるため

flights_dt %>%
  #日付を揃えて時間で丸める
  mutate(agg_hour=floor_date(update(dep_time, yday=1), "hour")) %>%
  group_by(agg_hour) %>%
  summarize(avg_delay=mean(dep_delay, na.rm=T), cnt=n()) %>%
  ggplot(aes(x=agg_hour, y=avg_delay)) +
  geom_line()

flights_dt %>%
  #日付を揃えて時間で丸める
  mutate(agg_hour=floor_date(update(sched_dep_time, yday=1), "hour")) %>%
  group_by(agg_hour) %>%
  summarize(avg_delay=mean(dep_delay, na.rm=T), cnt=n()) %>%
  ggplot(aes(x=agg_hour, y=avg_delay)) +
  geom_line()

#Ex.5
#土曜日の遅延が少ない
flights_dt %>%
  mutate(agg_week=wday(sched_dep_time, label=T)) %>%
  group_by(agg_week) %>%
  summarize(delay=mean(dep_delay, na.rm=T),
            abs=mean(ifelse(dep_delay>0, dep_delay, 0), na.rm=T),
            ratio=mean(ifelse(dep_delay>30, 1, 0), na.rm=T),
            cnt=n()) %>%
  ggplot(aes(x=agg_week, y=ratio)) +
  geom_bar(stat="identity")

#Ex.6

str(diamonds$carat)
flights$sched_dep_time

ggplot(diamonds) +
  geom_histogram(aes(carat))

ggplot(flights) +
  geom_histogram(aes(sched_dep_time))

flights_dt %>%
  #日付を揃えて時間で丸める
  mutate(agg_hour=update(sched_dep_time, yday=1)) %>%
  ggplot(aes(agg_hour)) +
  geom_histogram()



#切りの良いところで丸められている
flights_dt %>%
  mutate(min=minute(sched_dep_time)) %>%
  ggplot(aes(min)) +
  geom_histogram(binwidth = 1)

ggplot(diamonds) +
  geom_histogram(aes(carat), bins=500)


#Ex.7
#shed_dep_timeではそのようなことは生じない
#ボリュームゾーンの早期出発がこの時間帯に増える


flights_dt %>%
  #filter(month(dep_time)==4, mday(dep_time)==4, hour(dep_time)==18) %>%
  #10分毎に切り捨てで丸める
  mutate(agg_min=minute(dep_time), dep_min=minute(sched_dep_time)) %>%
  group_by(agg_min) %>%
  summarize(avg_delay=mean(dep_delay, na.rm=T), 
            abs_delay=sum(ifelse(dep_delay > 0, dep_delay, 0), na.rm=T),
            ratio=mean(ifelse(dep_delay>30, 1, 0), na.rm=T),
            delay=sum(ifelse(dep_delay>30, 1, 0)),
            avg_min=mean(dep_min, na.rm=T), 
            early=sum(ifelse(dep_delay<0, 1, 0)),
            total=n()) %>%
  ggplot() +
  geom_bar(aes(x=agg_min, y=early), stat="identity", fill="blue", alpha=0.3) +
  geom_bar(aes(x=agg_min, y=total), stat="identity", fill="red", alpha=0.3)



h_age <- today() - ymd(19791024)

#デュレーションは常に秒
as.duration(h_age)
dyears(1)

#デュレーションは演算可能
tommorow <- today() + ddays(1)
ddays(1) * 2

#丁度夏時間への移行を挟む
one_pm <- ymd_hms("2016-03-12 13:00:00", tz="America/New_York")
one_pm + ddays(1)

#ピリオドも同様
one_pm + days(1)

10 * (months(6) + days(1))


flights_dt %>%
  filter(arr_time < dep_time)

flights_dt <- flights_dt %>%
  mutate(overnight = arr_time < dep_time,
         arr_time = arr_time + days(overnight * 1),
         sched_arr_time = sched_arr_time + days(overnight * 1))


flights_dt %>%
  filter(arr_time < dep_time)

year_after <- today() + years(4)

#インターバル
today() %--% year_after
(today() %--% year_after) / ddays(1)
(today() %--% year_after) / days(1)

uruu <- ymd("2016-1-1")
uruu_1 <- uruu + years(1)  #ピリオド
uruu + dyears(1) #デュレーション

uruu %--% uruu_1 / days(1)
uruu %--% uruu_1 / ddays(1)

#Ex.1
months(4)
dmonths(1) / ddays(1)

#Ex.2
overnight <- 5
days(overnight * 1)

#Ex.3
ymd("2015-1-1") + months(c(0:11))

update(today(), yday=1) + months(c(0:11))
floor_date(today(), unit="year") + months(c(0:11))

#Ex.4
birth_d <- "1972-5-24"
(ymd(birth_d) %--% today()) %/% years(1)

#Ex.5
(today() %--% (today() + years(1)) / months(1))

Sys.timezone()
OlsonNames()

#タイムゾーンは属性の一つで表示をコントロールする
x1 <- ymd_hms("2015-06-01 12:00:00", tz="America/New_York")
x2 <- ymd_hms("2015-06-01 18:00:00", tz="Europe/Copenhagen")
x3 <- ymd_hms("2015-06-02 04:00:00", tz="Pacific/Auckland")

x1 - x2
x2 - x3

x4 <- c(x1, x2, x3)

#タイムゾーンの変更⇒時刻は変わらない
with_tz(x4, tzone="Australia/Lord_Howe")

#時刻をそのままにタイムゾーンを変更⇒時刻が変わる
force_tz(x4, tzone="Australia/Lord_Howe")


View(flights_dt)

library(tidyverse)
library(lubridate)
library(nycflights13)
