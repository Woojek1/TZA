select 
	sl."documentNo"
	,sl."lineNo"
	,sl."dimensionSetID"
	,ds."dimensionCode"
	,ds."dimensionName"
	,ds."dimensionValueCode"
from bronze.bc_sales_lines_zymetric sl
inner join bronze.bc_dimension_set_zymetric ds
on sl."dimensionSetID" = ds."dimensionSetID"
order by 1, 2;


select
  sl."documentNo",
  sl."lineNo",
  MAX(CASE WHEN ds."dimensionCode" = 'GR.ZAPAS'    THEN ds."dimensionValueCode" END) AS "GR.ZAPAS",
  MAX(CASE WHEN ds."dimensionCode" = 'KONTR.WOJEW' THEN ds."dimensionValueCode" END) AS "KONTR.WOJEW",
  MAX(CASE WHEN ds."dimensionCode" = 'PRACOWNIK'   THEN ds."dimensionValueCode" END) AS "PRACOWNIK",
  MAX(CASE WHEN ds."dimensionCode" = 'REGION'      THEN ds."dimensionValueCode" END) AS "REGION"
FROM bronze.bc_sales_lines_zymetric sl
JOIN bronze.bc_dimension_set_zymetric ds
  ON sl."dimensionSetID" = ds."dimensionSetID"
GROUP BY
  sl."documentNo",
  sl."lineNo"
ORDER BY
  sl."documentNo",
  sl."lineNo";