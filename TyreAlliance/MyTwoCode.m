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
@interface MyTwoCode ()

@end

@implementation MyTwoCode

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    
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

-(void)newView{
    
    UIImageView * bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    bgImgView.userInteractionEnabled=YES;
    bgImgView.image=[UIImage imageNamed:@"beijing"];
    [self.view addSubview:bgImgView];
//    bgImgView.image=[UIImage ImageForColor:[UIColor lightGrayColor]];
    
    
    UIImageView * codeImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgImgView.width, bgImgView.height)];
    codeImg.contentMode=UIViewContentModeCenter;
    [bgImgView addSubview:codeImg];
    codeImg.image=[UIImage imageNamed:@"erwei_two"];
    
    
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
    
    codeImg.centerY=(Vheight-self.NavImg.height-bottomView.height)/2;

}
-(void)shareBtnEvent:(UIButton *)sender{
    switch (sender.tag-100) {
        case 0:{
           [self authWithPlatform:UMSocialPlatformType_QQ];
        }
            break;
        case 1:{
           [self authWithPlatform:UMSocialPlatformType_Qzone];
        }
            break;
        case 2:{
           [self shareTextToPlatform:UMSocialPlatformType_WechatSession];
        }
            break;
        case 3:{
//            [self authWithPlatform:UMSocialPlatformType_WechatTimeLine];
           [self shareTextToPlatform:UMSocialPlatformType_WechatTimeLine];
        }
            break;
            
        default:
            break;
    }
    

}
//U盟分享

- (void)shareTextToPlatform:(UMSocialPlatformType)platformType
{
    NSString *text = @"社会化组件U-Share将各大社交平台接入您的应用，快速武装App。";
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    messageObject.text = text;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        
        
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        } else {
            message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        if (error.code!=2010) {
            [alert show];
        }
 
    }];
}

   //平台授权
-(void)authWithPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager]authWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
                UMSocialAuthResponse *authresponse = result;
                NSString *message = [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n",(int)error.code,authresponse.uid,authresponse.accessToken];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                      otherButtonTitles:nil];
                [alert show];
    }];
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
//-(void)authWithPlatform:(UMSocialPlatformType)platformType
//{
//    [[UMSocialManager defaultManager] authWithPlatform:platformType completion:^(id result, NSError *error) {
//        [self.tableView reloadData];
//        UMSocialAuthResponse *authresponse = result;
//        NSString *message = [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n",(int)error.code,authresponse.uid,authresponse.accessToken];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }];
//    
//}