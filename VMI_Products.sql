Use Datastorelive;

Drop Table if Exists #xref

Select c.cono,
c.custno,
c.altprod,
c.prod,
c.unitsell,
c.unitbuy,
ROW_NUMBER() over (partition by c.cono, c.custno, c.prod order by c.cono, c.custno, c.prod, c.keyno) as 'RN'
into #xref
from icsec c
where c.rectype = 'C'
and c.insx = 1
--and c.prod = 'K-160931'
order by c.cono, c.custno, c.prod, c.transdt desc

Select 
Case
	When s.custPO Is Null
	Then 'TBD'
	Else s.custPO
End as 'CustPO'
,s.cono
,s.custno
,s.shipto
,s.user3
,l.[type]
--,d.custno as 'Consignment Customer'
,p.prod
,p.user3 as 'WPO'
,c.prod as 'CustomerProd'
,pp.descrip3
,pp.unitstock
,p.unit
,Case
	When p.unit Is Not Null
	Then u.unitconv
	Else 1
End as 'Conversion'
,Case
	When p.unit Is Not Null
	Then p.unit
	else pp.unitstock
End as 'UOM'


from ARSS s
Inner Join icspl l
	on	s.cono = l.cono
		and s.custno = l.custno
		and s.user3 = l.[type]
		and l.insx = 1

Left Join icsplp p
	on	l.cono = p.cono
		and l.[type] = p.[type]
		and p.insx = 1

left join #xref c
	on	p.cono = c.cono
		and p.prod = c.altprod
		and s.custno = c.custno
		and c.RN = 1

left join icsp pp
	on	p.cono = pp.cono
		and p.prod = pp.prod
		and pp.insx = 1

Left Join icsd d
	on	s.cono = d.cono
		and s.whse = d.whse
		and d.insx = 1

left join icseu u
	on	p.cono = u.cono
		and p.prod = u.prod
		and p.unit = u.units
		and u.insx = 1

where s.insx = 1
--and s.custpo = '5141-00-200'





