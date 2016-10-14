//
//  AnalyzeObject.h
//  PrepareBusiness
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 com.ruanmeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"
typedef void(^Blocks)(id model, NSString *ret, NSString *msg);

@interface AnalyzeObject : NSObject
/*
 *获取验证码
 */
+(void)getVerifyCodeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *用户注册
 */
+(void)registerWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *登录
 */
+(void)loginWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *找回密码
 */
+(void)findPwdWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *开店
 */
+(void)kaiDianWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *开店拒绝后调商家信息
 */
+(void)kaiDianInfoWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *获取省份列表
 */
+(void)getProvinceListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *获取市列表
 */
+(void)getCityListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *获取县列表
 */
+(void)getCountyListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
#pragma mark  --  商品
/*
 *获取商品
 */
+(void)getProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *上下架商品
 */
+(void)upOrDownProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *编辑产品前显示
 */
+(void)showProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *提交产品编辑
 */
+(void)submitEditProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *品牌列表
 */
+(void)getBrandsListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *规格列表
 */
#pragma  mark -- 评价

+(void)getStanderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *评价列表
 */
+(void)getRecomListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *评价详细
 */
+(void)getRecomDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
#pragma  mark ---  财务
/*
 *财务管理
 */
+(void)getFinanceManageWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *订单
 */
+(void)getSettleOrderWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *银行卡
 */
+(void)getCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *获取银行列表
 */
+(void)getBankListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *添加银行卡
 */
+(void)updateCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *提现
 */
+(void)WithDrawWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *提现记录
 */
+(void)getWithDrawRecordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *推荐收益
 */
+(void)getrecomIncomeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *收益详细
 */
+(void)getrecomIncomeDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

#pragma mark  --  订单

/*
 *订单管理
 */
+(void)getOrderManageWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *订单详细(待发货，待收货)
 */
+(void)get1OrderDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *订单详细(待评价，已完成)
 */
+(void)get2OrderDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *确认发货
 */
+(void)confirmDeliverGoodsWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *销售统计
 */
+(void)getSalesStatisticsWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *一级推荐人
 */
+(void)getLevel1RecommanWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *二级推荐人
 */
+(void)getLevel2RecommanWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

#pragma mark -- 消息中心
/*
 *消息中心
 */
+(void)getPushMessageWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *用户反馈
 */
+(void)getFeedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *反馈详情
 */
+(void)getFeedBackDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *审核反馈
 */
+(void)EVFeedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

#pragma  mark  -- 设置
/*
 *设置个人信息
 */
+(void)setPerInfoWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *设置
 */
+(void)getSetWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *留言反馈
 */
+(void)feedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
@end
