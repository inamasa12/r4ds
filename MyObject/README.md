# R ではじめるデータサイエンス

## まえがき  
データサイエンスのプロセスは、①データのインポート、②データの整理から始まる  
その後、③変換、④可視化、⑤モデルの作業を繰り返す  
③～⑤の結果について、⑥コミュニケーションを行い、必要な場合は再度のデータサイエンスを行う  
変換では、データの整形、要約統計量の算出を行う  
可視化は、新たな発見を得るためのプロセス  
モデルは、何らかの定式化のこと  
整理と変換を合わせて、ラングリングと呼ぶ  
データサイエンスの目的は、仮説生成（データ探索）と仮説確認（検定）である  
この目的のために、上記プロセスを繰り返す  

## 第Ⅰ部　探索  
１章は可視化、３章は変換、５章は可視化と変換を用いた探索を学ぶ  

### １章　ggplot2 によるデータ可視化  
ggplot(data)で空グラフを作る  
aesは変数とエステティック属性をマッピングする  
エステティック属性には座標軸（x、y）、color、size、shape、stroke（マーカーの枠線）、fill等がある  
~~~
install.packages("tidyverse")
library(tidyverse)

ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy, color=class))
~~~
グラフ全体についてエステティック属性を指定したい場合は、aesの外側で指定する  
~~~
ggplot(mpg) +
  geom_point(aes(x=displ, y=hwy), color="blue")
~~~
カテゴリ別にグラフ化  
* 一変数  
~~~
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_wrap(~ class, 2)
~~~
* 二変数  
~~~
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(drv ~ cyl)
~~~
複数のグラフを表示  
~~~
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth()
~~~
データを要約した棒グラフ  
~~~
#総数
ggplot(diamonds) +
  geom_bar(aes(cut))
#比率
ggplot(diamonds) +
  geom_bar(aes(x=cut, y=..prop.., group=1))
~~~
データをそのまま表示する棒グラフ  
~~~
ggplot(demo) +
  geom_bar(aes(a, b), stat="identity")
~~~
positionの内、stack（デフォルト）は積み上げ表示、identityは重ねて表示、fillは100%積み上げ表示、dodgeは並べて表示、jitterは乱数を加え重なりを無くす  
coord_flip(): 座標軸の入替、coord_quickmap(): 縦横比の調整、coord_polar(): 極座標の使用、coord_fixed(): 縦横比を揃える  
どのようなグラフでもggplotの7つの引数（データ、geom関数、マッピング、stat、position、coord、facet）の組み合わせで表現できる  


### ２章　ワークフロー  
ショートカット  
Alt + shift + k: ショートカットキーリスト  
Ctrl + shift + .: タブ  
Ctrl + Tab: 次のタブ  
Ctrl + shift + Tab: 前のタブ  
ctrl + 2: console  


### ３章　dplyrによるデータ変換  
1. filter
行の選択、抽出  
~~~
filter(tibble, col %in% c(3, 6))
filter(tibble, !(col1 == 3 | col2 == 6)
filter(df, is.na(col))
~~~

1. arrange  
行を整列  
~~~
arrange(df, col1, desc(col3))
~~~

1. select  
列を選択、抽出  
starts_with、 ends_with、condain、matches、everything 等の抽出を補助するヘルパー関数がある  
~~~
select(df, col1, col3, col7)
select(df, -(col5:col8))
~~~

1. rename  
列名の変更  
~~~
rename(df, new_name1 = old_name1, new_name2 = old_name2)
~~~

1. mutate  
列同士の演算  
lead、lag、min_rank、row_number、dense_rank、percent_rank、cume_dist、ntile等の列作成関数がある  
~~~
#列を追加
mutate(flights_sml, gain = arr_delay - dep_delay, hours = air_time / 60, gain_per_hour = gain / hours)
#新しい列を作成
transmute(flights_sml, gain = arr_delay - dep_delay, hours = air_time / 60, gain_per_hour = gain / hours)
~~~

1. group_by & summarize  
グループ別に集計  
各種ヘルパー関数が存在、min(x)、max(x)、quantile(x, 0.4)、first(x)、nth(x, 2)、last(x)  
~~~
group_by(tibble, col1, col3) %>%
    summarize(n=n(),
                cnt=sum(!is.na(col4), na.rm=T),
                mean=mean(col6, na.rm=T),
                med=median(col6, na.rm=T),
                sd=sd(col6, na.rm=T),)
~~~

* Tips  
View(tibble): ビューアーで表示  



