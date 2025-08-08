------------------------------------------------------------------------------------------
-- BC SERVICE LEDGER ENTRIES 
------------------------------------------------------------------------------------------

select
	"Posting_Date"
	,"Item_No_Serviced"
	,"Serial_No_Serviced"
	,"Base_Group_A_Serviced"
	,"Base_Group_B_Serviced"
	,"No"
	,"Base_GroupA"
	,"Base_GroupB"	
from
	bronze.bc_service_ledger_entry_zymetric

union all

select 
	"Posting Date"
	,"Item No_ (Serviced)"
	,"Serial No_ (Serviced)"

	,NULL AS "Base_Group_A_Serviced"	--nie ma w nav
	,NULL AS "Base_Group_B_Serviced"	--nie ma w nav	
	
	,"No_"
	
	,NULL AS "Base_GroupA"	--nie ma w nav
	,NULL AS "Base_GroupB"	--nie ma w nav
from
	bronze.nav_service_ledger_entry_zymetric





------------------------------------------------------------------------------------------
-- BC ITEM LEDGER ENTRIES 
------------------------------------------------------------------------------------------

SELECT 
	cast(sl.[Posting Date] as date) as [Data awarii]
	,cast(ile.[Posting Date] as date) as [Data sprzedazy]
	,sl.[Item No_ (Serviced)] as [Symbol urzadzenia]
	,sl.[Serial No_ (Serviced)] as [Nr seryjny urzadzenia]
	,sl.[No_] as [Symbol czesci]
	,DATEDIFF(month, ile.[Posting Date], sl.[Posting Date]) as [Miesiace do do awarii]
from
	BC_DEV_cycle.dbo.[Zymetric$Service Ledger Entry$437dbf0e-84ff-417a-965d-ed2bb9650972] sl
left JOIN 
	BC_DEV_cycle.dbo.[Zymetric$Item$437dbf0e-84ff-417a-965d-ed2bb9650972] i
on
	sl.[Item No_ (Serviced)] = i.[No_]
left JOIN 
	BC_DEV_cycle.dbo.[Zymetric$Item Ledger Entry$437dbf0e-84ff-417a-965d-ed2bb9650972] ile
on sl.[Serial No_ (Serviced)] = ile.[Serial No_]
where
	sl.[Entry Type] = 2
--and
--	ile.[Entry Type] = 1
and
	sl.[Serial No_ (Serviced)] = '54V2230000527160150027'