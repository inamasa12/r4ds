
x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")

sort(x1)

#水準集合、希望の順に並べて作成
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

#factorの作成
y1 <- factor(x1, levels=month_levels)
sort(y1)
y2 <- factor(x2, levels=month_levels)


#出現順に一意に
unique(x1)


z1 <- factor(x1)
a1 <- fct_inorder(z1)

levels(a1)

gss_cat %>%
  count(race)

ggplot(gss_cat) +
  geom_bar(aes(race)) +
  scale_x_discrete(drop=F)

#Ex.1

#reported income
gss_cat %>%
  count(rincome)

ggplot(gss_cat) +
  geom_bar(aes(rincome)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#religion
gss_cat %>%
  count(relig, sort=T)

#partyid
gss_cat %>%
  count(partyid, sort=T)

#Ex.2
ggplot(gss_cat) +
  geom_count(aes(x=relig, y=denom)) +
  theme(axis.text.x=element_text(angle=90))

gss_cat %>%
  count(relig, denom) %>%
  ggplot(aes(x=relig, y=denom)) +
  geom_tile(aes(fill=n)) +
  theme(axis.text.x=element_text(angle=90))


relig <- gss_cat %>%
  group_by(relig) %>%
  summarize(
    age=mean(age, na.rm=T),
    tvhours=mean(tvhours, na.rm=T),
    n=n()
  )

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) + 
  geom_point()
  
relig %>%
  mutate(relig=fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) + 
  geom_point()


rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarize(
    age=mean(age, na.rm=T),
    tvhours=mean(tvhours, na.rm=T),
    n=n()
  )

ggplot(rincome, aes(age, rincome)) + 
  geom_point()


ggplot(rincome, aes(age, fct_reorder(rincome, age))) + 
  geom_point()


ggplot(rincome, aes(age, fct_relevel(rincome, "Not applicable"))) + 
  geom_point()

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  group_by(age, marital) %>%
  count() %>%
  group_by(age) %>%
  mutate(prop=n/sum(n))

ggplot(by_age, aes(age, prop, color=marital)) +
  geom_line(na.rm=T)

#fct_reorder2
#maritalをageの最大値（右端）のpropの値で並び変える
ggplot(by_age,
       aes(age, prop, color=fct_reorder2(marital, age, prop))
       ) +
  geom_line() +
  labs(color="maital")

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()


#fct_infreq(): 度数降順でlevelを設定
#fct_rev(): levelを逆順にする
gss_cat$marital %>% fct_infreq() %>% fct_rev()


#Ex.1
#tvhours: TV視聴時間
#tvhours=24は異常値だが、平均値に与える影響は限定的
gss_cat %>%
  filter(year==2014, !is.na(relig), !is.na(tvhours)) %>%
  group_by(relig) %>%
  summarize(tv_mean=mean(tvhours), 
            tv_med=median(tvhours),
            tv_max=max(tvhours),
            tv_min=min(tvhours),
            tv_mean_win=mean(ifelse(tvhours==24, NA, tvhours), na.rm=T),
            tv_ext=sum(ifelse(tvhours==24, 1, 0)),
            cnt=n())

#Ex.2
#設定されている
str(gss_cat)


#Ex.3
levels(gss_cat$rincome)


#level順に表示
#グラフは先頭が最も下に表示される
g1 <- ggplot(rincome, aes(age, rincome)) + 
  geom_point()

g2 <- ggplot(rincome, 
       aes(age, fct_relevel(rincome, "Not applicable"))) + 
  geom_point()

g1 + g2 + plot_layout(ncol=1)

ggplot(rincome, 
       aes(age, fct_rev(fct_relevel(rincome, "Not applicable")))) + 
  geom_point()


gss_cat %>%
  count(partyid)

gss_cat %>%
  mutate(partyid=fct_recode(partyid,
                            "Republican, strong"   ="Strong republican",
                            "Republican, weak"     ="Not str republican",
                            "Independent, near rep"="Ind,near rep",
                            "Independent, near dem"="Ind,near dem",
                            "Democrat, weak"       ="Not str democrat",
                            "Democrat, strong"     ="Strong democrat")) %>%
  count(partyid)

#最小グループをOtherにまとめていく
gss_cat %>%
  mutate(relig=fct_lump(relig, n=10)) %>%
  count(relig, sort=T) %>%
  print(n=Inf)
  
gss_cat %>%
  count(relig, sort=T)
  

#Ex.1
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat"))) %>%
  count(year, partyid) %>%
  group_by(year) %>%
  mutate(ratio = n / sum(n)) %>%
  ggplot(aes(x=year, y=ratio)) +
  geom_line(aes(color=partyid))

#Ex.2
gss_cat %>%
  filter(year==2014, !is.na(rincome)) %>%
  mutate(rincome=fct_collapse(rincome,
                              "$5000 to 9999" = c("$8000 to 9999", "$7000 to 7999", "$6000 to 6999", "$5000 to 5999"),
                              "Lt $5000" = c("$4000 to 4999", "$3000 to 3999", "$1000 to 2999", "Lt $1000"))) %>%
  count(rincome) %>%
  mutate(ratio=n/sum(n))






View(gss_cat)

?gss_cat

library(tidyverse)
library(forcats)
library(patchwork)
