SELECT
	"Entry No_"
	,"G_L Account No_"
	,cast("Posting Date" as date) as "Posting Date"
	,"Document No_"
	,"Description"
	,"External Document No_"
	,"Debit Amount"
	,"Credit Amount"
FROM
	BC_DEV_cycle.dbo.[Nabilaton$G_L Entry$437dbf0e-84ff-417a-965d-ed2bb9650972]
WHERE
	[Posting Date] >= '2024-04-01'
AND
	[Posting Date] <= '2025-03-31'
order by
	[Entry No_] asc
--	"Posting Date" asc