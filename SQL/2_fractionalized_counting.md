# Fractionalized counting

When we are counting paper (i.e. the proportion of papers by country, discipline, gender) we need to take into account that papers with more than one author might have more that one country, discipline, gender. If we simply count, those papers will be double counted. To avoid this, we can use fractionalized counting, which means the paper counts for each group only proportionally to the authors in that group. For example

-   A paper with 1 author from Canada and 1 author US would count 0.5 to each country.
-   A paper with 2 women and 1 men would be counted as 2/3 women and 1/3 men.

**the fractionalized counting has to be done only for the dimension of analysis we are interested into**.

To do it in SQL we need to create 4 tables:

1.  a table with the count of authors in each paper
2.  a table with the count of authors from each group in each paper
3.  a table where we can do the fractionalized counting.
4.  use the fractionalized counting to sum over and get the totals per group.

For example: proportion of papers by country:

Let's create a table with authors and countries

``` sql
SELECT DISTINCT OST_BK,Full_Name,country 
into #author_country
FROM #authors
```

1.  a table with the count of authors in each paper

``` sql
SELECT OST_BK, COUNT(*) as N_total
into #n_auth
FROM #author_country
GROUP BY OST_BK
```

2.  a table with the count of authors from each group in each paper

``` sql
SELECT OST_BK,country, COUNT(*) as N_country
into #nauth_country
FROM #author_country
GROUP BY OST_BK,country
```

3.  a table where we can do the fractionalized counting.

``` sql
SELECT #nauth_country.OST_BK,country, (N_country*1.0/N_total*1.0) as p_country
into #pauth_country
from #nauth_country
left join #n_auth on #n_auth.OST_BK = #nauth_country.OST_BK
```

the `1.0` is to convert the values to float, and keep the decimal places needed on that ratio

4.  use the fractionalized counting to sum over and get the totals per group.

Then instead of `COUNT`, we can `SUM`

``` sql
SELECT country,SUM(p_country) as frac_counting
from #pauth_country
GROUP BY country
ORDER BY frac_counting desc
```
