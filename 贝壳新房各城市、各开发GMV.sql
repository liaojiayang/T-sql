-- 贝壳新房各城市、各开发GMV

SELECT
*
FROM
(SELECT
deal_id --成交ID
,city_id --城市ID
,resblock_id --楼盘ID
,sold_time --成销日期
,sold_price -- 成销金额
FROM dw.dw_nh_deal_info_new_da
WHERE pt = '20190124000000'
AND substr(sold_time,1,10) = '2018-12-01'
) as tab_a

INNER JOIN

(SELECT
distinct(resblock_id) as loupan_id
,city_code
,city_name
,group_name
,group_abbr
FROM
dw.dw_allinfo_house_house_da
WHERE pt = '20190124000000'
) as tab_b

ON tab_a.reslock_id = tab_b.loupan_id

--2018年各城市各楼盘GMV

SELECT
,city_id --城市ID
,resblock_id --楼盘ID
,substr(sold_time,1,4) --成销日期
,sum(sold_price) -- 成销金额
FROM dw.dw_nh_deal_info_new_da
WHERE pt = '20190124000000'
AND substr(sold_time,1,4) = '2018'
group by
city_id --城市ID
,resblock_id --楼盘ID
,substr(sold_time,1,4) --成销日期

