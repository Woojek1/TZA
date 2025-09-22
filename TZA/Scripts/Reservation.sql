SELECT
	[Item No_]
	,sum([Quantity (Base)])
--	[Entry No_]
--	,[Positive]
FROM
	BC_DEV_cycle.dbo.[Aircon$Reservation Entry$437dbf0e-84ff-417a-965d-ed2bb9650972]
group BY
	[Item No_]
--	,[Entry No_]
--	,[Positive]

-------------------------------------
-------------------------------------


SELECT 
    [Item No_],
    [Source Type],
    [Source Subtype],
    [Source ID],
    [Source Ref_ No_],
    SUM([Quantity (Base)]) AS ReservedQty
FROM BC_DEV_cycle.dbo.[Aircon$Reservation Entry$437dbf0e-84ff-417a-965d-ed2bb9650972]
WHERE [Reservation Status] = 3
AND Positive = 0
GROUP BY 
	[Item No_],
	[Source Type],
	[Source Subtype],
	[Source ID],
	[Source Ref_ No_];