# comevizz

## What is comevizz?

`comevizz` is a web application to analyze source code metrics distributions.
You can see the statistical information for many projects on `comevizz`. You can also see **Z-Score** for metrics of your own project, and know the room for improvement in your source code.

See [comevizz](00-introduction.md) for more details.

`comevizz` uses .csv file for metrics data measured by [SONARQUBE Software](https://www.sonarqube.org/)&trade; [^1].
We provide CLI tool `sonar2csv` to obtain metrics data in .csv format from [SONARQUBE Software](https://www.sonarqube.org/).

See [sonar2csv](../sonar2csv.md) for more details.

## What statistics can you find?
* [Z-score](./A-appendix.md#z-score)
* Cumulative distribution function
* Probabilistic density function

## The structure of comevizz

The structure of `comevizz` is the follows.

![structure](images/structure.mermaid.png)


[1]: SONARQUBE&trade; is a proprietary trademark belonging to SonarSource SA
