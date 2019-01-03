# 2018年12月售房客户
# 主键为手机号码

select 
 distinct(seller_telephone) -- 卖方手机号码
 ,substr(real_sign_time,1,7)
 ,city_code
 ,housedel_id -- 房源ID
 ,house_resblock_id -- 小区ID
 ,agreement_amt
 from
 dw.dw_allinfo_agr_agreement_da
 where
 pt = '20190101000000'
 and substr(real_sign_time,1,7) = "2018-12"
 and city_code = "110000"
 and del_type = "买卖"


# 2018年12月换房客户

select * from
	(select * from
		(select 
		 distinct(buyer_telephone) as mfsj-- 买方手机号码
		 ,substr(real_sign_time,1,10)
		 ,city_code
		 ,housedel_id -- 房源ID
		 ,house_resblock_id -- 小区ID
		 ,house_bizcircle_name -- 商圈
		 ,agreement_amt
		 from
		 dw.dw_allinfo_agr_agreement_da
		 where
		 pt = '20190101000000'
		 and substr(real_sign_time,1,7) = "2018-12"
		 and city_code = "110000"
		 and del_type = "买卖") as tab_a
		where
		mfsj in (select 
				 distinct(seller_telephone) -- 卖方手机号码
				 from
				 dw.dw_allinfo_agr_agreement_da
				 where
				 pt = '20190101000000'
				 and substr(real_sign_time,1,7) = "2018-12"
				 and city_code = "110000"
				 and del_type = "买卖")
				 ) as tab_1

	inner join

    (select 
	 distinct(seller_telephone) as sj2 -- 卖方手机号码
	 ,substr(real_sign_time,1,10)
	 ,city_code
	 ,housedel_id -- 房源ID
	 ,house_resblock_id -- 小区ID
	 ,house_bizcircle_name -- 商圈
	 ,agreement_amt
	 from
	 dw.dw_allinfo_agr_agreement_da
	 where
	 pt = '20190101000000'
	 and substr(real_sign_time,1,7) = "2018-12"
	 and city_code = "110000"
	 and del_type = "买卖") as tab_2

	on tab_1.mfsj = tab_2.sj2


