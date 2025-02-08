select
  ROW_NUMBER() OVER(order by case when t.name is null then 1 else 0 end, t.name) as `crtNo`,
  t.name as `tagName`,
  SUM(case when e.value > 0 then e.value else 0 end) as `loss`,
  SUM(case when e.value < 0 then e.value else 0 end) as `gain`,
  SUM(e.value) as `total`
from expenses e
left join expense_tags et on et.expense_id=e.id
left join tags t on t.id=et.tag_id
where e.created_date >= ? and e.created_date < ?
GROUP BY t.name
ORDER BY `crtNo`