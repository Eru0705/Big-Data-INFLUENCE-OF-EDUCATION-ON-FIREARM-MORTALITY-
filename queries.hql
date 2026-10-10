-- HiveQL used in the project (run in Hive CLI and Apache Zeppelin %jdbc(hive)).
-- Table schema follows the dataset's 9 columns.

-- 1. Upload dataset to HDFS (shell, via PuTTY)
-- hdfs dfs -mkdir /user/hadoop/mydataset
-- hdfs dfs -put /root/Assignment.csv /user/hadoop/mydataset
-- hdfs dfs -ls /user/hadoop/mydataset

-- 2. Database and table
CREATE DATABASE cw2;
USE cw2;

CREATE TABLE gun_deaths (
  year      INT,
  month     INT,
  intent    STRING,
  police    INT,
  sex       STRING,
  age       INT,
  race      STRING,
  place     STRING,
  education STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/hadoop/mydataset/Assignment.csv' INTO TABLE gun_deaths;

-- 3. Check data loaded
SELECT * FROM gun_deaths LIMIT 5;

-- 4. Suicide vs homicide
SELECT intent, COUNT(*) AS deaths
FROM gun_deaths
WHERE intent IN ('Suicide', 'Homicide')
GROUP BY intent;

-- 5. Deaths per education level
SELECT education, COUNT(*) AS death
FROM gun_deaths
GROUP BY education;

-- 6. Education level with the most deaths
SELECT education, COUNT(*) AS total_deaths
FROM gun_deaths
GROUP BY education
ORDER BY total_deaths DESC
LIMIT 1;

-- ---------- Zeppelin (%jdbc(hive)) ----------

-- 7. Deaths by intent (pie chart)
SELECT intent, COUNT(*) AS total_deaths
FROM gun_deaths
GROUP BY intent
ORDER BY total_deaths DESC;

-- 8. Deaths by education (line chart)
SELECT education, COUNT(*) AS total_deaths
FROM gun_deaths
WHERE education IS NOT NULL AND education != ''
GROUP BY education
ORDER BY total_deaths DESC;

-- 9. Suicides by education (line chart)
SELECT education, COUNT(*) AS suicide_count
FROM gun_deaths
WHERE intent = 'Suicide'
  AND education IS NOT NULL
  AND education != ''
GROUP BY education
ORDER BY suicide_count DESC;

-- 10. Homicides by education (bar chart)
SELECT education, COUNT(*) AS homicide_deaths
FROM gun_deaths
WHERE intent = 'Homicide'
  AND education IS NOT NULL
  AND education != 'NaN'
  AND education != ''
GROUP BY education
ORDER BY homicide_deaths DESC;
