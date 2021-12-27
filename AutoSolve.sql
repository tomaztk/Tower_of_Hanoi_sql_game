


declare @t1 int = (Select TOP 1 ISNULL(t1,0) from hanoi WHERE t1 <> 0 ORDER BY ID ASC)
declare @t2 int = (Select TOP 1 ISNULL(t2,0) from hanoi WHERE t2 <> 0 ORDER BY ID ASC)
declare @t3 int = (Select top 1 ISNULL(t3,0) from hanoi WHERE t3 <> 0 ORDER BY ID ASC)


-- možne poti!
declare @from int
declare @to int

SELECT top 1 
@from = right(from_part.rod,1) -- as fr
,@to = right(to_part.rod,1) --  as too
FROM
(
select isnull(@t1,0) as val, 't1' as rod, 'from' as pot
union 
select isnull(@t2,0), 't2', 'from' as pot
union 
select isnull(@t3,0), 't3', 'from' as pot
) as from_part
cross join (
select isnull(@t1,0) as val, 't1' as rod, 'to' as pot
union 
select isnull(@t2,0), 't2', 'to' as pot
union 
select isnull(@t3,0), 't3', 'to' as pot
) as to_part

WHERE
	(from_part.rod <> to_part.rod) -- ne gre sam vase
AND from_part.val <> 0  -- ne prestavljamo nul
--AND (to_part.val > from_part.val OR (to_part.val = 0)) -- razen za nule!
AND CASE WHEN to_part.val = 0 then  99 else to_part.val end > from_part.val
order by newid() 

print @from
print @to

exec play_hanoi @from=@from, @to=@to