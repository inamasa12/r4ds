
library(tidyverse)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(se=F) +
  labs(
    title=paste(
      "Fuel efficiency generally decreases with",
      "engine size"
    ),
    subtitle=paste(
      "Two seaters (sports cars) are an exception",
      "because of their light weight"
    ),
    caption="Data from fueleconomy.gov",
    x="Engine displacement (L)",
    y="Highwqay fuel economy (mpg)",
    color="Car Type"
  )

df <- tibble(
  x=runif(10),
  y=runif(10)
)

ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x=quote(sum(x[i]^2, i==1, n)),
    y=quote(alpha + beta + frac(delta, theta))
  )

?plotmath


#Ex.1
?mpg
#cty: highway miles per gallon
#displ: engine displacement

ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(color=year)) +
  labs(
    title="排気量と燃費の関係",
    subtitle="排気量が多いほど、発売年度が古いほど、燃費は落ちる",
    caption="SMTAM",
    x="排気量",
    y="燃費",
    color="発売年度"
  )

#Ex.2

ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(color=class)) +
  geom_point(
    data=filter(mpg, class=="2seater"),
    size=4, shape=1
  ) +
  geom_smooth(se=F, size=0.5) +
  geom_smooth(
    data=filter(mpg, class!="2seater"),
    se=F,
    size=0.5,
    color="red"
  ) +
  labs(
    title="排気量と燃費の関係",
    subtitle="排気量が多いほど、発売年度が古いほど、燃費は落ちる",
    caption="SMTAM",
    x="排気量",
    y="燃費",
    color="発売年度"
  )

#Ex.3
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy))==1)

#ラベルを付ける①
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_text(aes(label=model), data=best_in_class)


#ラベルを付ける②
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_label(
    aes(label=model), 
    data=best_in_class,
    nudge_y=2,
    alpha=0.5)

install.packages("ggrepel")

#ラベルを付ける③
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_point(size=3, shape=1, data=best_in_class) +
  ggrepel::geom_label_repel(
    aes(label=model), 
    data=best_in_class)


class_avg <- mpg %>%
  group_by(class) %>%
  summarize(
    displ=median(displ),
    hwy=median(hwy))

#ラベルにグループ名を用いる
library(tidyverse)

ggplot(mpg, aes(displ, hwy, color=class)) +
  ggrepel::geom_label_repel(aes(label=class),
                            data=class_avg,
                            size=5,
                            label.size=0,
                            segment.color=NA
                            ) +
  geom_point() +
  theme(legend.position="none")

p1 + p2

library(patchwork)


?ggrepel::geom_label_repel


label <- mpg %>%
  summarize(
    displ=max(displ),
    hwy=max(hwy),
    label=paste(
      "Increasing engine size is \nrelated to",
      "decreasing fuel economy"
    )
  )

#特定の位置に文字列の挿入、
#vjust、hjustは指定した座標をテキストのどの位置に合わせるかを指定する
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(
    aes(label=label),
    data=label,
    vjust="top",
    hjust="right"
  )


label <- tibble(
  displ=Inf,
  hwy=Inf,
  label=paste(
    "Increasing engine size is \nrelated to",
    "decreasing fuel economy"
  )
)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(
    aes(label=label),
    data=label,
    vjust="top",
    hjust="right"
  ) +
  geom_hline(yintercept=20, color="white", size=2)


#基本的にラベルの位置を特定するデータセットを新たに作成する必要がある

library(tidyverse)


#指定した幅で折り返す
"Increasing engine size related to decreasing fuel economy." %>%
  stringr::str_wrap(width=40) %>%
  writeLines() #文字列の出力

?str_wrap

#Ex.1
label <- tibble(
  displ=c(Inf, Inf, -Inf, -Inf),
  hwy=c(Inf, -Inf, Inf, -Inf),
  label=c("Upper Right", "Lower Right", "Upper Left", "Lower Left")
)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(
    aes(label=label),
    data=label,
    vjust=c("top", "bottom", "top", "bottom"),
    hjust=c("right", "right", "left", "left")
  )

#Ex.2
#個別のテキスト
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  annotate("text", x=5, y=35, label="Test")


#Ex.3
#全てのファセットに同じラベルを付ける
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=cty_max, size=3, shape=1) +
  ggrepel::geom_label_repel(aes(label="Max Cty"),
            data=cty_max,
            size=3) +
  facet_wrap(~class)

#全てのファセットにラベルを付ける
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=filter(cty_max, class=="2seater"), size=3, shape=1) +
  ggrepel::geom_label_repel(aes(label="Max Cty"),
                            data=filter(cty_max, class=="2seater"),
                            size=3) +
  facet_wrap(~class)


#全てのファセットに異なるラベルを付ける
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=cty_max, size=3, shape=1) +
  ggrepel::geom_label_repel(aes(label=year),
                            data=cty_max,
                            size=3) +
  facet_wrap(~class)


cty_max <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(cty))==1)

#Ex.4

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=hwy_max, size=3, shape=1) +
  geom_label(aes(label=class),
                            data=hwy_max,
                            size=3)

hwy_max <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy))==1)


#Ex.4
#不明

p1 <- ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=hwy_max, size=3, shape=1) +
  geom_label(aes(label=class),
             data=hwy_max,
             size=3)


p2 <- ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=hwy_max, size=3, shape=1) +
  geom_label(aes(label=class),
             data=hwy_max,
             size=3,
             label.r=0.1
             )

#Ex.5
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(data=hwy_max, size=3, shape=1) +
  geom_label(aes(label=class),
             data=hwy_max,
             size=3) +
  geom_segment(xend=2, yend=41.5, x=2.5, y=44, arrow=arrow())


#スケールは自動
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour=class))
  
#デフォルト（自動）
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour=class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()


ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks=seq(15, 40, by=5)) #目盛り


ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks=seq(0, 55, by=5)) #目盛り



ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(labels=NULL) +
  scale_x_continuous(labels=NULL)

#ラベル、目盛り幅
presidential %>%
  mutate(id=33+row_number()) %>%
  ggplot(aes(start, id)) +
  geom_point() +
  #線分
  geom_segment(aes(xend=end, yend=id)) +
  #目盛りを変数で指定
  scale_x_date(
    NULL,
    breaks=presidential$start,
    date_labels="'%y"
  )

#凡例の操作

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class))

base + theme(legend.position="left")
base + theme(legend.position="top")
base + theme(legend.position="bottom")



ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(se=F) +
  theme(legend.position="bottom") +
  #凡例の制御
  guides(
    color=guide_legend(
      nrow=1,
      override.aes=list(size=4)
    )
  )


ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()


ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10()


#スケールとしての色のパターンを設定
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=drv, shape=drv)) +
  scale_color_brewer(palette="Set1")


presidential %>%
  mutate(id=33+row_number()) %>%
  ggplot(aes(start, id, color=party)) +
  geom_point() +
  #プロットから線分を引く
  geom_segment(aes(xend=end, yend=id)) +
  #目盛りを変数で指定
  scale_colour_manual(
    values=c(Republican="red", Democratic="blue")
  ) +
  scale_x_date(
    NULL,
    breaks=presidential$start,
    date_labels="'%y"
  )


#スケールを色で表現する

df <- tibble(
  x=rnorm(10000), 
  y=rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  #軸の幅を揃える
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()


#Ex.1
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_color_gradient(low="white", high="red") +
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_gradient(low="white", high="red") +
  coord_fixed()

#Ex.2
#軸の名前
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_gradient(low="white", high="red") +
  scale_x_continuous("x軸") +
  scale_y_continuous("y軸") +
  coord_fixed()

#Ex.3
typeof(presidential$start + years(4))
typeof(presidential$start + years(0))
typeof(presidential$start)

mode(presidential$start + years(4))
mode(presidential$start)


presidential %>%
  mutate(interim=if_else(presidential$start + years(4) > presidential$end + years(0), 
                         presidential$end + years(0),
                         presidential$start + years(4)))


presidential %>%
  mutate(id=33+row_number()) %>%
  mutate(interim=if_else(presidential$start + years(4) > presidential$end + years(0), 
                         presidential$end + years(0),
                         presidential$start + years(4))) %>%
  ggplot(aes(start, id, color=party)) +
  geom_point() +
  #プロットから線分を引く
  geom_segment(aes(xend=end, yend=id), arrow=arrow(length=unit(2, "mm"))) +
  geom_segment(aes(xend=interim, yend=id), arrow=arrow(length=unit(2, "mm"))) +
  #目盛りを変数で指定
  scale_colour_manual(
    values=c(Republican="red", Democratic="blue")
  ) +
  scale_x_date(
    "西暦",
    breaks=presidential$start,
    date_labels="'%y",
    limits=c(as.Date("1950-1-1"), as.Date("2019-1-1"))
  ) +
  scale_y_continuous("歴代", 
                     breaks=seq(34, 46, by=2), 
                     limits=c(33, 45)) +
  # 囲いなしラベル
  # geom_text(aes(label=name),
  #           vjust="bottom",
  #           hjust="right"
  # ) +
  # 囲いつきラベル
  # geom_label(aes(label=name),
  #            nudge_y=0.5,
  #            show.legend=FALSE) +
  ggrepel::geom_label_repel(aes(label=name),
                            size=3,
                            nudge_y=0.5) +
  labs(title="米国歴代大統領")
  

#Ex.4
#凡例の透明度のみ変更する
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(color=cut), alpha=1/20) +
  theme(legend.position="bottom") +
  guides(
    color=guide_legend(
      nrow=1,
      override.aes=list(alpha=1)
    )
  )



ggplot(mpg, mapping=aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth() +
  coord_cartesian(xlim=c(5, 7), ylim=c(10, 30))

mpg %>%
  filter(displ>=5, displ<=7, hwy>=10, hwy<=30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth()


suv <- mpg %>% filter(class=="suv")
compact <- mpg %>% filter(class=="compact")


p1 <- ggplot(suv, aes(displ, hwy, color=drv)) +
  geom_point()

p2 <- ggplot(compact, aes(displ, hwy, color=drv)) +
  geom_point()


x_scale <- scale_x_continuous(limits=range(mpg$displ))
y_scale <- scale_y_continuous(limits=range(mpg$hwy))
col_scale <- scale_color_discrete(limits=unique(mpg$drv))


p1 <- ggplot(suv, aes(displ, hwy, color=drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

p2 <- ggplot(compact, aes(displ, hwy, color=drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

p1 + p2

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(se=F) +
  theme_classic()


ggsave("test.pdf")



library(lubridate)
library(tidyverse)
library(patchwork)
