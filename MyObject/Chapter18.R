


# 観測データの確認
ggplot(sim1, aes(x, y)) +
  geom_point()

#各種予測モデル（線形ファミリー）の予測集合
models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

# 観測データと予測
ggplot(sim1, aes(x, y)) +
  geom_abline(
    aes(intercept=a1, slope=a2),
    data=models, alpha=1/4
  ) +
  geom_point()

#モデルの予測値を出力
model1 <- function(a, data){
  a[1] + data$x * a[2]
}

#あるモデルの予測値
model1(c(7, 5), sim1)

nrow(sim1)

#あるモデルの予測値と実測値の偏差二乗平均の平方根
#モデルの評価
measure_distance <- function(mod, data){
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}

measure_distance(c(7, 1.5), sim1)

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models[1, ]

sim1_dist(models[1, ][[1]], models[1, ][[2]])

#乱数で生成した全てのモデルについて、距離を計測
models <- models %>%
  mutate(dist=map2_dbl(a1, a2, sim1_dist))

nrow(models)

#距離が小さいモデルを表示
ggplot(sim1, aes(x, y)) + 
  geom_point(size=2, color="grey30") +
  geom_abline(
    aes(intercept=a1, slope=a2, color=-dist),
    data=filter(models, rank(dist) <= 10)
  )
  
#距離が小さいモデルのパラメータを強調
ggplot(models, aes(a1, a2)) +
  geom_point(
    data=filter(models, rank(dist) <= 10),
    size=4, color="red"
  ) +
  geom_point(aes(colour=-dist))


#任意の範囲のパラメータについて距離を計測
grid <- expand.grid(
  a1=seq(-5, 20, length=25),
  a2=seq(1, 3, length=25)) %>%
  mutate(dist=map2_dbl(a1, a2, sim1_dist))

#距離が小さいモデルのパラメータを強調  
grid %>%
  ggplot(aes(a1, a2)) +
  geom_point(
    data=filter(grid, rank(dist) <= 10),
    size=4, colour="red") +
  geom_point(aes(color=-dist))
  
#距離が小さいモデルを表示、グリッドから
ggplot(sim1, aes(x, y)) +
  geom_point(size=2, color="grey30") +
  geom_abline(
    aes(intercept=a1, slope=a2, color=-dist),
    data=filter(grid, rank(dist)<=10)
  )

#最小化
model1 <- function(a, data){
  a[1] + data$x * a[2]
}
measure_distance(c(7, 1.5), sim1)
#初期値、目的関数、データ
best <- optim(c(0, 0), measure_distance, data=sim1)
best$par

ggplot(sim1, aes(x, y)) +
  geom_point(size=2, color="grey30") +
  geom_abline(intercept=best$par[1], slope=best$par[2])

sim1_mod <- lm(y~x, data=sim1)
coef(sim1_mod)

#Ex.1
#rt: t分布からの乱数
sim1a <- tibble( 
  x = rep(1:10, each=3),
  y = x * 1.5 + 6 + rt(length(x), df=2)
)

c4 <- coef(lm(y~x, data=sim1a))

g4 <- ggplot(sim1a, aes(x, y)) +
  geom_point(size=3, color="grey30") +
  geom_abline(intercept=c4[1], slope=c4[2]) +
  xlim(0, 10) + ylim(0, 25)

View(sim1t)
library(patchwork)
g1 + g2 + g3 + g4 + plot_layout(ncol=2)

ggplot(sim1a, aes(x, y)) +
  geom_abline(intercept=c1[1], slope=c1[2]) +
  geom_abline(intercept=c2[1], slope=c2[2]) +
  geom_abline(intercept=c3[1], slope=c3[2]) +
  geom_abline(intercept=c4[1], slope=c4[2]) +
  xlim(0, 10) + ylim(0, 25)


#複数のtibbleを連結させる

sim_df <- function(i) {
  tibble(x = rep(1:10, each = 3),
         y = x * 1.5 + 6 + rt(length(x), df = 2),
         id = i)
}

sim_all <- 1:20 %>%
  map_df(sim_df)

nrow(sim_all)

ggplot(sim_all, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = F) +
  facet_wrap( ~id, ncol = 5)


#Ex.2
#異常値を入れたデータ
sim1b <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rcauchy(length(x))
)


# 偏差二乗平均の平方根で距離を定義
measure_distance1 <- function(mod, data){
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}

#絶対値の平均値で距離を定義
measure_distance2 <- function(mod, data){
  diff <- data$y - model1(mod, data)
  mean(abs(diff))
}

best1 <- optim(c(0, 0), measure_distance1, data=sim1b)

best2 <- optim(c(0, 0), measure_distance2, data=sim1b)


best2$par



ggplot(sim1b, aes(x, y)) +
  geom_point(size=2, color="grey30") +
  geom_abline(intercept=best1$par[1], slope=best1$par[2], color="red") +
  geom_abline(intercept=best2$par[1], slope=best2$par[2], color="blue")

#Ex.3
#a[1]とa[3]が無差別となり、初期値に依存して最適解が変わる

model2 <- function(a, data){
  a[1] + data$x * a[2] + a[3]
}

# 偏差二乗平均の平方根で距離を定義
measure_distance3 <- function(mod, data){
  diff <- data$y - model2(mod, data)
  sqrt(mean(diff^2))
}

optim(c(0, 0, 0), measure_distance3, data=sim1a)$par
optim(c(1, 0, 0), measure_distance3, data=sim1a)$par



test <- tibble(x=sample(1:100,10, replace=T),
       y=sample(1:100,10, replace=T))

data_grid(test, x)

library(tidyverse)
library(modelr)

#説明変数の取る値を抽出
grid <- sim1 %>%
  data_grid(x)

#モデルの推定
sim1_mod <- lm(y~x, data=sim1)

#モデルの予測値を列に追加
grid <- grid %>%
  add_predictions(sim1_mod)

ggplot(sim1, aes(x)) +
  geom_point(aes(y=y)) +
  geom_line(
    aes(y=pred),
    data=grid,
    colour="red",
    size=1
  )

#残差の列を追加
sim1 <- sim1 %>%
  add_residuals(sim1_mod)

#残差の分布
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth=0.5)

#残差のプロット
g1 <- ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h=0) +
  geom_point() +
  ylim(-5, 5)


#Ex.1
#データロード
data(sim1)
sim2 <- sim1

#モデル推定（適合）
sim2_mod <- loess(y~x, sim2)

#説明変数のグリッド
grid2 <- sim2 %>%
  data_grid(x)

#予測値の列を追加
grid2 <- grid2 %>%
  add_predictions(sim2_mod)

#予測残差の列を追加
sim2 <- sim2 %>%
  add_residuals(sim2_mod)


#予測値の形状
ggplot(sim2, aes(x)) +
  geom_point(aes(y=y)) +
  geom_line(
    aes(y=pred),
    data=grid2,
    color="red",
    size=0.5
  ) +
  geom_smooth(
    aes(y=y),
    method="lm",
    se=F
  )

sum(sim1$resid^2)
sum(sim2$resid^2)

?loess

#予測残差の分布
ggplot(sim2, aes(resid)) +
  geom_freqpoly(binwidth=0.5)
  
#予測残差のプロット
g2 <- ggplot(sim2, aes(x, resid)) +
  geom_ref_line(h=0) +
  geom_point() +
  ylim(-5, 5)
  
library(patchwork)
g1 + g2 + plot_layout(ncol=2)

sim2


#Ex.2
#gather、spreadは複数モデルに対応

grid2 %>%
  add_predictions(sim2_mod)

grid2 %>%
  gather_predictions(sim1_mod, sim2_mod)

grid2 %>%
  spread_predictions(sim1_mod, sim2_mod)


#Ex.3
#ggplot2
?geom_ref_line


#データセットの作成
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)

#フォーミュラに基づいてデータを表現
#必要に応じて推定した関数に代入して使用

#切片と説明変数のセットに変換
model_matrix(df, y~x1)

#切片なしの場合
model_matrix(df, y~x1-1)


#説明変数がカテゴリカル変数の場合
df <- tribble(
  ~sex, ~response,
  "male", 1,
  "female", 2,
  "male", 1
)

#カテゴリカル変数は0、1に変換される
model_matrix(df, response~sex)

ggplot(sim2) +
  geom_point(aes(x, y))

#モデル推定
#カテゴリカル変数をそのまま説明変数として扱える
mod2 <- lm(y~x, data=sim2)

#グリッドに対して予測値を算出
grid <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2)

ggplot(sim2, aes(x)) +
  geom_point(aes(y=y)) +
  geom_point(
    data=grid,
    aes(y=pred),
    color="red",
    size=4
  )

tibble(x="e") %>%
  add_predictions(mod2)

sim3

ggplot(sim3, aes(x1, y)) +
  geom_point(aes(color=x2))

mod1 <- lm(y~x1+x2, sim3)
mod2 <- lm(y~x1*x2, sim3)

#複数のモデルによる予測値を行展開
grid <- sim3 %>%
  data_grid(x1, x2) %>%
  gather_predictions(mod1, mod2)

ggplot(sim3, aes(x1, y, color=x2)) +
  geom_point() +
  geom_line(data=grid, aes(y=pred)) +
  facet_wrap(~model)

#複数のモデルによる残差を行展開
sim3 <- sim3 %>%
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, color=x2)) +
  geom_point() +
  facet_grid(model~x2)


#連続変数同士の交互作用
mod1 <- lm(y~x1+x2, sim4)
mod2 <- lm(y~x1*x2, sim4)

#範囲を5つに分割し、グリッドとする
#複数のモデルについて予測値を出力
grid <- sim4 %>%
  data_grid(
    x1=seq_range(x1, 5),
    x2=seq_range(x2, 5)
  ) %>%
  gather_predictions(mod1, mod2)

#グリッドを丸める
seq_range(c(0.0123, 0.923423), n=5, pretty=T)
seq_range(c(0.0123, 0.923423), n=5)

x1 <- rcauchy(100)

summary(x1)

#端を切り捨てる
seq_range(x1, 5)
seq_range(x1, 5, trim=0.1)
seq_range(x1, 5, trim=0.25)

seq_range(x1, 5, trim=0.5)

x2 <- c(0, 1)

#端を拡大する
seq_range(x2, 5)
seq_range(x2, 5, expand=0.1)
seq_range(1:5, 5, expand=0.1)

#x1、x2の水準に応じて傾きが異なる
ggplot(grid, aes(x1, x2)) +
  geom_tile(aes(fill=pred)) +
  facet_wrap(~model)

ggplot(grid, aes(x1, pred, color=x2, group=x2)) +
  geom_line() +
  facet_wrap(~model)

ggplot(grid, aes(x2, pred, color=x1, group=x1)) +
  geom_line() +
  facet_wrap(~model)

df <- tribble(
  ~y, ~x,
  1, 1,
  2, 2,
  3, 3
)

#モデルにおける説明変数の確認
model_matrix(df, y~x^2+x)
model_matrix(df, y~I(x^2)+x)
model_matrix(df, log(y)~sqrt(x))


#線形和に変換された変数が表示される
#無限多項和
model_matrix(df, y~poly(x,2))

#スプライン関数
model_matrix(df, y~ns(x, 2))

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()

mod1 <- lm(y ~ ns(x, 1), sim5)
mod2 <- lm(y ~ ns(x, 2), sim5)
mod3 <- lm(y ~ ns(x, 3), sim5)
mod4 <- lm(y ~ ns(x, 4), sim5)
mod5 <- lm(y ~ ns(x, 5), sim5)

grid <- sim5 %>%
  data_grid(x=seq_range(x, n=50, expand=0.1)) %>%
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred="y")

ggplot(sim5, aes(x, y))+
  geom_point() +
  geom_line(data=grid, color="red") +
  facet_wrap(~model)


#Ex.1
#変数が一つ増えるだけで実質的には変わりがない

data(sim2)
summary(sim2)
View(sim2)

#要約統計量
do.call(rbind, tapply(sim2$y, sim2$x, summary))

#変数変換
model_matrix(sim2, y~x)
model_matrix(sim2, y~x-1)

#モデル推定
mod2 <- lm(y~x, data=sim2)
mod2r <- lm(y~x-1, data=sim2)

#予測
grid <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2)

gridr <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2r)

#Ex.2
#2つのカテゴリカル変数
data(sim3)
#2つの連続変数
data(sim4)

#ともに変数が独立な場合と交互作用がある場合をモデル化した

#x1は12種の離散変数、x2は水準が4つのカテゴリカル変数として処理
View(model_matrix(sim3, y~x1+x2))

#x1は12種の離散変数、x2は水準が4つのカテゴリカル変数、両者の積となる変数
View(model_matrix(sim3, y~x1*x2))

#x1、x2はともに10種の離散変数として処理
View(model_matrix(sim4, y~x1+x2))

#10種の離散変数x1、x2と両者の積からなる変数として処理
View(model_matrix(sim4, y~x1*x2))

#カテゴリカル変数を用いると、変数の数が格段に増えるため注意

#Ex.3
#フォーミュラを関数に変換する
#フォーミュラはy~xの形式
#フォーミュラに応じて説明変数を変換するmodel_matrixを記述する
#非説明変数を変換する部分も
#パラメータ推定はフォーミュラに依存しない
#x1、x2、y列を持つtibbleのインプットを前提


#y~x1+x2
sim3
sim4

mod_l(sim4)
model_matrix(sim4, y~x1+x2)

mod_l <- function(tbl) {
  res <- tibble(
    Int = 1,
    y = tbl$y
  )
  if (is.numeric(tbl$x1)) {
    res$x1 <- tbl$x1
  } else {
    vars <- levels(tbl$x1)
    for(i in vars[-1]){
      var_name <- paste0("x1", i)
      res[[var_name]] <- as.numeric(tbl$x1 == i)
    }
  }
  if (is.numeric(tbl$x2)) {
    res$x2 <- tbl$x2
  } else {
    vars <- levels(tbl$x2)
    for(i in vars[-1]){
      var_name <- paste0("x2", i)
      res[[var_name]] <- as.numeric(tbl$x2 == i)
    }
  }
  res %>% select(-y)
}


#y~x1*x2
sim3
sim4

model_matrix(sim3, y~x1*x2)
model_matrix(sim4, y~x1*x2)

mod_c <- function(tbl) {
  res <- mod_l(tbl)
  cnm <- colnames(res)
  for (i in cnm[str_detect(cnm, "^x1")]) {
    for (j in cnm[str_detect(cnm, "^x2")]) {
      var_name <- paste(i, j, sep="_")
      res[var_name] <- res[i] * res[j]
    }
  }
  res
}  

mod_c(sim3)
mod_c(sim4)


#Ex.4

mod1 <- lm(y~x1+x2, sim4)
mod2 <- lm(y~x1*x2, sim4)

res4 <- sim4 %>%
  gather_residuals(mod1, mod2)

ggplot(res4, aes(x=resid)) +
  geom_histogram() +
  facet_grid(model~x2)
         
ggplot(res4, aes(x=resid)) +
  geom_histogram() +
  facet_wrap(~model)

ggplot(res4, aes(x=resid)) +
  geom_histogram() +
  facet_wrap(~model)

ggplot(res4, aes(x=resid)) +
  geom_freqpoly(aes(color=model))

ggplot(res4, aes(x=abs(resid))) +
  geom_freqpoly(aes(color=model))


nobs(mod1)




# tidyverseにmodelrは入っていない
library(tidyverse)
library(modelr)
library(splines)

search()
