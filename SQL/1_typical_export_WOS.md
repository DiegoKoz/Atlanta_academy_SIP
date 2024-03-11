1.  Let's look for papers with a keyword

``` sql
SELECT DISTINCT [OST_BK]
INTO #OA
FROM [WoS].[dbo].[Keyword]
WHERE Keyword LIKE '%open%access%'
```

2.  filter your IDS for code document, year, or field:

``` sql
select art.OST_BK 
into #OA_filter
FROM #OA
INNER JOIN [WoS].[pex].[Article] as art on art.OST_BK=#OA.OST_BK
WHERE art.Code_Document in (1,2,3) AND  -- keep only articles(1), notes(2), and reviews(3)
Annee_Bibliographique between 2010 AND 2022 and -- filter the years for your data
art.Code_Discipline >100 --For Social sciences
```

2.  Metadata

``` sql
--drop table #meta

select distinct art.ost_BK, art.Annee_Bibliographique as year, art.titre as title, LR.Revue as journal,
LD.ESpecialite as specialty, LD.EDiscipline as discipline,
Cit_ALL_iac, Cit_Rel_2_iac
into #meta
FROM #OA_filter
INNER JOIN [WoS].[pex].[Article] as art on art.OST_BK=#OA_filter.OST_BK --we retrieve main article data,
INNER JOIN [WoS].pex.Liste_Revue AS LR ON art.Code_Revue = LR.Code_Revue -- names of journals
INNER JOIN [WoS].pex.Liste_Discipline AS LD ON art.Code_Discipline = LD.Code_Discipline --and names of disciplines
LEFT JOIN [WoS].[pex].[Citations_Relatives] as cit on cit.OST_BK = #OA_filter.OST_BK -- we can also add citation data
```

3.  Authors

``` sql
--drop table #authors


SELECT DISTINCT #OA_filter.[OST_BK],n.[First_Name],n.[Last_Name],n.[Full_Name],
adr.Addr_no,adr.Pays as country, adr.Ville as city, adr.Institution
into #authors
FROM #OA_filter
INNER JOIN  [WoS].[dbo].Summary_Name as n on n.OST_BK=#OA_filter.OST_BK -- the table with OST_BK, Seq_No of authors and names
LEFT JOIN [WoS].[pex].[Article] as art on art.OST_BK=#OA_filter.OST_BK
LEFT JOIN Wos.dbo.Address_Name as adr_n on adr_n.OST_BK=#OA_filter.OST_BK and adr_n.Seq_No=n.Seq_No
LEFT JOIN Wos.pex.Adresse as adr on adr.OST_BK=#OA_filter.OST_BK  and adr_n.Addr_No=adr.Addr_no
```

4.  Funding

``` sql
-- Retrieve funding
--drop table #funding

SELECT DISTINCT a.OST_BK,a.Agency, a.Ordre_Agency as agency_order
into #funding
FROM #OA_filter
LEFT JOIN  [WoS].[dbo].[Fund_Ack_Grant_Agency] as a on a.OST_BK=#OA_filter.OST_BK
```

5.  Exports:

``` sql
select * from #meta
ORDER BY OST_BK

-- save to metadata.tsv

select * from #authors
ORDER BY OST_BK

-- save to authors.tsv

select * from #funding
ORDER BY OST_BK

-- save to funding.tsv
```
