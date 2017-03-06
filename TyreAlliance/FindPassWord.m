//
//  FindPassWord.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "FindPassWord.h"
#import "IQKeyboardManager.h"

@interface FindPassWord ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIButton * registBtn;

@property (nonatomic,assign)NSInteger time;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)UIButton * verBtn;

@property (nonatomic,strong)UITextField * tfTel;
@property (nonatomic,strong)UITextField * tfPwd;
@property (nonatomic,strong)NSArray * tfs;
@property (nonatomic,strong)NSString * textYan;
@property (nonatomic,strong)NSString * temTel;
@end

@implementation FindPassWord

- (void)viewDidLoad {
    [super viewDidLoad];
    _temTel=@"";
    [self newNavi];
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"找回密码";
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
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    _scrollView.delegate=self;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];
    [_scrollView addGestureRecognizer:tap];
    
    NSArray * titles1=@[@{@"title":@"手机号",@"place":@"请输入您注册时使用的手机号"},
                        @{@"title":@"新密码",@"place":@"设置6-12位字母、数字或符号组合"},
                        @{@"title":@"确认密码",@"place":@"请重复输入密码"},
                        @{@"title":@"验证码",@"place":@"请输入验证码"}];
    CGFloat setY=0;
    NSMutableArray * tfms=[NSMutableArray array];
    for (int i =0 ; i < titles1.count; i ++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale+i * 40*self.scale, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cellView];
        
        UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 50*self.scale, 20*self.scale)];
        labelTitle.font=DefaultFont(self.scale);
        labelTitle.textColor=blackTextColor;
        [cellView addSubview:labelTitle];
        labelTitle.text=[titles1[i]valueForKey:@"title"];
        [labelTitle sizeToFit];
        
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(labelTitle.right+10*self.scale, labelTitle.top, 200*self.scale, 20*self.scale)];
        [cellView addSubview:tf];
        [tfms addObject:tf];
        tf.delegate=self;
        tf.tag=100+i;
        tf.font=DefaultFont(self.scale);
        tf.textColor=blackTextColor;
        tf.placeholder=[titles1[i]valueForKey:@"place"];
        setY=cellView.bottom;
        tf.keyboardType=UIKeyboardTypeAlphabet;
        if (i==0) {
            _tfTel=tf;
            [tf limitText:@11];
            tf.keyboardType=UIKeyboardTypePhonePad;
        }
        if (i==1) {
            _tfPwd=tf;
            _tfPwd.secureTextEntry=YES;
            [_tfPwd limitText:@12];
        }
        if (i==2) {
            tf.secureTextEntry=YES;
            [tf limitText:@12];
        }
        if (i==3) {
            [tf limitText:@4];
        }
        
        
        if (i==titles1.count-1) {
            
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
            btn.tag=1011;
            [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
            _verBtn=btn;
            
        }
    }
    _tfs=[NSArray arrayWithArray:tfms];
    _registBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    [_scrollView addSubview:_registBtn];
    _registBtn.tag=101;
    _registBtn.layer.cornerRadius=4;
    _registBtn.layer.masksToBounds=YES;
    _registBtn.titleLabel.font=BigFont(self.scale);
    [_registBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn setBackgroundImage:[UIImage ImageForColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_registBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
    _registBtn.selected=NO;
    _registBtn.userInteractionEnabled=NO;
    [_registBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    setY=_registBtn.bottom;
    
    
    _scrollView.contentSize=CGSizeMake(Vwidth, setY);
    
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
-(void)btnEvent:(UIButton *)sender{
    UITextField * tfTel;
    
    for (UITextField * tf in _tfs) {
        if ([tf isKindOfClass:[UITextField class]]) {
            if (tf.tag==100) {//用户名或手机号
                tfTel=tf;
            }
        }
    
    }
    if (![tfTel.text isValidateMobileAndTel]) {
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        return ;
    }
    
    NSString * tempPassWord;
      UITextField * tfVer=((UITextField *)_tfs[3]);
    if(sender.tag==1011){
        UITextField * tfTel=((UITextField *)_tfs[0]);
        _temTel=tfTel.text;
        if ([tfTel.text isValidateMobile]) {
            NSDictionary * dic=@{@"tel":tfTel.text,
                                 @"type":@"1"};
            [self startAnimating:nil];
            [AnalyzeObject getVerifyCodeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                
                if ([ret isEqualToString:@"1"]) {
                    _textYan=[(NSDictionary *)model valueForKey:@"code"];
                    [self timeStart];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
            }];
        }else{
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        }
        
        return;
    }
    if (![_temTel isEqualToString:_tfTel.text]) {
        [self ShowAlertWithMessage:@"请确保输入的手机号与获取验证码的手机号一致"];
        return ;
    }
    
    for (UITextField * tf in _tfs) {
        if ([tf isKindOfClass:[UITextField class]]) {
            if (tf.tag==101) {//登录密码
                if (![tf.text isValidatePassword]){
                    [self ShowAlertWithMessage:@"请输入正确的密码格式"];
                    return ;
                }
                tempPassWord=tf.text;
            }
            if (tf.tag==102) {//登录密码
                if (![tf.text isValidatePassword]){
                    [self ShowAlertWithMessage:@"请输入正确的密码格式"];
                    return ;
                }
                if (![tf.text isEqualToString:tempPassWord]) {
                    [self ShowAlertWithMessage:@"请确保两次输入密码一致"];
                    return;
                }
            }
            
            if (tf.tag==103) {
                if (![tf.text isEqualToString:_textYan]) {
                    [self ShowAlertWithMessage:@"验证码不正确！"];
                    return;
                }
            }
        }
    }
    
    
    
    NSString * telValue=[_tfTel.text Des_EncryptForKey:DesKey Iv:DesValue];
    NSString * pwdValue=[_tfTel.text Des_EncryptForKey:DesKey Iv:DesValue];
    NSString * verValue=[_tfTel.text Des_EncryptForKey:DesKey Iv:DesValue];
    
    
    NSDictionary * dic=@{@"tel":[NSString stringWithFormat:@"%@",telValue],
                         @"pwd":[NSString stringWithFormat:@"%@",pwdValue]
//                         ,@"yqm":[NSString stringWithFormat:@"%@",tfVer.text]
                         };

    [AnalyzeObject findPwdWithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"1"]) {
            [((AppDelegate *)([UIApplication sharedApplication].delegate)) switchRootController];
        }else{
          
        }
          [self ShowAlertWithMessage:msg];
    }];
    
    
    
}

#pragma mark  -- textField  delegate
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
