# LIMITS

SQL takes time. To experiment with a table, we want to quickly iterate over the construction of the table, adding one join at a time, one filter at a time, etc. For that, we want to limit the number of rows.

In OST (Microsoft SQL server) we do it in the following way:

```SQL
SELECT TOP(1000) * 
FROM my_table
```

adding at the beginning the `TOP(1000)` ensure to only compile the first 1000 rows

For other SQL flavors like Google big query we do it at the end of the query like this:

```SQL
SELECT * FROM my_table LIMIT 10;
```


# Temporary tables

If we want to create a new table to use it as a part of another table, we can save the query results into a temporary table. For example, you first create the complicated filters and search of papers' ids, and then use that pre-compiled list for extracting different tables (abstracts, metadata, authors, etc)

you can do that by adding the `INTO`  statement:

```SQL
SELECT * 
INTO #temporary_table
FROM my_table 
```


#distinct results

Many times if the data is duplicated because of a variable (like a paper with many authors_id) that we are not selecting, we get a table with duplicated results. So it is a good practice to always add a `DISTINCT` statement at the beginning of the table to clean it

```SQL
SELECT DISTINCT var_1,var_2
FROM my_table 
```