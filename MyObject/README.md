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
~~~                   str_count(words, "[aeiou]")                    # マッチの数を数える

str_length(c('abc', 'def'))             # 各文字列の長さ
str_c('x', 'y', sep=', ')               # 文字列を連結
str_c(c('x', 'y', 'z'), collapse=', ')  # 各文字列を連結
str_sub('Apple', 1, 3)                  # 文字列の指定の範囲を抽出
str_to_lower(upper, title)("ABC")       # 小文字（大文字、先頭の文字だけ大文字）に変換
str_sort(x, locale='en')                # ロケールを設定して文字列をソート
str_trim(' abc ')                       # 両端の空白を取り除く
str_pad('abc', 5, pad='$')              # 端に特定の文字を加える
str_split(boundary("word"), n=20, simplify=T)  # 文字列を分割する
~~~

* 文字列マッチ
マッチは必ず重ならない
特定の文字列を抽出するならextractかmatchだが、matchが柔軟  
~~~
str_view(_all)(c("abc","a.c", "bef"), "a\\.c") # 正規表現とのマッチをビューで確認
str_count(words, "[aeiou]")                    # マッチの数を数える
str_detect(x, "e")                             # マッチがある場合はTRUE、ない場合はFALSEを返す
str_extract(_all)(sentences, "^.+?\\b")        # マッチした部分を抽出する
str_match(_all)(noun, "(a|the) ([^ ]+)")       # マッチした部分とその要素を抽出する
str_replace(_all)(x, "[aeiou]", "-")           # マッチした部分を置き換える
str_replace(_all)(x, c("1"="a", "2"="b", "3"="c"))
~~~

* 正規表現  
regex("正規表現", ignore_case=T)で細かい指定ができる
fixed()はバイト列で比較するため速い  
coll()はロケールの標準照合規則を用いてマッチする  

* Tips  
identical(a, b): オブジェクトが同じかどうかを判定する  
seq_along(a): 同じ長さのシーケンスを生成  
apropos("単語"): 関数等のオブジェクトを探す
dir(pattern="\\.R"): カレントディレクトリのファイルを探す  
dir("../data", pattern="\\.csv"): カレントディレクトリ下のcsvファイルを探す 

### １２章　forcatsでファクタ  

forcatsパッケージを使用  

* ファクタの作成  
~~~
#水準集合、希望の順に並べて作成
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

#factorの作成
y1 <- factor(x1, levels=month_levels)

#出現順にレベルを設定
fct_inorder(z1)

#レベルを表示
levels(a1)
~~~

* ファクタの操作
~~~
#ファクタの順序を他の変数の要約値（この場合は中央値）で並び替え
relig %>%
  mutate(relig=fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) + 
  geom_point()

#特定の値を先頭に置く 
ggplot(rincome, aes(age, fct_relevel(rincome, "Not applicable"))) + 
  geom_point()

#ageの最大値（右端）のpropの値で並び変える
ggplot(by_age,
       aes(age, prop, color=fct_reorder2(marital, age, prop))
       ) +
  geom_line() +
  labs(color="maital")
  
#度数で並び変えて、逆順にする
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

#ファクタ名を変える
gss_cat %>%
  mutate(partyid=fct_recode(partyid,
                            "Republican, strong"   ="Strong republican",
                            "Republican, weak"     ="Not str republican",
                            "Independent, near rep"="Ind,near rep",
                            "Independent, near dem"="Ind,near dem",
                            "Democrat, weak"       ="Not str democrat",
                            "Democrat, strong"     ="Strong democrat")) %>%
  count(partyid)


#ファクタをまとめる①
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat"))) %>%
  count(year, partyid)

#ファクタをまとめる②、最小グループを順にOtherにまとめてn個にする
gss_cat %>%
  mutate(relig=fct_lump(relig, n=10)) %>%
  count(relig, sort=T)
~~~

* Tips  
unique(x): 出現順に一意の集合を作成  


### １３章　lubridateによる日付と時刻

* 日付時刻オブジェクトの作成  
~~~
today() # 日付
now() # 日付時刻

# 数字や文字列から変換
ymd(20170131)
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

# 日付要素から作成
make_datetime(year, month, day, hour, minute)

# 日付オブジェクトの変更
as_datetime(today())
as_date(now())
~~~

* 日付要素の取得  
~~~
year(datetime)
month(datetime)
mday(datetime)
yday(datetime)
wday(datetime)
~~~

* 日付の操作  
~~~
floor_date(dep_time, "week") # 切り捨て
round_date(dep_time, "week") # 四捨五入
ceiling_date(dep_time, "week") # 切り上げ

# 日付要素の変更
month(datetime) <- 1
hour(datetime) <- hour(datetime) + 1
update(datetime, year=2020, month=2, mday=2, hour=2)
~~~

* タイムスパン  
~~~
#デュレーション ⇒ 秒単位の時間区間
dyears(1)
ddays(1)

#ピリオド ⇒ 一単位の時間区間
days(1)
years(4)

# インターバル ⇒ 特定の時間区間
today() %--% year_after
~~~

* タイムゾーン  
タイムゾーンは属性の一つで表示をコントロールする  
~~~
with_tz(x4, tzone="Australia/Lord_Howe") # タイムゾーンの変更 ⇒ 時刻は変わらない
force_tz(x4, tzone="Australia/Lord_Howe") # 時刻をそのままにタイムゾーンを変更 ⇒ 時刻は変わる
~~~

## 第Ⅲ部　プログラム  

パイプ、関数、データ構造、イテレーション  

### １４章　magrittrでパイプ  

* パイプ（%>%）を使う際の注意点
非明示に現在の環境を使う関数（assign等）や遅延評価を行う関数（tryCatch、try等）を使用しない  
ステップが長くなる場合は中間オブジェクトを作る  
2つ以上のオブジェクトを組み合わせる必要がある場合  
線形構造であること  
~~~
# %T>%は出力を複数行う
rnorm(100) %>%
  matrix(ncol=2) %T>%
  plot() %>% # 一つ目の出力先
  str() # 二つ目の出力先

# %$%はデータフレームの各列をベクトルとして扱う
mtcars %$%
  cor(disp, mpg)
~~~

* Tips  
pryr::object_size(x, y): オブジェクトサイズを表示  


### １５章　関数  

コードブロックを3回以上コピー＆ベースとするなら、関数化するべき  
~~~
# 例
rescale01 <- function(x) {
  rng <- range(x, na.rm=T)
  (x-rng[1]) / (rng[2]-rng[1])
}
~~~

一般に関数名には動詞、引数には名詞を用いる  
関数名を複数の単語で作る場合は、アンダースコアでつなぐ  
関連の関数は接頭辞を共通化する  

注釈は#を用い、「なぜ」を説明し、「何」や「どのように」等、コードを読めば分かることは記載しない  
ブロック毎に注釈を付けると良い  

条件文において、||と&&は横着評価で、||は最初のTRUEでTRUEを返し、&&は最初のFALSEでFALSEを返す  
|と&はベクトルの論理演算子であり、条件には使用しない  
any()、all()、identical()は、単一のTRUEもしくはFALSEを返すため条件には便利  
else ifやswitchで複合条件を扱える  

制約条件は関数のトップに置く  
~~~
if(!is.na(logical(na.rm))){
  stop("`na.rm` must be logical")
}
stopifnot(is.logical(na.rm))
~~~

その他  
~~~
# 複数の引数　　
function(...){}
# 戻り値（単純な解を早めに返す場合に用いる）
return(0)
# 表示しない戻り値（パイプ可能な関数とするにはオブジェクトを必ず返す必要がある
invisible(df)
~~~

### １６章　ベクトル  

ベクトルには、アトミックベクトルとリストがある  

* アトミックベクトル  
型（typeof）と長さ（length）の属性を有する  
要素の種類に応じて、論理ベクトル、数値ベクトル、文字ベクトル、複素数ベクトル、バイナリベクトルの6種類がある  
as.logical、as.integer、as.double、as.character等で型強制が可能  
異なる型の要素をベクトルにまとめる場合に暗黙に型強制が行われる ⇒ ベクトルの各要素の型は常に共通  
is_logical、is_integer、is_double、is_character等で型判定ができる  
set_names(1:3, c("a", "b", "c"))等で、各要素に名前を付けることができる  
要素の抽出  
~~~
x <- letters[1:5]
x[c(1, 1, 5, 5, 2, 2)]　# 複数回指定することが可能
x[c(-1, -3, -5)] # マイナスは指定の位置の要素を除いて表示する
x[x == "b"] # 論理値による指定も可能
y["c"] # 名前による指定も可能
x[3] # 部分集合を抽出
x[[3]] # 要素を抽出
~~~

* リスト（再帰ベクトル）  
異なる型、異なる長さを保持できる  
要素の抽出  
~~~
y["c"] # 名前による指定も可能
x[3] # サブリストを抽出
x[[3]] # 要素を抽出
~~~

* 強化ベクトル  
ベクトルの属性は自由に追加可能で、主なものとして次元（dim）やクラス（class）がある  
~~~
attr(x, "greeting") # greeting属性の付与
attributes(x) # 属性の確認
~~~
クラス等の属性を追加し、特定の機能を持たせたベクトルを強化ベクトルと呼ぶ  
ファクタは属性levelsを持つ、factorクラスの整数ベクトル  
日付はDateクラスの数値ベクトル  
日付時刻は属性tzoneを持つ、POSIXctもしくはPOSIXtクラスの数値ベクトル  
tibbleやデータフレームは、列名や行名を属性に持った同じ長さのベクトルを要素に持つリスト  


### １７章　purrrでイテレーション  

1. 命令型プログラミング  
命令文による繰り返し処理  
ループ処理を高速に行うためには、各処理の都度データを整形するのではなく、出力をリストにまとめておき、最後にまとめて整形すると良い  
~~~
# 先に出力スペースを確保すると速い
output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
  }

# 名前でもループできる  
for (nm in names(df)) {
  output[[i]] <- mean(df[[nm]])
}

# シーケンス長が不明な場合
while (i <= length(df)) {
  i <- i + 1
}
~~~

1. 関数型プログラミング  
関数による繰り返し処理  
map関数はapply関数に比べて使いやすい一方で、出力はベクトルに限られる（apply関数はマトリックスも出力する）  
~~~
map(df, mean, 関数への引数) # 各要素（dfの場合は列、ベクトルの場合は要素）に関数を適用した出力をリストで返す  
map_dbl(df, mean, 関数への引数) # double型のベクトルで返す

# 匿名関数の利用
mtcars %>%
  split(.$cyl) %>%
  map(function(df) lm(mpg ~ wt, data=df))
  map(~lm(mpg~wt, data=.))　# ショートカット、.はリスト要素を表す

# エラー処理
# safely関数で修正された関数は、正常出力とエラー出力のリストを返す
# possibly（エラー時の出力をコントロール）やquetly（メッセージや警告をリスト化して出力）も、エラー出力をカスタマイズした修正関数を作る  
safe_log <- safely(log)

# 複数のパラメータをイテレーション
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)
n <- list(1, 3, 5)
map2(mu, sigma, rnorm, n=5) # ２変数
args1 <- list(n, mu, sigma)
args1 %>% pmap(rnorm) # ３変数

# 関数のイテレーション
# 関数とパラメータを別に指定
f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min=-1, max=1),
  list(sd=5),
  list(lambda=10)
)
invoke_map(f, param, n=5)

# 関数とパラメータをtibbleにまとめて指定
sim <- tribble(
  ~f, ~params,
  "runif", list(min=-1, max=1),
  "rnorm", list(sd=5),
  "rpois", list(lambda=10)
)
sim %>%
  mutate(sim=invoke_map(f, params, n=10))

#その他

iris %>% keep(is.factor) # Trueの要素だけを残す
iris %>% discard(is.factor) # Falseの要素だけを残す
x <- list(1:5, letters, list(10))
x %>% some(is_character) # いずれかの要素がTrueならTrueを返す
x %>% every(is_character) # 全ての要素がTrueならTrueを返す
x %>% detect(~. >5) #真となる最初の要素を返す
x %>% detect_index(~. >5) #真となる最初の要素番号を返す
x %>% head_while(~. >5) #真となる先頭からの要素列を返す
x %>% tail_while(~. >5) #真となる末尾からの要素列を返す

# reduceは先頭の要素から順次ペアを作成し、関数を適用していく
dfs <- list(
  age=tibble(name="John", age=30),
  sex=tibble(name=c("John", "Mary"), sex=c("M", "F")),
  trt=tibble(name="Mary", treatment="A")
)
dfs %>% reduce(full_join)

# accumulateはreduce同様の処理を行うが、関数の適用結果を全て保持する
x <- sample(10)
x %>% accumulate(`+`)
~~~

* Tips  
walk(func): mapと異なり、戻り値ではなく、処理自体を目的に関数を要素に適用する  


## 第Ⅳ部　モデル  

モデルの目的はデータセットの簡単な低次元の要約  
ここでは一般予測を生成する「予測モデル」を扱う  
データの60%を訓練集合、20%をクエリ周到、最後の20%をテスト集合にする  

### １８章　modelrを使ったモデルの基本  

モデルのファミリー（ファミリー）を定義  
パラメータの推定 ⇒ モデルの評価尺度（最小二乗法等）  
モデルの目的は有用で単純な近似を発見すること（真の理論を導くことが目的ではない）  

* モデル推定と可視化  
~~~
# 線形モデルの推定
sim_mod <- lm(y~x, data=sim)

# 一意の説明変数データグリッドを作成
grid <- sim %>%
  data_grid(x)

# データグリッドに対して予測を算出
grid <- grid %>%
  add_predictions(sim_mod)

# 元データに対して残差を算出
sim <- sim %>%
  add_residuals(sim_mod)

#残差の分布
ggplot(sim, aes(resid)) +
  geom_freqpoly(binwidth=0.5)

#残差のプロット
g1 <- ggplot(sim, aes(x, resid)) +
  geom_ref_line(h=0) +
  geom_point() +
  ylim(-5, 5)
~~~

~~~
# 複数変数のモデル（x1が連続変数、x2がカテゴリカル変数の前提）  
sim_mod_c1 <- lm(y~x1+x2, sim) # 交互作用効果なし
sim_mod_c2 <- lm(y~x1*x2, sim) # 交互作用効果あり
 
# データグリッドに対して予測を算出
grid <- sim %>%
  data_grid(x1, x2) %>%
  gather_predictions(sim_mod_c1, sim_mod_c2)

# 元データに対して残差を算出
sim <- sim %>%
  gather_residuals(sim_mod_c1, sim_mod_c2)

# モデル毎にx2のレベル別の予測値（直線）を出力
ggplot(sim, aes(x1, y, color=x2)) +
  geom_point() +
  geom_line(data=grid, aes(y=pred)) +
  facet_wrap(~model)

# モデル別にx2のレベル別の残差を出力
ggplot(sim, aes(x1, resid, color=x2)) +
  geom_point() +
  facet_grid(model~x2)
~~~

* フォーミュラによる変換  
~~~
log(y) ~ sqrt(x1) + x2
y ~ x + I(x^2) # 変換を明らかにするためI()でラップする
y ~ poly(x, 2) # 二次までの多項式和
y ~ splines::ns(x, 2) # 二次までのスプライン関数
~~~

* 線形モデル以外  
一般化線形モデル: stats::glm()  
一般化加法モデル: mgcv::gam()  
罰則付き線形モデル: glmnet::glmnet()  
頑健線形モデル: MASS::rlm()  
決定木: rpart::rpart()  

* Tips  
model_matrix(df, y ~ x1 + x2): フォーミュラで指定したモデルに沿って、説明変数を変換する    
seq_range(x, n, trim=0.1, expand=0.1): ベクトルxの要素の範囲をn等分するグリッドを作成、trim、expandはそれぞれ、範囲をトリムもしくは拡張する  



### １９章　モデル構築  

データと頭の中にある暗黙知を定量モデルの明示的な知識に移し替える  
モデルの予測力に焦点を絞るのが機械学習だが、モデル自体はブラックボックス化する  
ほとんどのモデルは前者と後者の組み合わせである  

* モデルの作成と予測、残差の算出  
~~~
# 二次元分布
ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins=50)

# 線形モデルを推定
model_diamond <- lm(lprice~lcarat, data=diamonds_mod)

# 予測値（新しいデータに対して）
grid <- diamonds_mod %>%
  data_grid(carat=seq_range(carat, 20)) %>%
  mutate(lcarat=log2(carat)) %>%
  add_predictions(model_diamond, "lprice") %>%
  mutate(price=2^lprice)

# 残差（モデル推定に使用したデータに対して）
diamonds_mod <- diamonds_mod %>%
  add_residuals(model_diamond, "lresid")
~~~

* モデリングと残差の可視化  
~~~
# 可視化（曜日別のフライト数）
ggplot(daily, aes(wday, n)) +
  geom_boxplot()

# モデリング
mod <- lm(n~wday, data=daily)

# 残差の算出
daily <- daily %>%
  add_residuals(mod)

# 残差の表示
daily %>% ggplot(aes(date, resid)) +
  geom_ref_line(h=0) +
  geom_line() +
  geom_smooth(se=F, span=0.2) # 傾向線
~~~

* 複数のモデルの比較
~~~
# 新しい変数を交差項として考慮
mod1 <- lm(n~wday, data=daily)
mod2 <- lm(n~wday*term, data=daily)

# 複数のモデルの残差を可視化
daily %>%
  gather_residuals(without_term=mod1, with_term=mod2) %>%
  ggplot(aes(date, resid, color=model)) +
  geom_line(alpha=0.75)
~~~

### ２０章　purrrとbroomによる多数のモデル  

多数のモデルを統一的に処理する
1. データ及びモデルをカテゴリ別にリスト列に要約する  
1. リスト列を展開し整理データを作成する  

* 活用事例  
~~~
#入れ子データ
#country×continent毎に全てのデータをまとめたリスト列を作成する
by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()

#モデルを定義
country_model <- function(df) {
  lm(lifeExp~year, data=df)
}

#グループ毎にモデルを適用し、結果をリスト列とする
by_country <- by_country %>%
  mutate(model=map(data, country_model),
          resids=map2(data, model, add_residuals))

#リスト列を展開し、整理データを作成
resids <- unnest(by_country, resids)

#視覚化１
resids %>%
  ggplot(aes(year, resid, group=country)) +
  geom_line(alpha=1/3) +
  facet_wrap(~continent)

#モデルの各種統計量をリスト列として出力し、展開
glance <- by_country %>%
  mutate(glance=map(model, broom::glance)) %>%
  unnest(glance, .drop=T)

#視覚化２
glance %>%
  ggplot(aes(continent, r.squared)) +
  geom_jitter(width=0.5)
~~~

* リスト列の作成  
~~~
#tibble
tibble(
  x=list(1:3, 3:5),
  y=c("1, 2", "3, 4, 5")
)

#tribble
tribble(
  ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5"
)

#リストを出力する関数を適用
df <- tribble(
  ~x1,
  "a,b,c",
  "d,e,f,g"
)

df %>%
  mutate(x2=stringr::str_split(x1, ","))

#summarizeを用いる場合は、listを用いて一意にして出力
mtcars %>%
  group_by(cyl) %>%
  summarize(q=list(quantile(mpg)))

#リストから要素名のキャラクター列、値のリスト列
x <- list(
  a=1:5,
  b=3:4,
  c=5:6
)

df <- enframe(x)
~~~

* リスト列の展開（単純化）  

~~~
#一意の値を出力する関数を適用  
df <- tribble(
  ~x,
  list(a=1, b=2),
  list(a=2, c=4)
)

df %>%
  mutate(
    a=map_dbl(x, "a"),
    b=map_dbl(x, "b", .null=NA_real_)
) #要素名で一意の値を抽出する
  
#unnestを用いた展開
df2 <- tribble(
  ~x, ~y, ~z,
  1, "a", 1:2,
  2, c("b", "c"), 3
)

df2 %>% unnest(c(y, z))
~~~

* broom  
glance、tidy、augment等、複数のモデルをまとめて扱うのに便利な機能があるため、チェックすること  


## 第Ⅴ部　コミュニケーション  

マークダウンを使用したコミュニケーションについて  

### ２１章　Rマークダウン  

デフォルトはHTML文書、HTMLスライドも追加のパッケージなしで出力できる  
PDFで出力する場合はTEX等の追加的インストールが必要となる  
knitrがrmdファイルからmdファイルを作成し、それをpandocが各指定の書式の文書に変換する  

[レファレンス](https://rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)
[チートシート（日本語）](https://rstudio.com/wp-content/uploads/2016/11/Rmarkdown-cheatsheet-2.0_ja.pdf)

1. テキストフォーマット  
2. コードチャンク  
  表はknitr::kableでフォーマットを指定することができる
  knitr::clean_cache()で全てのキャッシュをクリアできる  
3. YAMLヘッダ  

### ２２章　ggplot2でコミュニケーションのためのグラフ作成  




