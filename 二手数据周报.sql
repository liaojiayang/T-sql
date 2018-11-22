# 二手数据周报
select
count(distinct id)
,year(create_time)
,weekofyear(create_time)
,holder_corp_name
from
dw.dw_evt_showing_detail_all_info_da
where
pt='20181118000000' --要改
and holder_corp_code in ('B00001','WXLJ8888','N00001','ZZLJ8888','SH8888','E00001','A10001','LSY8888',
	'XALJ8888','HF888888','SJZLJ8888','ZS8888','SUZ8888','WH9999','H10001','CQ9999','CS9999') --代理11城
and to_date(create_time) >= date_sub(CURRENT_DATE,7) --要改
and biz_type = 200200000001 --业务类型买卖，200200000002是租赁
group by
weekofyear(create_time)
,year(create_time)
,holder_corp_name