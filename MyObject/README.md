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

* ベクトルのパース  
型別に読み込みの関数がある  
parse_logical、parse_integer、parse_double、parse_number、parse_character、parse_factor、parse_datetime、parse_date、parse_time
~~~
# 数値のパース
parse_double("1,23", locale=locale(decimal_mark=",")
# parse_number
parse_number("20%") # 20だけを取り出す
parse_number("123.456", locale=locale(grouping_mark=".")

# 文字のパース
デフォルトはUTF-8
parse_character(x, locale=locale(encoding="Shift-JIS") 

# ファクターのパース  
parse_factor(x, levels=c("a", "b"))

#タイムシリーズのパース
デフォルトはISO8601（年、月、日、時、分、秒の順）
parse_datetime("2010-10-01T2010")
parse_date("2010-10-01")
parse_time("20:10:01")
parse_date(x, "特定のフォーマット")
~~~

* ファイルのパース
~~~
# 型を指定して読み込み
read_csv("challenge.csv",
  col_types = cols(
    x = col_double(),
    y = col_date()
  ))
~~~

* ファイルへの書き出し  
~~~
write_csv(x, "x.csv") # csvの場合、型情報は失われる
write_rds(x, "x.rds") # RDS形式は型を維持する
~~~


* Tips  
guess_encoding(charToRaw(x)): バイト列から符号化方式を推定  
guess_parser(x): 型を推定  
type_convert(df): 文字列型のdfから、型推定を行いtibbleに変換  


### ９章　tidyrによるデータ整理  

各変数（カテゴリカル変数を含む）が列に、各データが行に並んだデータを基本データ表現とする  

* データの展開（spread）と集約（gather）  
~~~
stocks %>%
  spread(key=year, value=return) %>% 　　　# year列の値を列名として、return列を展開
  gather("year", "return", `2015`:`2016`)　# 2015から2016までの列名をyear列、値をreturn列として集約
~~~

* データの分割（separate）と接合（unite）  
~~~
# rate列をcases列とpopulation列に分割する
table %>%
  separate(rate, into=c("cases", "population"), remove=T)

# cases列とpopulation列をrate列にまとめる
table %>%
  unite(rate, cases, population, sep="/", remove=F)
~~~

* 例  
~~~
who %>%
  gather(new_sp_m014:newrel_f65, key="key", value="cases", na.rm=T) %>%
  mutate(key=stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "type", "sexage"), sep="_") %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep=1)
~~~

* Tips  
complete(tbl, a, b): a列とb列の値の全ての組み合わせの行を作る  
fill(a): NAを直前の値で補完  


### １０章　dplyrによる関係データ  

データ間のリンクを扱う  
主キー: 表の中でデータを一意に決定する変数の組み合わせ  
外部キー: 他の表のデータとリンクする変数  

* 更新ジョイン  
表に他の表のデータを加える処理  
~~~
# 内部ジョイン
tbl1 %>% inner_join(tbl2, by=c('a', 'b', 'c'='x'))
# 左ジョイン
tbl1 %>% left_join(tbl2, by=c('a', 'b', 'c'='x'))
# 右ジョイン
tbl1 %>% right_join(tbl2, by=c('a', 'b', 'c'='x'))
# 外部ジョイン
tbl1 %>% full_join(tbl2, by=c('a', 'b', 'c'='x'))
~~~

* フィルタジョイン  
結合を用いて表からデータを抽出する  
~~~
# マッチするデータを残す
tbl1 %>% semi_join(tbl2, by=c('a', 'b', 'c'='x'))
# マッチしないデータを残す
tbl1 %>% anti_join(tbl2, by=c('a', 'b', 'c'='x'))
~~~

* 集合演算  
~~~
intersect(df1, df2) # 共通の行を返す
union(df1, df2)     # 和集合となる行を返す
setdiff(df1, df2)   # df1にあるがdf2にない行を返す
~~~


### １１章　stringrによる文字列  

stringrパッケージ: 42関数、stringiパッケージ: 234関数  
stringrで無いものは、stringiで探す  

* 文字列操作  
~~~
str_length(c('abc', 'def'))             # 各文字列の長さ
str_c('x', 'y', sep=', ')               # 文字列を連結
str_c(c('x', 'y', 'z'), collapse=', ')  # 各文字列を連結
str_sub('Apple', 1, 3)                  # 文字列の指定の範囲を抽出
str_to_lower("ABC")                     # 小文字に変換







~~~





