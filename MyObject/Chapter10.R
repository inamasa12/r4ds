
library(tidyverse)
library(nycflights13)

airlines
airports
planes
weather
flights

#Ex.1
flights/origin, dest
airports/faa

#Ex.2
weather/origin
airports/faa

#Ex.3
weather/origin
flights/dest

#Ex.4
planes/tailnum-seats
flights/tailnum

View(flights)


planes %>%
  count(tailnum) %>%
  filter(n>1)

?flights

#Ex.1
flights_ind <-flights %>%
  mutate(ind=row_number())

View(flights_ind)

#Ex.2
Batting_tbl <- tibble(Lahman::Batting)
Batting_tbl %>%
  count(playerID, yearID, stint) %>%
  filter(n>1)

babynames::babynames %>%
  count(year, name, wt=1) %>%
  filter(n>1)

nasaweather::atmos %>%
  count(lat, long, year, month) %>%
  filter(n>1)

fueleconomy::vehicles %>%
  count(id) %>%
  filter(n>1)

ggplot2::diamonds %>%
  count(carat, cut, color, clarity, depth, table, price, x, y, z) %>%
  filter(n>1)

#特定できない
ggplot2::diamonds %>%
  filter(carat==0.23, cut=='Very Good', color=='E', clarity=='VS2', depth==60.8, table==58, price==402)

#Ex.3
library(Lahman)

#打撃成績, playerID, yearID, stintが主キー
Batting_tbl <- tibble(Batting)
Batting_tbl %>%
  count(playerID, yearID, teamID, stint) %>%
  filter(n>1)

#選手基礎データ, plaierIDが主キー、外部キー
Master_tbl <- tibble(Master)
Master_tbl %>% 
  count(playerID) %>%
  filter(n>1)

#給与データ、yearIDm teamID, playerIDが主キー
Salaries_tbl <- tibble(Salaries)
Salaries_tbl %>%
  count(yearID, teamID, playerID) %>%
  filter(n>1)

#監督データ
Managers_tbl <- tibble(Managers)
Managers_tbl %>%
  count(yearID, teamID, inseason) %>%
  filter(n>1)

#最優秀監督データ
AwardsManagers_tbl <- tibble(AwardsManagers)
AwardsManagers_tbl %>%
  count(yearID, lgID, awardID, playerID) %>%
  filter(n>1)

#打撃成績, playerID, yearID, stintが主キー
Batting_tbl <- tibble(Batting)
Batting_tbl %>%
  count(playerID, yearID, stint) %>%
  filter(n>1)

#投手成績, playerID, yearID, stintが主キー
Pitching_tbl <- tibble(Pitching)
Pitching_tbl %>%
  count(playerID, yearID, stint) %>%
  filter(n>1)

#野手成績, playerID, yearID, stint, POSが主キー
Fielding_tbl <- tibble(Fielding)
Fielding_tbl %>%
  count(playerID, yearID, stint, POS) %>%
  filter(n>1)


flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by='carrier')

flights2 %>%
  select(-origin, -dest) %>%
  mutate(name=airlines$name[match(flights2$carrier, airlines$carrier)])

flights
airports

flights %>%
  group_by(origin, dest) %>%
  count() %>%
  filter(n>3000) %>%
  inner_join(airports, by=c("origin"="faa")) %>%
  inner_join(airports, by=c("dest"="faa")) %>%
  select(origin, ori_lat=lat.x, ori_lon=lon.x,
         dest, dest_lat=lat.y, dest_lon=lon.y) %>%
  ggplot() +
  borders("state") +
  geom_segment(aes(x=ori_lon, xend=dest_lon,
                   y=ori_lat, yend=dest_lat),
                   arrow=arrow(length=unit(0.3, "cm"))) +
  coord_quickmap()



Batting_tbl
Master_tbl
Salaries_tbl

install.packages("datamodelr")
library(datamodelr)

dm_from_data_frames(list(
  Batting = Batting_tbl,
  Master = Master_tbl,
  Salaries = Salaries_tbl)) %>%
  dm_set_key("Batting", c("playerID", "yearID", "stint")) %>%
  dm_set_key("Master", "playerID") %>%
  dm_set_key("Salaries", c("yearID", "teamID", "playerID")) %>%
  dm_add_references(
    Batting$playerID == Master$playerID,
    Salaries$playerID == Master$playerID
  ) %>% 
  dm_create_graph(rankdir="LR", columnArrows=T) %>%
  dm_render_graph()


library(devtools)

install_github("bergant/datamodelr")

install.packages("DiagrammeR")
library(DiagrammeR)



x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)


x %>%
  inner_join(y, by="key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, key="key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)

left_join(x, y, key="key")

flights2 %>%
  left_join(weather)



#Ex.1
airports %>%
  semi_join(flights, c("faa"="dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(aes(size=arr_delay)) +
  coord_quickmap()
  
flights %>%
  mutate(arr_delay2=ifelse(arr_delay>0, arr_delay, 0)) %>%
  group_by(dest) %>%
  summarize(arr_delay_mean=mean(arr_delay2, na.rm=T)) %>%
  left_join(airports, by=c('dest'='faa')) %>%
  filter(!is.na(arr_delay_mean), !is.na(lon), !is.na(lat)) %>%
  ggplot(aes(x=lon, y=lat, color=arr_delay_mean)) +
  borders("state") +
  geom_point() +
  coord_quickmap()


#Ex.2
flights %>%
  group_by(origin, dest) %>%
  count() %>%
  filter(n>3000) %>%
  inner_join(airports, by=c("origin"="faa")) %>%
  inner_join(airports, by=c("dest"="faa")) %>%
  select(origin, ori_lat=lat.x, ori_lon=lon.x,
         dest, dest_lat=lat.y, dest_lon=lon.y) %>%
  ggplot() +
  borders("state") +
  geom_point(aes(x=ori_lon, y=ori_lat), color="red") +
  geom_point(aes(x=dest_lon, y=dest_lat), color="blue") +
  coord_quickmap()


#Ex.3
#tailnumで一意
planes %>%
  count(tailnum) %>%
  filter(n>1)

flights %>%
  left_join(planes, by="tailnum") %>%
  mutate(delay1=arr_delay-dep_delay, age=as.factor(year.x-year.y)) %>%
  #mutate(delay=ifelse(delay1>0, delay1, 0)) %>%
  mutate(delay=delay1) %>%  
  filter(!is.na(age), !is.na(tailnum), !is.na(delay)) %>%
  select(tailnum, age, delay) %>%
  group_by(tailnum, age) %>%
  summarize(delay_avg=mean(delay)) %>%
  ggplot() +
  geom_boxplot(aes(x=age, y=delay_avg)) +
  theme(axis.text.x = element_text(angle = 90))

#Ex.4
#visibが悪いと遅い
#temp, dewp, wind_speed, precipが高いと遅い

#temp, dewp, humid, wind_speed, precip, pressure, visib
  

flights %>%
  left_join(weather, by=c("origin", "year", "month", "day", "hour")) %>%
  mutate(dep_delay_abs=ifelse(dep_delay>0, dep_delay, 0),
         fact=cut_width(pressure, 10)) %>%
  group_by(fact) %>%
  summarize(mean=mean(dep_delay_abs, na.rm=T),
            median=median(dep_delay_abs, na.rm=T),
            cnt=n()) %>%
  ggplot() +
  geom_point(aes(x=fact, y=mean), color="red") +
  geom_point(aes(x=fact, y=median), color="blue")


flights %>%
  left_join(weather, by=c("origin", "year", "month", "day", "hour")) %>%
  mutate(dep_delay_abs=ifelse(dep_delay>0, dep_delay, 0),
         fact=wind_speed) %>%
  group_by(fact) %>%
  summarize(mean=mean(dep_delay_abs, na.rm=T),
            median=median(dep_delay_abs, na.rm=T)) %>%
  ggplot() +
  geom_point(aes(x=fact, y=mean)) +
  geom_smooth(aes(x=fact, y=mean))
  

#Ex.5
flights %>%
  mutate(arr_delay_abs=ifelse(arr_delay>0, arr_delay, 0),
         date=date(time_hour)) %>%
  group_by(date) %>%
  summarize(del_mean=mean(arr_delay, na.rm=T),
            del_median=median(arr_delay, na.rm=T),
            del_abs_mean=mean(arr_delay_abs, na.rm=T),
            del_abs_median=median(arr_delay_abs, na.rm=T),
            del_cnt=sum(ifelse(is.na(arr_delay), 0, ifelse(arr_delay>15, 1, 0))),
            dis_cnt=sum(ifelse(is.na(arr_delay), 1, 0)),
            cnt=n(),
            del_rat=del_cnt/cnt,
            dis_rat=dis_cnt/cnt) %>%
  #filter(del_rat>0.6)
  ggplot(aes(x=date)) +
  geom_line(aes(y=del_cnt)) +
  theme(axis.text.x = element_text(angle = 90))

  
weather %>%
  mutate(date=date(time_hour)) %>%
  group_by(date) %>%
  summarize(temp=max(temp, na.rm=T),
            dewp=max(dewp, na.rm=T),
            humid=max(humid, na.rm=T),
            wind_speed=max(wind_speed, na.rm=T),
            precip=max(precip, na.rm=T),
            pressure=max(pressure, na.rm=T),
            visib=mean(visib, na.rm=T)
            ) %>%
  filter(wind_speed>30.0)
  ggplot(aes(x=date)) +
  geom_line(aes(y=wind_speed))

  
#遅延の地理的プロット  
flights %>%
  select(year, month, day, dest, arr_delay) %>% 
  filter(year == 2013, month == 6, day == 13) %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c("dest" = "faa")) %>%
  ggplot(aes(y = lat, x = lon, size = delay, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap() 



top_dest <- flights %>%
  count(dest, sort=T) %>%
  head(10)
  
top_dest$dest

flights %>%
  filter(dest %in% top_dest$dest)


flights %>%
  semi_join(top_dest)

flights %>%
  anti_join(planes, by="tailnum") %>%
  count(tailnum, na.rm=T)

planes %>% filter(tailnum=='D942DN')


#Ex.1
#欠便
flights %>%
  filter(is.na(tailnum))

#末尾がMQ
chk <- flights %>%
  anti_join(planes, by='tailnum') %>%
  count(tailnum, sort=T)


airlines %>%
  filter(carrier=='MQ')

#Ex.2
fl_many <- flights %>%
  filter(!is.na(tailnum), !is.na(air_time)) %>%
  count(tailnum) %>%
  filter(n>=100)

flights %>%
  semi_join(fl_many, by='tailnum')

flights %>%
  semi_join(flights %>%
              filter(!is.na(tailnum), !is.na(air_time)) %>%
              count(tailnum) %>%
              filter(n>=100), by='tailnum')

#Ex.3
chk <- vehicles %>%
  semi_join(group_by(common, make) %>%
              top_n(1, n), by=c('make', 'model'))


#Ex.4
flights %>% 
  top_n(48, arr_delay) %>%
  arrange(desc(arr_delay))


top_n(flights, 48, arr_delay)
weather %>%
  semi_join(top_n(flights, 48, arr_delay),
            by=c('year', 'month', 'day', 'hour'))

#Ex.5
airports
chk <- anti_join(flights, airports, by=c("dest"="faa"))

anti_join(airports, flights, by=c("faa"="dest"))


#Ex.6
airlines
airports
planes
flights


flights %>%
  filter(!is.na(air_time)) %>%
  left_join(planes, by='tailnum') %>%
  left_join(airlines, by='carrier') %>%
  select(year.x:day, sched_dep_time, carrier, name, tailnum, manufacturer) %>%
  count(carrier, name, manufacturer) %>%
  group_by(carrier, name) %>%
  mutate(all=sum(n), ratio=n/all) %>%
  ggplot(aes(x=name)) +
    geom_bar(aes(y=ratio, fill=manufacturer), stat='identity') +
    theme(axis.text.x = element_text(angle = 90))
  


#集合演算
df1 <- tribble(
  ~x, ~y,
  1, 1,
  2, 1
)

df2 <- tribble(
  ~x, ~y,
  1, 1,
  1, 2
)
intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)


View(flights)

flights/carrier-flights/tailnum-planes/manufacturer






library(tidyverse)
library(nycflights13)
library(lubridate)
library(fueleconomy)


