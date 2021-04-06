
#ggplot

#1. 1

install.packages("tidyverse")
library(tidyverse)

#1. 2

#tbl
mpg

#ggplotの基本形
ggplot(mpg) +
  geom_point(aes(displ, hwy))

#Ex.1
ggplot(mpg)

#Ex.2
head(mtcars)
str(mtcars)
dim(mtcars)

#Ex.3
?mpg

#Ex.4
ggplot(mpg) +
  geom_point(aes(cyl, hwy))

#Ex.5
ggplot(mpg) +
  geom_point(aes(class, drv))


#1. 3

ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy, color=class))

#Ex.1
mpg
ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy), color="blue")

#Ex.2
str(mpg)

#Ex.3
?mpg
ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy, size=cty))

#Ex.4
ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy, size=cty, color=cty))

#Ex.5
mpg
ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy), shape=1, stroke=2)

#Ex.6
ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy, color=displ<5))


#1. 5
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_wrap(~ class, 2)

ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(.~ class)

ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(class ~ .)

ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(drv ~ cyl)


#Ex.1
#連続変数の値毎にファセットされる
mpg
ggplot(mpg) +
  geom_point(aes(cty, hwy)) +
  facet_wrap(~ displ)
  
#Ex.2
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(drv ~ cyl)

ggplot(mpg) +
  geom_point(aes(drv, cyl))

#Ex.3
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(. ~ cyl)

#Ex.4
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_wrap(~ class, nrow=2)

ggplot(mpg) +
  geom_point(aes(displ, hwy, color=class))

#Ex.5
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_wrap(~ class, nrow=3)
?facet_wrap

#Ex.6
#横長のチャートにできる
str(mpg)
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(manufacturer ~ year)


#1.6
ggplot(mpg) +
  geom_smooth(aes(displ, hwy))

ggplot(mpg) +
  geom_smooth(aes(displ, hwy, group=drv))

ggplot(mpg) +
  geom_smooth(aes(displ, hwy, linetype=drv, color=drv)) +
  geom_point(aes(displ, hwy, color=drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(data=filter(mpg, class=="subcompact"),
              se=FALSE)

#Ex.1
ggplot(mpg) +
  geom_boxplot(aes(x=drv, y=hwy))

ggplot(mpg) +
  geom_histogram(aes(x=hwy), bins=20)

ggplot(mpg) +
  geom_line(aes(x=displ, y=hwy))

#Ex.2
ggplot(mpg, aes(displ, hwy, color=drv)) +
  geom_point() +
  geom_smooth(se=FALSE)

#Ex.3
#凡例が消える
ggplot(mpg, aes(displ, hwy, color=drv)) +
  geom_point(show.legend=FALSE) +
  geom_smooth(se=FALSE, show.legend=FALSE)

#Ex.4
#seは信頼区間の表示有無
?geom_smooth()
ggplot(mpg, aes(displ, hwy, color=drv)) +
  geom_point() +
  geom_smooth(se=TRUE)

#Ex.5
#ベースのマップに二種類のレイヤーを表示
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth()

#レイヤーを二重に表示
ggplot() +
  geom_point(mpg, aes(displ, hwy)) +
  geom_smooth(mpg, aes(displ, hwy))

#Ex.6
#1
ggplot(mpg, aes(displ, hwy)) +
  geom_point(color="black", size=4) +
  geom_smooth(color="blue", se=F, size=1.5)

#2
ggplot(mpg, aes(displ, hwy)) +
  geom_point(color="black", size=4) +
  geom_smooth(aes(group=drv), color="blue", se=F, size=1.5)

#3
ggplot(mpg, aes(displ, hwy, color=drv)) +
  geom_point(size=4) +
  geom_smooth(se=F, size=1.5)

#4
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=drv), size=4) +
  geom_smooth(se=F, size=1.5)

#5
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=drv), size=4) +
  geom_smooth(aes(linetype=drv), se=F, size=1.5)
?geom_smooth

#6
#線(color)と塗りつぶし(fill)の色を選べるshape=21を使用する
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(fill=drv), color="white", shape=21, stroke=3, size=4)
?geom_point


#1.7
diamonds

#geom_histogram()は連続変数に用いる
#総数
ggplot(diamonds) +
  geom_bar(aes(cut))

?geom_bar

#比率
ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group=1))

#値
demo <- tribble(
  ~a, ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40)

ggplot(demo) +
  geom_bar(aes(a, b), stat="identity")


#Ex.1
ggplot(diamonds) +
  stat_summary(aes(cut, depth),
               fun.min=min,
               fun.max=max,
               fun=median)

ggplot(diamonds) +
  geom_pointrange(aes(x=cut, y=depth),
               fun.min=min,
               fun.max=max,
               fun = median,
               stat="summary")

#Ex.2
ggplot(demo) +
  geom_bar(aes(a, b), stat="identity")

ggplot(demo) +
  geom_col(aes(a, b))

#Ex.3
geom_bar() & stat_count()
geom_bin2d() & stat_bin_2d()
geom_boxplot() & stat_boxplot()
geom_contour() & stat_contour()
geom_count() & stat_sum()
geom_density() & stat_density()
geom_density_2d() & stat_density_2d()
geom_hex() & stat_hex()
geom_freqpoly() & stat_bin()
geom_histogram() & stat_bin()
geom_qq_line() & stat_qq_line()
geom_qq() & stat_qq()
geom_quantile() & stat_quantile()
geom_smooth() & stat_smooth()
geom_violin() & stat_violin()
geom_sf() & stat_sf()

#Ex.4
#フィッティング
ggplot(diamonds, aes(carat, price, color=cut)) +
  geom_point() +
  stat_smooth()

?geom_smooth

#Ex.5
#group=1は比率（..prop..）がグループ毎（cut）に計算されるのを防ぐ
#1は全体を表す定数（何でも良い）
)
ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group=1))

ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group='all'))

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=color, y=..prop.., group=1))


#1.8
#デフォルトのposition="stack"

ggplot(diamonds) +
  geom_bar(aes(x=cut, color=cut))

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=cut))

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=clarity))

#position="identity"では全ての棒グラフが重なる

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=clarity), position="identity")

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=clarity), position="identity", alpha=1/5)

ggplot(diamonds) +
  geom_bar(aes(x=cut, color=clarity), position="identity", fill=NA)

#position="fill"は100%で積み上げ

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=clarity), position="fill")

#position="dodge"は横に並べる

ggplot(diamonds) +
  geom_bar(aes(x=cut, fill=clarity), position="dodge")

#position="jitter"は微妙な乱数を加え、重なりを無くす

ggplot(mpg) +
  geom_point(aes(displ, hwy), position="jitter")

ggplot(mpg) +
  geom_point(aes(displ, hwy))


#Ex.1
ggplot(mpg, aes(cty, hwy)) +
  geom_point(position="jitter")

#Ex.2
ggplot(mpg, aes(cty, hwy)) +
  geom_jitter(width=5, height=5)

#Ex.3
ggplot(mpg, aes(cty, hwy)) +
  geom_count()

ggplot(mpg, aes(cty, hwy)) +
  geom_jitter()

#Ex.4
#デフォルトのpositionはdodge2
ggplot(mpg) +
  geom_boxplot(aes(manufacturer, hwy))


#1.9

#座標軸の入替

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot()

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot() +
  coord_flip()


#縦横比を整える

install.packages("maps")
library(maps)

nz <- map_data("nz")
head(nz)
ggplot(nz, aes(long, lat, group=group)) +
  geom_polygon(fill="white", color="black")

ggplot(nz, aes(long, lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_quickmap()

bar <- ggplot(diamonds) +
          geom_bar(aes(x=cut, fill=cut), show.legend=F, width=1) +
          labs(x=NULL, y=NULL) +
          theme(aspect.ratio=1)

bar + coord_flip()
bar + coord_polar()


#Ex.1
diamonds
ggplot(diamonds) +
  geom_bar(aes(x='', fill=cut), alpha=0.5) +
  coord_polar(theta='y') +
  labs(x=NULL, y=NULL)

#Ex.2
#タイトル、サブタイトル、キャプション、軸名を設定

#Ex.3
library(mapproj)
#coord_mapはメルカトル図法、quick_mapは簡易近似

world <- map_data("world")
ggplot(world, aes(long, lat, group=group)) +
  geom_polygon(fill="white", color="black")

ggplot(world, aes(long, lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_quickmap()

ggplot(world, aes(long, lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_map()

#Ex.4
#軸の縦横比を揃える
ggplot(mpg, aes(cty, hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed() +

