-- 武汉核心盘成交均价
select 
jj.日期
,jj.区域
,hx.resblock_name
,jj.金额/jj.面积 as junjia
 from
(select * from [dbo].[城市-楼盘-核心盘]
where city_code = 420100
and hexin =1) AS hx
INNER JOIN
(select * from [dbo].[成交面积-金额]
where [城市]= '武汉市') jj
ON hx.resblock_id = jj.小区ID
ORDER BY jj.日期