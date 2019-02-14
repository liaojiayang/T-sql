-- 成交量-城市+核心盘
select
tab_z.日期
,tab_z.city_name as 城市
,tab_z.z_cj as 成交量
,tab_z.z_7 as 快速成交
,tab_hx.hx_cj as 核成交量
,tab_hx.hx_7 as 核快速成交
,tab_jg.junjia as 成交均价
,tab_hx_junjia.junjia as 核成交均价
,tab_dk.daikan as 带看量
,tab_dk_hx.daikan as 核带看量
,tab_fy.xz_f as 新增房源
,tab_fy_hx.xz_f as 核新增房源
,tab_ke.new_ke as 新增客源
,tab_tj.tiao_jiang as 调降
,tab_tj.tiao_zhang as 调涨
,tab_tj_hx.tiao_jiang as 核调降
,tab_tj_hx.tiao_zhang as 核调涨
from
	(select 
	[日期],city_name,
	sum([成交量]) as z_cj,sum([7天成交量]) as z_7
	from 
	(select * from [dbo].[7天成交和总成交-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0
	group by [日期],city_name) as tab_z

left outer join

	(select 
	[日期],city_name,
	sum([成交量]) as hx_cj,sum([7天成交量]) as hx_7
	from 
	(select * from [dbo].[7天成交和总成交-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 and hexin = 1
	group by [日期],city_name) as tab_hx
on tab_z.[日期] = tab_hx.[日期] and tab_z.city_name = tab_hx.city_name

left outer join
	(select 
	[日期],city_name,sum([金额])/sum([面积]) as junjia
	from
	(select * from [dbo].[成交面积-金额]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	group by [日期],city_name) as tab_jg
on tab_z.[日期] = tab_jg.日期 and tab_z.city_name = tab_jg.city_name

left outer join
	(select 
	[日期],city_name,sum([金额])/sum([面积]) as junjia
	from
	(select * from [dbo].[成交面积-金额]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	and hexin = 1
	group by [日期],city_name) as tab_hx_junjia
on tab_z.[日期] = tab_hx_junjia.日期 and tab_z.city_name = tab_hx_junjia.city_name

left outer join
	(-- 带看量
	select 
	[日期],city_name,sum([带看量]) as daikan
	from
	(select * from [dbo].[带看量-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	group by [日期],city_name) as tab_dk
on tab_z.[日期] = tab_dk.日期 and tab_z.city_name = tab_dk.city_name

left outer join
	(-- 核心带看量
	select 
	[日期],city_name,sum([带看量]) as daikan
	from
	(select * from [dbo].[带看量-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	and hexin = 1
	group by [日期],city_name) as tab_dk_hx
on tab_z.[日期] = tab_dk_hx.日期 and tab_z.city_name = tab_dk_hx.city_name

left outer join
	(select 
	[date],tab_1.[city_name],sum([new_house]) as xz_f
	from
	(select * from [dbo].[新增房源量-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[resblock_id] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	group by [date],tab_1.[city_name]) as tab_fy
on tab_z.[日期] = tab_fy.[date] and tab_z.city_name = tab_fy.city_name

left outer join
	(select 
	[date],tab_1.[city_name],sum([new_house]) as xz_f
	from
	(select * from [dbo].[新增房源量-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[resblock_id] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	and hexin = 1
	group by [date],tab_1.[city_name]) tab_fy_hx
on tab_z.[日期] = tab_fy_hx.[date] and tab_z.city_name = tab_fy_hx.city_name

left outer join
	(select * from [dbo].[新增客源-城市]) as tab_ke
on tab_z.[日期] = tab_ke.riqi and tab_z.city_name = tab_ke.city_name

left outer join
-- 总体调价
	(select 
	[日期],tab_2.[city_name],sum([调涨量])/(sum([调涨量])+sum([调降量])) as tiao_zhang,(sum([调涨量])/(sum([调涨量])+sum([调降量]))-1) as tiao_jiang
	from
	(select * from [dbo].[调价-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	group by [日期],tab_2.[city_name]) as tab_tj
on tab_z.[日期] = tab_tj.日期 and tab_z.city_name = tab_tj.city_name

left outer join
-- 核心盘调价
	(select 
	[日期],tab_2.[city_name],sum([调涨量])/(sum([调涨量])+sum([调降量])) as tiao_zhang,(sum([调涨量])/(sum([调涨量])+sum([调降量]))-1) as tiao_jiang
	from
	(select * from [dbo].[调价-小区]) as tab_1
	inner join
	(select * from [dbo].[城市-楼盘-核心盘]) as tab_2
	on tab_1.[小区ID] = tab_2.[resblock_id] 
	where hexin_tolat > 0 
	and hexin = 1
	group by [日期],tab_2.[city_name]) as tab_tj_hx
on tab_z.[日期] = tab_tj_hx.日期 and tab_z.city_name = tab_tj_hx.city_name
where left(tab_z.日期,4) >= year(getdate())-1 
order by tab_z.city_name,tab_z.日期