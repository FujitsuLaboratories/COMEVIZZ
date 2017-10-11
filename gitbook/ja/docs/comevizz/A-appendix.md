# 付録A. sonar2csv {#sonar2csv}

## sonar2csvについて

`comevizz`では,CSV形式のメトリクス情報を使用します.  
SONARQUBE Softwareで測定したメトリクス情報をCSV形式で取得するためには`sonar2csv`を使用してください.

## sonar2csvの使用方法

sonar2csvのドキュメントを参照してください

# 付録B. メトリクス情報ファイルフォーマット {#appendix_metrics_format}

メトリクス情報ファイルは,ヘッダ行がメトリクス名,次の行からは１行ごとに１プロジェクトのメトリクスデータが格納されたCSVファイルです.  
下記の情報が必須です.

| メトリクス名 | データ型 | 例 |
|:-----------|:-------:|:---|
| url        | 文字列   | https://github.com/apache/commons-io.git |
| time       | 日時     | 1970-01-01T00:00:00Z |
| lines      | 数値     | 1000 |

例えば,下記のようなCSVファイルとなります.
```
time,code_smells,complexity_in_functions,lines,url
2002-08-21T13:05:29Z,8797,17412,194645,https://github.com/apache/xerces2-j.git
2002-10-09T20:38:26Z,2480,4042,45383,https://github.com/apache/log4j.git
2004-03-23T20:18:47Z,11911,27711,189617,https://github.com/eclipse/cdt.git
2004-04-19T19:21:17Z,118,684,6737,https://github.com/x-stream/xstream.git
```

# 付録C. Z-Score {#z-score}

ここでは、Z-Scoreの算出式について説明します.

Z-Scoreは偏差値($$Deviation$$)導出式の因子の一部を表しています.  
偏差値導出式をZ-Scoreを用いて表すと、下記のようになります.

$$
  Deviation = 50 + 10 \frac{(x_{i} - \mu_{x})}{\sigma_{x}} 
            = 50 + 10 \times Z-Score 
$$

ここで、$$x_{i}, \mu_{x}, \sigma_{x}$$は、それぞれ収集した各メトリクスデータ$$x_{i}$$、その平均$$\mu_{x}$$、標準偏差$$\sigma_{x}$$を表します.
$$
  \mu_{x} = \frac{1}{N} \sum_{i=1}^{N} x_{i}
$$

$$
  \sigma_{x} = \sqrt{ \frac{1}{N} \sum_{i=1}^{N} (x_{i} - \mu_{x})^2 }
$$

上記で定義した平均$$\mu_{x}$$と標準偏差$$\sigma_{x}$$と用いると、Z-Scoreは下記のように表すことができます.

$$
  Z-Score = \frac{x_{i} - \mu_{x}}{\sigma_{x}}
$$

---

以上より、偏差値は$$50$$を基準として、Z-Scoreを10倍したものを加算した値を表していることになります.  
偏差値とZ-Scoreの対応表は下記のようになります.

| 偏差値 | Z-Score |
|:-----:|:-------:|
| 50    | 0       |
| 60    | 1.0     |
| 35    | -1.5    |


また、今回収集対象としたメトリクスは,メトリクス値が高いほどメンテナビリティが低いなど傾向を示すものであるため(例: code_smells, bugs...)、メトリクス値が高いほどZ-Scoreが低くなるよう符号を逆転した数値を使用しています.

