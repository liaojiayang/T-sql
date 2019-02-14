
-- 武汉数据汇总-二手

select 
tab_fz.日期
,tab_fz.[月度]
,tab_fz.[行政区]
,tab_fz.商圈
,tab_mj.面积结构
,tab_js.居室结构
,tab_z.gp_fangliang
,tab_z.gp_junjia
,left(123,1)
,tab_z.xz_ke
,tab_z.cj_taoshu
,tab_z.cj_zhouqi
,tab_dk.cj_daikuan
,tab_z.cj_jine
,tab_zj.总价结构
,tab_z.cj_junjia
,left(123,1)
,tab_z.tj_zhang
,tab_z.tj_jiang
,tab_z.cj_yijia
from
    (select * from [dbo].[辅助-二手] where [辅助-二手].[日期] in (select max([辅助-二手].[日期]) from [辅助-二手])) AS tab_fz
-- 最大的月份

	LEFT OUTER JOIN

	 (-- 4. 最近月各商圈市场表现
	 select  [月] ,[商圈]
		 ,sum([总成交套数]) as cj_taoshu
		 ,avg([业主平均成交周期]) as cj_zhouqi
		 ,sum([新增挂牌房源量]) as gp_fangliang
		 ,(case when sum([新增挂牌房源套均总价] * [新增挂牌房源量]) <> 0	
			THEN sum([新增挂牌房源套均总价] * [新增挂牌房源量] * 10000)/sum([新增挂牌房源套均面积]*[新增挂牌房源量])
			ELSE NULL END) as gp_junjia
		 ,SUM([新增客源量]) AS xz_ke
		 ,sum([成交套均总价]*[总成交套数]) as cj_jine
		 ,(case when sum([成交套均总价]*[总成交套数]) <> 0
			then sum([成交套均总价]*[总成交套数]*10000)/sum([成交总面积])
			else null end) as cj_junjia
		,(case when sum([涨价房源涨价总次数]) <> 0
			then sum([涨价房源涨价总次数])/sum([调价房源调价总次数])
			else null end) as tj_zhang
		,(case when sum([降价房源降价总次数]) <> 0
			then sum([降价房源降价总次数])/sum([调价房源调价总次数])
			else null end) as tj_jiang
		,(case when sum([成交房源末次挂牌总价]) <> 0
			then sum([成交房源末次挂牌总价])/sum([成交套均总价]*[总成交套数])-1
			else null end) as cj_yijia
 
		from [dbo].[武汉-二手-总体]
		group by [月],[商圈]) as tab_z

	 ON tab_fz.[日期] = tab_z.[月] AND tab_fz.[商圈] = tab_z.[商圈]

	 LEFT OUTER JOIN

	 (--贷款占比
	 select [月],[商圈],
    (case 
		when sum(case when [付款方式] in ('商贷','组合贷','公积金贷款') then [总成交套数] end) <> 0
		then sum(case when [付款方式] in ('商贷','组合贷','公积金贷款') then [总成交套数] end)/sum([总成交套数]) * 100
		else null end) as cj_daikuan
	 from [dbo].[武汉-二手-付款方式] 
	 group by [月],[商圈]) as tab_dk

	 ON tab_fz.[日期] = tab_dk.[月] AND tab_fz.[商圈] = tab_dk.[商圈]

	 LEFT OUTER JOIN

	(-- 1. 最近月各商圈主力成交居室
	select [日期],[商圈],[居室结构] from
		(select * ,row_number() over(partition by [商圈],[日期] order by [二手-总成交套数] desc ) as jushi_jiansuo
		from [dbo].[武汉-二手-居室结构] where [二手-总成交套数]>0)as tb_js
	where tb_js.jushi_jiansuo = 1
	) as tab_js

	ON tab_fz.[日期] = tab_js.[日期] AND tab_fz.[商圈] = tab_js.[商圈]

	LEFT OUTER JOIN

	(-- 2. 最近月各商圈主力成交面积
	select [日期],[商圈],[面积结构] from
		(select * ,row_number() over(partition by [商圈],[日期] order by [二手-总成交套数] desc ) as mianji_jiansuo
		from [dbo].[武汉-二手-面积段] where [二手-总成交套数]>0) as tb_mj
	where tb_mj.mianji_jiansuo = 1
	) as tab_mj

	ON tab_fz.[日期] = tab_mj.[日期] AND tab_fz.[商圈] = tab_mj.[商圈]

	LEFT OUTER JOIN

	(-- 3. 最近月各商圈主力成交总价
	select [日期],[商圈],[总价结构] from
		(select * ,row_number() over(partition by [商圈],[日期] order by [二手-总成交套数] desc ) as zj_jiansuo
		from [dbo].[武汉-二手-总价段] where [二手-总成交套数]>0) as tb_zj
	where tb_zj.zj_jiansuo = 1) as tab_zj

	ON tab_fz.[日期] = tab_zj.[日期] AND tab_fz.[商圈] = tab_zj.[商圈]