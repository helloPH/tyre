//
//  SuperViewController.m
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()<UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)AlertBlock alertBlock;
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,strong)UIDatePicker *TimePickerView;
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)NSMutableArray *timeArr,*shiArr,*quArr;
@property(nonatomic,strong)UIImageView *SelectImg;
@property(nonatomic,strong)NSArray *addressArr;
@end
@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];

    
    // Do any additional setup after loading the view.
    _appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480)
    {
         _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self preferredStatusBarStyle];

    
    
    
   self.navigationController.navigationBarHidden=YES;
    
    self.view.backgroundColor = superBackgroundColor;
    self.NavImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    self.NavImg.backgroundColor=navigationControllerColor;
    self.NavImg.userInteractionEnabled = YES;
    self.NavImg.clipsToBounds = YES;
    [self.view  addSubview:self.NavImg];
    [self.NavImg addGestureRecognizer:tap];
    
    self.TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*self.scale, 20, self.view.width-90*self.scale, 44)];
    self.TitleLabel.textColor = [UIColor whiteColor];
    self.TitleLabel.textAlignment = 1;
    self.TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17*_scale];
    self.TitleLabel.backgroundColor = [UIColor clearColor];
    [self.NavImg addSubview:self.TitleLabel];
    
    _activityVC=[[UIActivityIndicatorView alloc]init];
    _activityVC.frame=CGRectMake(0, 0, self.view.width, self.view.height);
    _activityVC.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    _activityVC.color=[UIColor blackColor];
    
 //   _Navline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-1*self.scale, self.view.width, 1*self.scale)];
//    _Navline.backgroundColor=blackLineColore;
   //[self.NavImg addSubview:_Navline];
    
   
    
    
}

-(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleBy
{
    CGSize size = CGSizeMake(image.size.width * scaleBy, image.size.height * scaleBy);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformScale(transform, scaleBy, scaleBy);
    CGContextConcatCTM(context, transform);
    
    // Draw the image into the transformed context and return the image
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}
-(void)dismissKey{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
}

-(void)openUrl:(NSString *)string{

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]]];

}
-(void)showBtnEmpty:(BOOL)show{
    if (!_btnEmpty) {
        _btnEmpty=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*self.scale, 100*self.scale)];
        _btnEmpty.image=[UIImage imageNamed:@"noData"];
        _btnEmpty.contentMode=UIViewContentModeScaleAspectFit;
        _btnEmpty.center=CGPointMake(Vwidth/2, Vheight/2+20*self.scale);
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(0, _btnEmpty.height+2*self.scale, _btnEmpty.width, 20*self.scale)];
        lable.textColor=blackTextColor;
        lable.font=DefaultFont(self.scale);
        lable.textAlignment=NSTextAlignmentCenter;
        lable.text=@"暂无数据";
        [_btnEmpty addSubview:lable];
        [self.view addSubview:_btnEmpty];
        _btnEmpty.hidden=YES;
    }
    
    
    if (show) {
        _btnEmpty.hidden=NO;
    }else{
        _btnEmpty.hidden=YES;
//         [_btnEmpty removeFromSuperview];
    }
}
-(void)showFailed:(BOOL)show{
    if (show) {
        if (_loadFailed) {
            
        }else{
            _loadFailed=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*self.scale, 100*self.scale)];
            _loadFailed.image=[UIImage imageNamed:@"loadFailed"];
            _loadFailed.contentMode=UIViewContentModeCenter;
            _loadFailed.center=CGPointMake(Vwidth/2, (Vheight-self.NavImg.height)/2+self.NavImg.height);
            
            [self.view addSubview:_loadFailed];
            
        }
        
    }else{
        if (_loadFailed) {
            
            [_loadFailed removeFromSuperview];
            _loadFailed=nil;
        }
        
    }
    
}


-(void)makePhoneWithTel:(NSString *)string{


    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",string];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];


}


-(NSMutableAttributedString*)stringColorAllString:(NSString *)string orgin:(NSString *)orgin{



    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range=[string rangeOfString:[NSString stringWithFormat:@"%@",orgin]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    
    return str;


}


-(NSMutableAttributedString *)stringColorAllString:(NSString *)string redString:(NSString *)redString{
    
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range=[string rangeOfString:[NSString stringWithFormat:@"%@",redString]];
    
    [str addAttribute:NSForegroundColorAttributeName value:TextColor range:range];
    
    return str;
    
}

-(NSMutableAttributedString *)stringColorAllString:(NSString *)string YelloyString:(NSString *)redString{
    
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range=[string rangeOfString:[NSString stringWithFormat:@"%@",redString]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:150/255.0 blue:0 alpha:1] range:range];
    
    return str;
    
}






-(NSString *)getToday{

    NSDate *date = [NSDate date];
    NSDateFormatter *fo =[[NSDateFormatter alloc]init];
    [fo setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [fo stringFromDate:date];
    return str;

}

-(void)ShowAlertWithMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)setName:(NSString *)name{
    self.navigationController.title=name;
}
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
  //alert.tintColor=pinkTextColor;
    [alert show];
    _alertBlock=block;
}
-(void)showSAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate block:(AlertBlock)block{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles: @"确定",nil];
    //alert.tintColor=pinkTextColor;
    [alert show];
    _alertBlock=block;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (_alertBlock) {
        _alertBlock(buttonIndex);
    }
}
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:fone, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return   [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}
-(NSDictionary *)Style{
    NSDictionary *style=@{
                          @"body":[UIFont systemFontOfSize:12*self.scale],
                          @"Big":[UIFont systemFontOfSize:14*self.scale],
                          @"red":[UIColor redColor],
                          @"orange":@[[UIColor colorWithRed:255/255.0 green:132/225.0 blue:0/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.scale]],
                          @"gray13":@[[UIColor grayColor],[UIFont fontWithName:@"HelveticaNeue" size:13*self.scale  ]],
                          @"red13":@[[UIColor redColor],[UIFont systemFontOfSize:13*self.scale]],
                          @"gray10":@[[UIColor grayColor],[UIFont systemFontOfSize:10*self.scale]],
                          @"gray12":@[[UIColor grayColor],[UIFont systemFontOfSize:12*self.scale]],
                          @"red12":@[[UIColor redColor],[UIFont systemFontOfSize:12*self.scale]],
                          @"red15":@[[UIColor redColor],[UIFont systemFontOfSize:15*self.scale]],
                          @"Org10":@[  [UIColor colorWithRed:255/255 green:136/255.0 blue:34/255.0 alpha:1],[UIFont systemFontOfSize:10*self.scale]],
                          };
    return style;
}
#pragma mark-----请求服务器  开始和结束的动画

-(void)startAnimating:(NSString *)set{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD=nil;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.appdelegate.window animated:YES];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    if ([[NSString stringWithFormat:@"%@",set] isEmptyString]) {
        set=@"正在加载...";
    }
  
    self.HUD.labelText = set;
    self.HUD.removeFromSuperViewOnHide = YES;
    
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aniTap:)];
    [self.HUD addGestureRecognizer:tap];
//    self.HUD.top=300;
//      self.HUD.frame=CGRectMake(0, 1000, Vwidth, Vheight);
}
-(void)aniTap:(UITapGestureRecognizer *)tap{
    [self stopAnimating];
}


-(void)startAnimatingWithString:(NSString *)set{
    if ([[NSString stringWithFormat:@"%@",set] isEmptyString]) {
        return;
    }
    
    self.HUDString = [MBProgressHUD showHUDAddedTo:self.appdelegate.window animated:YES];
    self.HUDString.mode = MBProgressHUDModeText;
    self.HUDString.labelText = set;
    self.HUDString.removeFromSuperViewOnHide = YES;
    [self.HUDString hide:YES afterDelay:1.5];
}

-(void)stopAnimating{
    [self.HUD hide:YES];
}

//////  ------   彭辉  自家   -----
-(void)showPromptBoxWithSting:(NSString *)prompt{
    UILabel * noticeLabel=[[UILabel alloc]init];
    noticeLabel.text=prompt;
    noticeLabel.font=[UIFont systemFontOfSize:13*self.scale];
    noticeLabel.size=[self Text:prompt Size:CGSizeMake(Vwidth/2, 2000) Font:DefaultFont(self.scale)];
    noticeLabel.height=noticeLabel.height+10*self.scale;
    noticeLabel.width=noticeLabel.width+10*self.scale;
    noticeLabel.numberOfLines=0;
    noticeLabel.layer.cornerRadius=5*self.scale;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    //    noticeLabel.alpha=0.8;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    
    noticeLabel.center=self.view.center;
    [self.view addSubview:noticeLabel];
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
        noticeLabel.alpha=0;
    } completion:^(BOOL finished) {
        [noticeLabel removeFromSuperview];
    }];
}
-(void)showPromptInWindowWithString:(NSString *)prompt{
    UILabel * noticeLabel=[[UILabel alloc]init];
    noticeLabel.text=prompt;
    noticeLabel.font=[UIFont systemFontOfSize:13*self.scale];
    noticeLabel.size=[self Text:prompt Size:CGSizeMake(Vwidth/2, 2000) Font:DefaultFont(self.scale)];
    noticeLabel.height=noticeLabel.height+10*self.scale;
    noticeLabel.width=noticeLabel.width+10*self.scale;
    noticeLabel.numberOfLines=0;
    noticeLabel.layer.cornerRadius=5*self.scale;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    //    noticeLabel.alpha=0.8;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    
    noticeLabel.center=self.view.center;
    [self.appdelegate.window addSubview:noticeLabel];
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
        noticeLabel.alpha=0;
    } completion:^(BOOL finished) {
        [noticeLabel removeFromSuperview];
    }];
}
#pragma mark - 屏幕选转
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
