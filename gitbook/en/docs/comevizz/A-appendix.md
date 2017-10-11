# Appendix A. sonar2csv {#sonar2csv}

## About `sonar2csv`

`COMEVIZZ` needs metrics data in csv file format.  
`sonar2csv` can produce metrics data calculated by SONARQUBE Software in form of csv.  

## How to use `sonar2csv`

See documentation about `sonar2csv`

# Appendix B. The Format of Metrics Data File {#appendix_metrics_format}

Metrics data file is a csv file including headers as metrics names and the data as metrics values measured in some projects. The following columns are required.  

| MetricsName | Type     | Example |
|:------------|:--------:|:--------|
| url         | String   | https://github.com/apache/commons-io.git |
| time        | String   | 1970-01-01T00:00:00Z |
| lines       | Num      | 1000    |

For example, the following csv file is formatted correctly.

```
time,code_smells,complexity_in_functions,lines,url
2002-08-21T13:05:29Z,8797,17412,194645,https://github.com/apache/xerces2-j.git
2002-10-09T20:38:26Z,2480,4042,45383,https://github.com/apache/log4j.git
2004-03-23T20:18:47Z,11911,27711,189617,https://github.com/eclipse/cdt.git
2004-04-19T19:21:17Z,118,684,6737,https://github.com/x-stream/xstream.git
```

# Appendix C. How to calculate Z-Score {#z-score}

This section explains how to calculate Z-Score.  


Z-Score is calculated the following equation.  

$$
  Z-Score = \frac{x_{i} - \mu_{x}}{\sigma_{x}}
$$

$$x_{i}, \mu_{x}, \sigma_{x}$$ represents metrics value$$x_{i}$$, Average $$\mu_{x}$$ and standard deviation $$\sigma_{x}$$ respectively.
$$
  \mu_{x} = \frac{1}{N} \sum_{i=1}^{N} x_{i}
$$

$$
  \sigma_{x} = \sqrt{ \frac{1}{N} \sum_{i=1}^{N} (x_{i} - \mu_{x})^2 }
$$

---
In most case, larger values in metrics means lower readability and mentainability. Therefore, in COMEVIZZ we show Z-Scores inversed from the original values. For example, larger values in complexity metrics result in smaller values in Z-Scores. 
