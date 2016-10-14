//
//  AnalyzeObject.m
//  PrepareBusiness
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 com.ruanmeng. All rights reserved.
//

#import "AnalyzeObject.h"
#import "AFNetworking.h"
#import "AFAppDotNetAPIClient.h"
//#import "AFURLRequestSerialization.h"

@implementation AnalyzeObject



//-(void)loginOrRegisterWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
//    [self loadData:dic withUrl:@"tools/Interface.ashx/" WithBlock:^(id model, NSString *ret, NSString *msg) {
//        block(model,ret,msg);
//        
//    }];
//
//}

-(void)loadData:(NSDictionary *)dic withUrl:(NSString *)url WithBlock:(void (^)(id, NSString *, NSString *))block{
 
 [[AFAppDotNetAPIClient sharedClient]GET:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
 
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 NSNumber *retn = [responseObject objectForKey:@"msgcode"];
 NSString *ret = [NSString stringWithFormat:@"%@",retn];
 
 NSString *msg =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
 
 if ([ret isEqualToString:@"1"]) {
 
 block([responseObject objectForKey:@"data"],ret,msg);
 }else{
 block(nil,ret,msg);
 
 }
 
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
 block(nil,nil,@"当前无网络环境、请检查网络连接.");
 
 }];
 
 
 }


/*
 *获取验证码
 */
+(void)getVerifyCodeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Message"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *用户注册
 */
+(void)registerWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"RegMeb",@"type":@"1"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *用户登录
 */

+(void)loginWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"User_Login",@"type":@"1"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
//    [self ];
    
}
/*
 *找回密码
 */
+(void)findPwdWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"User_look_pwd"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *开店
 */
+(void)kaiDianWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    
    
    
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Kai_Dian"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
/*
 *开店拒绝后调商家信息
 */
+(void)kaiDianInfoWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Buss_info"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
///*
// *获取地理列表
// */
//+(void)getGeoListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
//    AnalyzeObject * ana=[AnalyzeObject new];
//    [ana loadData:dic withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
//        block(model,ret,msg);
//    }];
//}
/*
 *获取省份列表
 */
+(void)getProvinceListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"province"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *获取市列表
 */
+(void)getCityListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"city"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *获取县列表
 */
+(void)getCountyListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"county"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
#pragma mark  --  商品

/*
 *获取商品
 */
+(void)getProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Product_Management"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
/*
 *上下架商品 
 */
+(void)upOrDownProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Product_UpDown"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *编辑产品前显示
 */
+(void)showProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Product_Edit_Show"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *提交产品编辑
 */
+(void)submitEditProductDatasWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Product_Edit_Submit"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *品牌列表
 */
+(void)getBrandsListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"PinPai",@"ye":@"1"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *规格列表
 */
+(void)getStanderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GuiGe"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
#pragma  mark -- 评价
/*
 *评价列表
 */
+(void)getRecomListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"PingJia_Management"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *评价详细
 */
+(void)getRecomDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"PingJia_Info"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
#pragma  mark ---  财务
/*
 *财务管理
 */
+(void)getFinanceManageWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Money_Management"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *财务管理
 */
+(void)getSettleOrderWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"JieSuan_Order"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *订单管理
 */
+(void)getOrderManageWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Zi_Order_List",@"role":@"1"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *订单详细(待发货，待收货)
 */
+(void)get1OrderDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Ziporder_Info"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *订单详细(待评价，已完成)
 */
+(void)get2OrderDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Porder_Info"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *银行卡
 */
+(void)getCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"My_bank"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *获取银行列表
 */
+(void)getBankListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Bank_List"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
    
}
/*
 *添加银行卡
 */
+(void)updateCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Edit_bank"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *提现
 */
+(void)WithDrawWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Many_TiXian"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *提现记录
 */
+(void)getWithDrawRecordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"TiXian_list"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *推荐收益
 */
+(void)getrecomIncomeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"TuiJian_ShouYi"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *收益详细
 */
+(void)getrecomIncomeDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"TuiJian_ShouYi_MingXi"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
#pragma mark  --  订单


/*
 *确认发货
 */
+(void)confirmDeliverGoodsWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"FaHuo",@"role":@"1"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *销售统计
 */
+(void)getSalesStatisticsWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Sales_Statistics"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *一级推荐人
 */
+(void)getLevel1RecommanWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"My_Son"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *二级推荐人
 */
+(void)getLevel2RecommanWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"My_Grandson"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
#pragma mark -- 消息中心
/*
 *消息中心
 */
+(void)getPushMessageWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Pushs"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *用户反馈
 */
+(void)getFeedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"ShouHou_Fk"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
/*
 *反馈详情
 */
+(void)getFeedBackDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"ShouHou_Fk_Info"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
/*
 *审核反馈
 */
+(void)EVFeedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"ShenHe_Fankui"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
#pragma  mark  -- 设置
/*
 *设置个人信息
 */
+(void)setPerInfoWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Update_info"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *设置
 */
+(void)getSetWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Set"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
/*
 *留言反馈
 */
+(void)feedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Fan_Kui"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"tools/Interface.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

@end
