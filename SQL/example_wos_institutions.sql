IF OBJECT_ID('tempdb..#GT') IS NOT NULL
    DROP TABLE #GT;

IF OBJECT_ID('tempdb..#GT_art') IS NOT NULL
    DROP TABLE #GT_art;


SELECT DISTINCT [OST_BK]
      ,[Institution]
      ,[Pays]
      ,[Province]
      ,[Ville]
INTO #GT
  FROM [WoS].[pex].[Adresse]
  --where Institution = 'HARVARD-UNIV';
  where Institution = 'GEORGIA-INST-TECHNOL';


  SELECT Ville, COUNT(DISTINCT OST_BK) as N
  FROM #GT
  GROUP BY Ville
  ORDER BY N DESC;

 SELECT #GT.[OST_BK]
      ,[Annee_Bibliographique]
      ,ldd.EType_Document
      ,lr.Revue
      ,ld.EDiscipline, ld.ESpecialite
      ,[Titre]
	INTO #GT_art
  FROM [WoS].[pex].[Article] as art
  INNER JOIN #GT on art.OST_BK=#GT.OST_BK
  LEFT JOIN wos.pex.Liste_Discipline as ld on art.Code_Discipline=ld.Code_Discipline
  LEFT JOIN wos.pex.Liste_revue as lr on art.Code_Revue=lr.Code_Revue
  LEFT JOIN wos.pex.Liste_Document as ldd on art.Code_Document=ldd.Code_Document;


  SELECT Annee_Bibliographique as year, EDiscipline, COUNT(DISTINCT OST_BK) as N
  FROM #GT_art
  WHERE EType_Document='Article' 
  GROUP BY Annee_Bibliographique, EDiscipline
  ORDER BY N desc
  

