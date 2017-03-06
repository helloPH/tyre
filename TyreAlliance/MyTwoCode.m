//
//  MyTwoCode.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MyTwoCode.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "UMSocialUIManager.h"
//#import "umsocial"
@interface MyTwoCode ()
@property (nonatomic,strong)UIImageView * imgEr;
@property (nonatomic,strong)NSString * imgUrlString;
@end

@implementation MyTwoCode

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"我的二维码";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
        [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reshData{
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
    [self startAnimating:nil];
    [AnalyzeObject geterCodeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            _imgUrlString=[ImgDuanKou stringByAppendingString:model[@"erweima"]];
            [_imgEr setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:model[@"erweima"]]]];
        }else{
            [self showPromptBoxWithSting:@"二维码获取失败!"];
        }
    }];
}

-(void)newView{
    
    UIImageView * bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    bgImgView.userInteractionEnabled=YES;
    bgImgView.image=[UIImage imageNamed:@"beijing"];
    [self.view addSubview:bgImgView];
//    bgImgView.image=[UIImage ImageForColor:[UIColor lightGrayColor]];
    
    
    
    UIImageView * codeBgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 190*self.scale, 190*self.scale)];
    codeBgImg.center=CGPointMake(Vwidth/2, bgImgView.height/2);
    codeBgImg.backgroundColor=[UIColor whiteColor];
    codeBgImg.layer.cornerRadius=20*self.scale;
    codeBgImg.layer.masksToBounds=YES;
    codeBgImg.layer.borderWidth=1;
    codeBgImg.layer.borderColor=navigationControllerColor.CGColor;
    [bgImgView addSubview:codeBgImg];
    
    
    UIImageView * codeImg=[[UIImageView alloc]initWithFrame:codeBgImg.frame];
    codeImg.size=CGSizeMake(codeBgImg.width-25*self.scale, codeBgImg.height-25*self.scale);
//    codeImg.contentMode=UIViewContentModeScaleAspectFit;
    codeImg.center=codeBgImg.center;
//    codeImg.contentMode=UIViewContentModeCenter;
    [bgImgView addSubview:codeImg];
    _imgEr=codeImg;
    
    
    UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vwidth*0.4)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.bottom=self.view.bottom;
    
    
    NSArray * titles=@[@{@"title":@"QQ",@"img":@"qq_icon"},
                       @{@"title":@"QQ空间",@"img":@"zone_tenct"},
                       @{@"title":@"微信",@"img":@"wecat_green"},
                       @{@"title":@"朋友圈",@"img":@"freind_quan"}];
    CGFloat spX=20*self.scale;
    CGFloat spY=40*self.scale;
    CGFloat marginX=15*self.scale;
    CGFloat btnW=(Vwidth-marginX*2-spX*3)/4;
    CGFloat btnH=btnW;
    for (int i =0; i < titles.count; i ++) {
        CGFloat btnX=marginX+i%4*(btnW+spX);
        CGFloat btnY=20*self.scale+i/4*(btnH+spY);
        
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag=i+100;
        [btn addTarget:self action:@selector(shareBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageNamed:[titles[i] valueForKey:@"img"]] forState:UIControlStateNormal];
        [bottomView addSubview:btn];
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.bottom, btn.width, 20*self.scale)];
        [bottomView addSubview:title];
        title.textAlignment=NSTextAlignmentCenter;
        title.font=SmallFont(self.scale);
        title.textColor=blackTextColor;
        title.text=[titles[i] valueForKey:@"title"];
        
    
    }
    
    codeBgImg.centerY=(Vheight-self.NavImg.height-bottomView.height)/2;
    codeImg.centerY=codeBgImg.centerY;
}
-(void)shareBtnEvent:(UIButton *)sender{
    switch (sender.tag-100) {
        case 0:{
            [self shareImageAndTextToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case 1:{
            [self shareImageAndTextToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case 2:{
           [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case 3:{
           [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
            
        default:
            break;
    }
    

}
////U盟分享
//- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    shareObject.title= @"胎之盟";
//    shareObject.descr= @"分享我的二维码";
//    [shareObject setShareImage:_imgEr.image];
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            [self startAnimatingWithString:[NSString stringWithFormat:@"%@",error]];
//            
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                [self startAnimatingWithString:@"分享成功"];
//            }else{
//                [self startAnimatingWithString:@"分享失败"];
//            }
//        }
//        
//    }];
//}
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"胎之盟" descr:@"胎之盟，一款专门做轮胎的app。。。" thumImage:[UIImage imageNamed:@"iconShare"]];
    //设置网页地址
    shareObject.webpageUrl =_imgUrlString;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
    
    
//    NSString *text = @"胎之盟";
//
//
////     UMShareObject * share= [UMShareObject shareObjectWithTitle:text descr:text thumImage:_imgEr.image];
//    
//    
////    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    UMShareWebpageObject * share=[[UMShareWebpageObject alloc]init];
//    share.webpageUrl=_imgUrlString;
//    share.title=@"胎之盟";
//    [share setDescr:@"胎之盟，一款专门做轮胎的app。。。"];
//    [share setThumbImage:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:@"/upload/lg.png"]]];
//    share.
//    
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
////    messageObject.text = text;
//    messageObject.shareObject=share;
//    
//    
//  
//    
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        NSString *message = nil;
//        
//        
//        if (!error) {
//            message = [NSString stringWithFormat:@"分享成功"];
//        } else {
//            message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
//            
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        if (error.code!=2010) {
//            [alert show];
//        }
// 
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
