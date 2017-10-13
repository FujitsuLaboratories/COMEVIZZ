# comevizz

## comevizzとは

`comevizz`はソースコードメトリクスの分析を行うためのWebアプリケーションです.
`comevizz`上では多くのプロジェクトから収集したメトリクスデータの統計的な情報を閲覧することができます.
また,あなたのプロジェクトのソースコードを多数のプロジェクトのメトリクスと比較し,あなたのプロジェクトの弱点やソースコードメトリクスの分布を把握可能にします。

## 確認できる統計値
* [Z-score](A-appendix.md#z-score)
* 累積密度関数
* 確率密度関数

## システム構成図

`comevizz`のシステム構成は下記の通りです。

![structure](images/structure.mermaid.png)

`comevizz`ではメトリクスデータのZ-score導出と統計的な分析を行うことができます.
詳しい使用方法は[Install](./01-install.md)もしくは[Usage](./02-usage.md)を参照してください.

`comevizz`は[SONARQUBE&trade; Software](https://www.sonarqube.org/) により測定されたメトリクスをCSV形式でインポートします.
SONARQUBE[^1] Softwareで測定したメトリクスデータをCSV形式で取得するには[sonar2csv](docs/sonar2csv.md)を利用してください.


[1]: SONARQUBE はSonarSource SA社の商標です。