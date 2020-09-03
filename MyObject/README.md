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


### ２章　ワークフロー： 基本  
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
filter(df, between(col1, 3, 5))
~~~

1. arrange  
行を整列  
~~~
arrange(df, col1, desc(col3))
~~~

1. select  
列を選択、抽出  
starts_with、 ends_with、condain、matches、everything、等の抽出を補助するヘルパー関数がある  
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
lead、lag、min_rank、row_number、dense_rank、percent_rank、cume_dist、ntile、ifelse等の列作成関数がある  
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

group_by(tibble, col2, col4) %>%
    summarize(dist=n_distinct(col5))   #一意の個数をカウント

group_by(tibble, col2, col4) %>%
    mutate(rank=min_rank(col3))   #グループ別にランキング

group_by(tibble, col2, col4) %>%
    mutate(ratio=col3/sum(col3)) %>%
    filter(ratio > 0.5) #グループ別に演算、対象のグループに属するデータ抽出

tibble %>% count(col2, wt=col4)   #col2のグループ別にカウント（重みはcol4）
~~~

* Tips  
View(tibble): ビューアーで表示  


### ４章　ワークフロー： スクリプト  

コード作成にスクリプト、ショートカットキーを使用しましょう  


### ５章　探索的データ分析（Exploratory Data Analysis）  

変数の変動、共変動を把握する（分布の可視化）  
基本はヒストグラム  
複数変数の比較には箱ひげ図が便利  

~~~
# カテゴリカル変数の分布
ggplot(tibble) 
    + geom_bar(aes(x=cat))

# 連続変数の分布
ggplot(tibble, aes(x=val)) 
    + geom_histogram(binwidth=0.1)
    + coord_cartesian(ylim=c(0, 50)) # 範囲のフォーカス

# 複数グループの度数分布（連続変数&カテゴリカル変数）
ggplot(tibble, aes(x=val, color=cat)) 
    + geom_freqpoly(binwidth=0.1)

# 複数グループの密度分布（連続変数&カテゴリカル変数）
ggplot(tibble, aes(x=val, y=..density..)) 
    + geom_freqpoly(aes(color=cat), binwidth=0.1)

# 複数グループの箱ひげ図（連続変数&カテゴリカル変数）
ggplot(tibble) +
  geom_boxplot(
    aes(x=reorder(cat, val, FUN=median), # reorderで変数の表示順序を指定（この場合はvalの中央値で昇順）
        y=val)) +
  coord_flip() # 軸の入替
 
 # ヒートマップ（2つのカテゴリカル変数）
 diamonds %>%
  count(color, cut) %>%
  ggplot(aes(color, cut)) +
    geom_tile(aes(fill=n))


# 連続変数同士の分布
1. 透明度で濃淡をつける
ggplot(diamonds) +
  geom_point(aes(x=carat, y=price), alpha=0.1)

2. 区間度数
* 長方形
ggplot(diamond) +
  geom_bin2d(aes(x=carat, y=price))
* 六角形
ggplot(smaller) +
  geom_hex(aes(x=carat, y=price))

3. 連続変数を区分
ggplot(diamonds, aes(x=price)) +
  geom_freqpoly(aes(color=cut_width(carat, 1)))
~~~

* Tips  
cutwidth(col, 0.5): 区分毎にカウント  


### ６章　ワークフロー  

スクリプトを残すこと  
相対パスを使用すること  
プロジェクトを利用すること  


## 第Ⅱ部　データラングリング  

７章はtibble、８章はデータインポート、９章はデータの前処理を学ぶ  
１０章はデータのリンク、１１章は文字列操作、１２章はカテゴリカルデータの取り扱い、１３章は時系列データを学ぶ  

### ７章　tibbleのtibble  
~~~
# tibbleの作成

as_tibble(df)

tibble(
  x=1:5,
  y=1,
  z=x^2+y
)

# 要素の抽出
df$x
df[["x"]]
df[[1]]
~~~

### ８章　readrによるデータインポート  
* ファイルのロード  
~~~
read_csv("file.csv", skip=2
                    , comment="#"
                    , col_names=FALSE # 列名を入れない場合
                    , col_names=c("x", "y", "z") # 列名を指定する場合
                    , na=".")
~~~






