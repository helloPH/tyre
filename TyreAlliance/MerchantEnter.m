//
//  MerchantEnter.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MerchantEnter.h"
#import "BeComeMerchant.h"
#import "IQKeyboardManager.h"

@interface MerchantEnter ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSArray * tfs;
@property (nonatomic,strong)UIButton * registBtn;
@property (nonatomic,assign)NSInteger time;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)NSString * temTel;
@property (nonatomic,strong)UIButton * verBtn;

@property (nonatomic,strong)UITextField * tfTel;
@property (nonatomic,strong)UITextField * tfVer;
@property (nonatomic,strong)UITextField * tfPwd;

@property (nonatomic,strong)NSString * textYan;
@end

@implementation MerchantEnter

- (void)viewDidLoad {
    [super viewDidLoad];
    _textYan=@"";
    [self newNavi];
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"商家入驻";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismissKey{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate=self;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];
    [_scrollView addGestureRecognizer:tap];
    
    NSArray * titles=@[@{@"img":@"phone_tel",@"title":@"请输入手机号码"},
                       @{@"img":@"key_yao",@"title":@"请输入验证码"},
                       @{@"img":@"mima_ma",@"title":@"设置6-12位字母、数字或符号组合"}];
    CGFloat setY=0;
     NSMutableArray * tfms=[NSMutableArray array];
    for (int i = 0; i < titles.count; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale + i * 40*self.scale, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cellView];
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 20*self.scale, 20*self.scale)];
        imgView.image=[UIImage imageNamed:[titles[i] valueForKey:@"img"]];
        imgView.contentMode=UIViewContentModeCenter;
        [cellView addSubview:imgView];
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(imgView.right+10*self.scale, imgView.top, Vwidth-50*self.scale, 20*self.scale)];
        [cellView addSubview:tf];
        tf.delegate=self;
        tf.tag=100+i;
        tf.font=DefaultFont(self.scale);
        tf.placeholder=[titles[i] valueForKey:@"title"];
        setY=cellView.bottom;
        if (i==0) {
            _tfTel=tf;
            tf.keyboardType=UIKeyboardTypePhonePad;
            [tf limitText:@11];
        }
       
        
        
        if (i==1) {
            _tfVer=tf;
            [_tfVer limitText:@4];
            tf.keyboardType=UIKeyboardTypeNumberPad;
            UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 8*self.scale, 100*self.scale, 24*self.scale)];
            btn.titleLabel.font=SmallFont(self.scale);
            btn.right=Vwidth-10*self.scale;
            [cellView addSubview:btn];
            btn.layer.cornerRadius=4;
            btn.layer.masksToBounds=YES;
            btn.layer.borderWidth=0.5;
            btn.layer.borderColor=lightOrangeColor.CGColor;
            [btn setTitleColor:lightOrangeColor forState:UIControlStateNormal];
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=1000;
            _verBtn=btn;
        }
        if (i==2) {
            _tfPwd=tf;
            _tfPwd.secureTextEntry=YES;
            [_tfPwd limitText:@12];
            _tfPwd.keyboardType=UIKeyboardTypeAlphabet;
        }
        [tfms addObject:tf];
    }
    _tfs=[NSArray arrayWithArray:tfms];
    
    
    _registBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    [_scrollView addSubview:_registBtn];
    _registBtn.layer.cornerRadius=4;
    _registBtn.layer.masksToBounds=YES;
    _registBtn.titleLabel.font=BigFont(self.scale);
    [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn setBackgroundImage:[UIImage ImageForColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_registBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
    _registBtn.selected=NO;
    _registBtn.userInteractionEnabled=NO;
    _registBtn.tag=1001;
    [_registBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)timeStart{
    _time=60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timejian) userInfo:nil repeats:YES];
    //    _timer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        [self timejian];
    //    }];
}
-(void)timejian{
    //    UIButton *=(UIButton *)[self.view viewWithTag:5];
    if (_time == 0) {
        [_timer invalidate];
        _timer = nil;
        _verBtn.enabled=YES;
        [_verBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
//        _time = 60;
    }else
    {
        [_verBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)_time] forState:UIControlStateNormal];
        _verBtn.enabled=NO;
        _time--;
    }
}
-(void)btnEvent:(UIButton*)sender{

    //用户名或手机号
    
    if (![_tfTel.text isValidateMobile]) {
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        return ;
    }
    if (sender.tag==1000) {
        NSDictionary * dic=@{@"tel":_tfTel.text,@"type":@"0"};//,@"action":@"Message"};
        _temTel=_tfTel.text;
        [self startAnimating:nil];
        [AnalyzeObject getVerifyCodeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                _textYan=[(NSDictionary *)model valueForKey:@"code"];
//                _tfVer.text=_textYan;
                [self timeStart];
            }else{
                [self ShowAlertWithMessage:msg];
            }
        }];
        return ;
    }

    
    //注册
//    if (![_tfTel.text isValidateMobile]) {
//        [self ShowAlertWithMessage:@"请输入正确的手机号码格式"];
//        return ;
//    }
    
    if (_temTel) {
        if (![_tfTel.text isEqualToString:_temTel]) {
            [self ShowAlertWithMessage:@"提交手机号与获取验证码手机号不一致!"];
            return ;
        }
    }
    

    

    if (![_textYan isEqualToString:_tfVer.text]) {
        [self showPromptBoxWithSting:@"请输入正确的验证码"];
        return ;
    }
    
    if (![_tfPwd.text isValidatePassword]) {
        [self ShowAlertWithMessage:@"请输入正确的密码格式"];
        return ;
    }
    if (sender.tag==1001) {
        NSDictionary * dic=@{@"tel":[NSString stringWithFormat:@"%@",_tfTel.text],
                             @"pwd":[NSString stringWithFormat:@"%@",_tfPwd.text]
//                             ,
//                             @"yqm":[NSString stringWithFormat:@"%@",_tfVer.text]
                             };
    
        [AnalyzeObject registerWithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"1"]) {
                [[Stockpile sharedStockpile] setID:[NSString stringWithFormat:@"%@",models]];
                [self showPromptInWindowWithString:@"注册成功，请申请成为商家！"];
                
                BeComeMerchant * become=[BeComeMerchant new];
                [self.navigationController pushViewController:become animated:YES];
    
         
            }else{
                [self showPromptBoxWithSting:msg];
            }
          

        }];
    }

}

#pragma  mark -- textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 判断  提交按钮是否可用
    _registBtn.selected=YES;
    _registBtn.userInteractionEnabled=YES;
    for (UITextField * tf in _tfs) {
        if ([tf isKindOfClass:[UITextField class]]&&tf!=textField) {
            if ([tf.text isEqualToString:@""]) {
                _registBtn.selected=NO;
                _registBtn.userInteractionEnabled=NO;
            }
        }
    }
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
        _registBtn.selected=NO;
        _registBtn.userInteractionEnabled=NO;
    }

    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -- scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self dismissKey];
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
