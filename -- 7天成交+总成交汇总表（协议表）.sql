 select
  count(agreement_id) as chengjiao_liang
  ,sum(case 
	  when datediff(to_date(sign_time),to_date(listing_time)) between 0 and 7
	  then 1
	  else 0
	  end) as jugement_7 --是否7天成交
  ,substr(sign_time,1,7) as qianyue_shijian
  ,tab_1.house_resblock_id
  ,tab_1.house_resblock_name
  ,tab_2.city_name
 from
	 (select
	  agreement_id
	  ,housedel_id
	  ,sign_time --实际签约时间
	  ,city_code --城市ID
	  ,house_resblock_id --小区ID
	  ,house_resblock_name
	  from
	  dw.dw_allinfo_agr_agreement_da
	  where
	  pt = '20181130000000'
	  and
	  substr(sign_time,1,7) = '2018-11'
	  /*and
	  city_code = 310000*/
	  and 
	  del_type_code = 990001001 --委托类型 990001001:买卖,990001002:租赁
	  ) as tab_1

	 inner join

	 (select
	  housedel_id
	  ,listing_time
	  ,city_name
	  from
	  dw.dw_allinfo_housedel_da
	  where
	  pt = '20181130000000'
	  /*and
	  city_code = 310000 */
	  and
      stat_function_code not in (107500000001,107500000006,107500000007,107500000008,107500000016,107500000017,107500000026)
	  ) as tab_2

	 ON tab_1.housedel_id = tab_2.housedel_id

 group by
  substr(sign_time,1,7)
  ,tab_1.house_resblock_id
  ,tab_1.house_resblock_name
  ,tab_2.city_name