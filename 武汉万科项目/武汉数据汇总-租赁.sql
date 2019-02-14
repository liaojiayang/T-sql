
--
select
 fuzhu. [日期]
 ,fuzhu.[月度]
 ,fuzhu.[行政区]
 ,fuzhu.[商圈]
 ,fuzhu.[租赁-居室]
 ,ts.taoshu
 ,mj.[面积结构]
 ,dsc.fangyuanliang
 ,dsc.fangyuanjunjia
 ,left(123,1)
 ,dsc.zujin
 ,left(123,1)
 ,dsc.zhouqi
 ,dsc.tiaozhang
 ,dsc.tiaojiang
 
 from
 (select * from [dbo].[辅助-租赁] where [辅助-租赁].[日期] in (select max([辅助-租赁].[日期]) from [辅助-租赁])) as fuzhu

 LEFT OUTER JOIN

 ( select [月],[商圈],[居室结构]
,sum([新增挂牌房源量]) as fangyuanliang
,nullif(sum([新增挂牌房源套均面积]*[新增挂牌房源每平米租金]*[新增挂牌房源量]),0)/sum([新增挂牌房源套均面积]*[新增挂牌房源量]) as fangyuanjunjia
,nullif(sum([成交套均租金]*[总成交套数]) ,0)/sum([成交套均面积]*[总成交套数]) as zujin
,avg([业主平均成交周期]) as zhouqi
,nullif(sum([涨价房源涨价总次数]),0)/sum([调价房源调价总次数]) as tiaozhang
,nullif(sum([降价房源降价总次数]),0)/sum([调价房源调价总次数]) as tiaojiang
from [dbo].[武汉-租赁-整体]
group by [月],[商圈],[居室结构]) AS dsc

 ON fuzhu.[日期] = dsc.[月] AND fuzhu.[商圈] = dsc.[商圈] AND fuzhu.[租赁-居室] = dsc.[居室结构]

 LEFT OUTER JOIN

 (-- 各居室主力面积
  select [日期],[商圈],[居室结构],[面积结构]
  from
	 (select * ,row_number() over(partition by [日期],[商圈],[居室结构] order by [整租-总成交套数] desc) as aim
	 from [dbo].[武汉-租赁-面积段] where [整租-总成交套数]>0) as tab_mj
  where aim = 1) AS mj

  ON fuzhu.[日期] = mj.[日期] AND fuzhu.[商圈] = mj.[商圈] AND fuzhu.[租赁-居室] = mj.[居室结构]

  LEFT OUTER JOIN
  (-- 各居室成交套数
  select [日期],[商圈],[居室结构],sum([整租-总成交套数]) as taoshu
  from [dbo].[武汉-租赁-面积段]
  group by [日期],[商圈],[居室结构]) as ts

 ON fuzhu.[日期] = ts.[日期] AND fuzhu.[商圈] = ts.[商圈] AND fuzhu.[租赁-居室] = ts.[居室结构]
