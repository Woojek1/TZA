select
	"PracownikID"
	,"PracownikKod"
	,"Pracownik"
	,"PrzelozonyID"
	,"PrzelozonyKod"
	,"EmailHR"
from
	bronze.hr_enova_struktura_organizacyjna_zymetric
	

SELECT 
    p."PracownikID",
    p."Pracownik" AS "Pracownik",
    p."EmailHR" AS "EmailPracownika",

    -- 1. Bezpośredni przełożony
    p1."Pracownik" AS "Przelozony (N-2)",
    p1."EmailHR" AS "EmailPrzelozonego (N-2)",

    -- 2. Przełożony przełożonego
    p2."Pracownik" AS "Przelozony (N-1)",
    p2."EmailHR" AS "EmailPrzelozonego (N-1)",
    
    -- 3. Prezes
    
    p3."Pracownik" AS "Przelozony (N)",
    p3."EmailHR" AS "EmailPrzelozonego (N)"  

FROM bronze.hr_enova_struktura_organizacyjna_zymetric p
LEFT JOIN bronze.hr_enova_struktura_organizacyjna_zymetric p1 ON p."PrzelozonyID" = p1."PracownikID"
LEFT JOIN bronze.hr_enova_struktura_organizacyjna_zymetric p2 ON p1."PrzelozonyID" = p2."PracownikID"
LEFT JOIN bronze.hr_enova_struktura_organizacyjna_zymetric p3 ON p2."PrzelozonyID" = p3."PracownikID"
ORDER BY p."Pracownik"