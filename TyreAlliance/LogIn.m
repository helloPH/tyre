//
//  LogIn.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "LogIn.h"
#import "MerchantEnter.h"
#import "FindPassWord.h"
#import "BeComeMerchant.h"
#import "IQKeyboardManager.h"
#import "XGPush.h"

@interface LogIn ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)Block block;
@property (nonatomic,strong)NSArray * tfs;

@property (nonatomic,strong)UIButton * loginBtn;

@property (nonatomic,strong)UITextField * tfTel;
@property (nonatomic,strong)UITextField * tfPwd;
@end

@implementation LogIn
-(id)initWithLogin:(Block)blocks{

    self = [super init];
    if (self) {
        _block = blocks;
        
        
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"登录";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:popBtn];
    
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
    _scrollView.delegate=self;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];
    [_scrollView addGestureRecognizer:tap];
    
    
    
    [self.view addSubview:_scrollView];
    
    UIImageView * headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vwidth/2)];
    [_scrollView addSubview:headImg];
    headImg.image=[UIImage imageNamed:@"loginBg"];
    
    
    NSArray * titles=@[@{@"img":@"phone_tel",@"title":@"请输入手机号码"},@{@"img":@"mima_ma",@"title":@"请输入登录密码"}];
    CGFloat setY=0;
    NSMutableArray * tfms=[NSMutableArray array];
    [tfms removeAllObjects];
    for (int i = 0; i < titles.count; i ++) {
        
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, headImg.bottom+10*self.scale+i *40*self.scale, Vwidth, 40*self.scale)];
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
            [_tfTel limitText:@11];
            _tfTel.keyboardType=UIKeyboardTypePhonePad;
//            [tf limitText:@11];
        }else{
         
            _tfPwd=tf;
            [_tfPwd limitText:@12];
            _tfPwd.secureTextEntry=YES;
            _tfPwd.keyboardType=UIKeyboardTypeAlphabet;
        }
        [tfms addObject:tf];
    }
    _tfs=[NSArray arrayWithArray:tfms];
    
    _loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    [_scrollView addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius=4;
    _loginBtn.layer.masksToBounds=YES;
    _loginBtn.titleLabel.font=BigFont(self.scale);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateSelected];
    [_loginBtn setBackgroundImage:[UIImage ImageForColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.userInteractionEnabled=NO;
    _loginBtn.tag=100;
    
    
    UIButton * askFor=[[UIButton alloc]initWithFrame:CGRectMake(_loginBtn.left, _loginBtn.bottom+10*self.scale, 80*self.scale, 20*self.scale)];
    [_scrollView addSubview:askFor];
    askFor.titleLabel.font=DefaultFont(self.scale);
    [askFor setTitleColor:grayTextColor forState:UIControlStateNormal];
    [askFor setTitle:@"商家入驻" forState:UIControlStateNormal];
    [askFor sizeToFit];
    [askFor addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    askFor.tag=101;
    
    UIButton * forget=[[UIButton alloc]initWithFrame:askFor.frame];
    [_scrollView addSubview:forget];
    forget.titleLabel.font=DefaultFont(self.scale);
    [forget setTitleColor:grayTextColor forState:UIControlStateNormal];
    [forget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forget sizeToFit];
    forget.right=_loginBtn.right;
    [forget addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    forget.tag=102;
    
    
    _scrollView.contentSize=CGSizeMake(Vwidth, forget.bottom);
}
-(void)btnEvent:(UIButton *)sender{
    
    switch (sender.tag) {
        case 100:{//登录
            for (UITextField * tf in _tfs) {
                if ([tf isKindOfClass:[UITextField class]]) {
                    if (tf.tag==100) {//用户名或手机号
                        if ( ![tf.text isValidateMobile]) {
                            [self ShowAlertWithMessage:@"请输入正确的手机号"];
                            return ;
                        }
                    }else{//登录密码
                        if (![tf.text isValidatePassword]) {
                            [self ShowAlertWithMessage:@"请输入正确的密码格式"];
                            return ;
                        }
                    }
                }
            }
            

            
            
            NSString* telValue=[_tfTel.text Des_EncryptForKey:DesKey Iv:DesValue];
            NSString* pwdValue=[_tfPwd.text Des_EncryptForKey:DesKey Iv:DesValue];
            NSString* typeValue=[@"1" Des_EncryptForKey:DesKey Iv:DesValue];

            
            
            NSDictionary * dic=@{@"tel":telValue,
                                 @"pwd":pwdValue,
                                 @"type":typeValue};
            
            [self startAnimating:nil];
            [AnalyzeObject loginWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
                    NSDictionary * dic=(NSDictionary *)model;
                    NSString * states=dic[@"states"];
                    NSInteger statesI=states.integerValue;
                    
                    
                    
                    
                    [[Stockpile sharedStockpile] setID:[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]]];
                    
          
                    switch (statesI) {
                        case 0:{//刚注册 未申请
                            BeComeMerchant * become=[BeComeMerchant new];
                            [self.navigationController pushViewController:become animated:YES];
                            [self showPromptInWindowWithString:@"您还不是商家,请申请!"];
                            
                        }
                            break;
                        case 1:{//已申请 审核中
                            [self ShowAlertWithMessage:@"正在审核!"];
                        }
                            break;
                        case 2:{//审核通过
                            //                            [self startAnimating:nil];
                            //                            [(AppDelegate*)([UIApplication sharedApplication].delegate) switchRootController];
                            
                            [[Stockpile sharedStockpile]setAccount:_tfTel.text];
                            [[Stockpile sharedStockpile]setPassword:_tfPwd.text];
                        
                            
                            
                            printf("%s",[[Stockpile sharedStockpile].ID UTF8String]);
                            
                            [XGPush setAccount:[NSString stringWithFormat:@"TZM_%@",[Stockpile sharedStockpile].ID]];
                            [self.appdelegate zhuce];
                            
                            
                            if (_block) {
                                _block(YES);
                            }
                            
                            //                            NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
                            
                            //                            [AnalyzeObject getPerInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                            //                                [self stopAnimating];
                            //                                if (ret) {
                            ////                                    NSDictionary * dic=(NSDictionary*)model;
                            //
                            ////                                    [[Stockpile sharedStockpile]setName:[NSString stringWithFormat:@"%@",   dic[@"u_name"]]];
                            ////                                    [[Stockpile sharedStockpile]setTel:[NSString stringWithFormat:@"%@",   dic[@"u_tel"]]];
                            ////                                    [[Stockpile sharedStockpile]setNickName:[NSString stringWithFormat:@"%@",dic[@"Buss_name"]]];
                            ////                                    [[Stockpile sharedStockpile]setLogo:[NSString stringWithFormat:@"%@",dic[@"u_logo"]]];
                            //
                            //
                            //                                }else{
                            ////                                    self ShowAlertWithMessage:@"获取用户"
                            ////                                    [self showPromptBoxWithSting:@"获取用户资料失败!"];
                            //                                }
                            //
                            //                            }];
                            
                        }
                            break;
                        case 3:{//申请被拒绝
                            
                            NSDictionary * dic=(NSDictionary*)model;
                            
                            [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",   dic[@"uid"]]];
                            [[Stockpile sharedStockpile]setName:[NSString stringWithFormat:@"%@",   dic[@"uname"]]];
                            [[Stockpile sharedStockpile]setLogo:[NSString stringWithFormat:@"%@",dic[@"ulogo"]]];
                            
                            
                            BeComeMerchant * become=[BeComeMerchant new];
                            become.isRefuse=YES;
                            become.reson=[dic objectForKey:@"reson"];
                            [self.navigationController pushViewController:become animated:YES];
                            
                        }
                            break;
                        default:
                            break;
                    }
                    
                    if ([msg isEqualToString:@"未申请商家"]) {
                        
                        
                    }
                    

                    
                }else{
                    [self showPromptBoxWithSting:msg];
                }
//                //跳过网络
//                if (_block) {
//                    _block(YES);
//                }

            }];
    
            
        }
            break;
        case 101:{//申请入驻
            MerchantEnter * enter=[MerchantEnter new];
            [self.navigationController pushViewController:enter animated:YES];
            
            
        }
            break;
        case 102:{//忘记密码
            FindPassWord * find=[FindPassWord new];
            [self.navigationController pushViewController:find animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark -- textField  delegate 
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    // 判断  提交按钮是否可用
    _loginBtn.selected=YES;
    _loginBtn.userInteractionEnabled=YES;
    for (UITextField * tf in _tfs) {
        if ([tf isKindOfClass:[UITextField class]]&&tf!=textField) {
            if ([tf.text isEqualToString:@""]) {
                _loginBtn.selected=NO;
                _loginBtn.userInteractionEnabled=NO;
            }
        }
    }
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
        _loginBtn.selected=NO;
        _loginBtn.userInteractionEnabled=NO;
    }
    
    

//    if (textField.tag==100) {
//        return [newString isValidateNum]||[newString isEmptyString];
//    }
  
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

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
