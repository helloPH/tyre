//
//  WithDraw.m
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "WithDraw.h"
#import "WithDrawRecord.h"
#import "IQKeyboardManager.h"

@interface WithDraw ()<UITextFieldDelegate>

@property (nonatomic,strong)NSArray * tfs;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger  time;


@property (nonatomic,strong)UIButton * commitBtn;
@property (nonatomic,strong)UIButton * verBtn;

@property (nonatomic,strong)UITextField * tfJin;
@property (nonatomic,strong)UITextField * tfYan;

@property (nonatomic,strong)NSString * textYan;

@property (nonatomic,assign)CGFloat minQuota;
@property (nonatomic,assign)CGFloat maxQuota;

@property (nonatomic,strong)UILabel * labelTip;
@end

@implementation WithDraw

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
    _textYan=@"";
    _minQuota=0;
    _maxQuota=_stringJin.floatValue;
}
-(void)newNavi{
    
    self.TitleLabel.text=@"提现";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    popBtn.tag=100;
    
    UIButton * recordBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*self.scale, 20*self.scale)];
     recordBtn.hidden=YES;
    [recordBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    recordBtn.titleLabel.font=DefaultFont(self.scale);
    recordBtn.tintColor=blackTextColor;
    [recordBtn sizeToFit];
    recordBtn.centerY=popBtn.centerY;
    recordBtn.right=Vwidth-10*self.scale;
    [recordBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:recordBtn];
    recordBtn.tag=101;
 
    
}
-(void)PopVC:(UIButton *)sender{
    if (sender.tag==100) {
    [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController pushViewController:[WithDrawRecord new] animated:YES];
    }

}
-(void)dismissKey{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
}
-(void)reshData{
    NSDictionary * dic=@{};
    
    [self startAnimating:nil];
    [AnalyzeObject getSetWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            _minQuota=[[NSString stringWithFormat:@"%@",model[@"Set_Low_mony"]] isEmptyString]?0:[NSString stringWithFormat:@"%@",model[@"Set_Low_mony"]].floatValue;
            _maxQuota=[[NSString stringWithFormat:@"%@",model[@"Set_high_mony"]] isEmptyString]?_stringJin.floatValue:[NSString stringWithFormat:@"%@",model[@"Set_high_mony"]].floatValue;
        }else{
            
        }
        [self reshView];
        [self showPromptBoxWithSting:msg];
    }];
    
}
-(void)reshView{
    NSMutableAttributedString * mString1=[[NSMutableAttributedString alloc]initWithString:@"温馨提示：\n\n    1.您在此平台上最低提现金额为"];
    
    NSMutableAttributedString * mString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.f",_minQuota]];
    [mString2 addAttribute:NSForegroundColorAttributeName value:darkOrangeColor range:NSMakeRange(0, mString2.length)];
    

    NSMutableAttributedString * mString3=[[NSMutableAttributedString alloc]initWithString:@"\n\n    2.当提现金额超过"];
    
    
    NSMutableAttributedString * mString4=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.f",_maxQuota]];
    [mString4 addAttribute:NSForegroundColorAttributeName value:darkOrangeColor range:NSMakeRange(0, mString4.length)];
    
    
    
    NSMutableAttributedString * mString5=[[NSMutableAttributedString alloc]initWithString:@"时，只转银行卡账号\n\n    3.如您有任何疑问，请联系平台客服咨询！"];
   
    
    [mString1 appendAttributedString:mString2];
    [mString1 appendAttributedString:mString3];
    [mString1 appendAttributedString:mString4];
    [mString1 appendAttributedString:mString5];
    
    _labelTip.attributedText=mString1;
    [_labelTip sizeToFit];
    
    _commitBtn.top=_labelTip.bottom+10*self.scale;
    
    
    
    
    
}
-(void)newView{
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];
    [self.view addGestureRecognizer:tap];
    
    
    NSArray * titles=@[@{@"title":@"金额",@"place":@"请输入你要提现的金额"},@{@"title":@"验证码",@"place":@"请输入验证码"}];
    
         float setY=0;
    NSMutableArray * tfms=[NSMutableArray array];
    [tfms removeAllObjects];
    for (int i = 0; i < 2; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale+i * 35*self.scale, Vwidth, 35*self.scale)];
        cellView.titleLabel.text=[titles[i] valueForKey:@"title"];
        [self.view addSubview:cellView];
        
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(cellView.titleLabel.right, cellView.titleLabel.top, 130*self.scale, cellView.titleLabel.height)];
        [tfms addObject:field];
        field.delegate=self;
        field.font=SmallFont(self.scale);
        [cellView addSubview:field];
        field.placeholder=[titles[i] valueForKey:@"place"];
        field.tag=100+i;
        if (i == 0) {
            _tfJin=field;
            field.keyboardType=UIKeyboardTypeDecimalPad;
        }
        if (i == 1) {
            field.keyboardType=UIKeyboardTypeNumberPad;
            
            _tfYan=field;
            [_tfYan limitText:@4];
            UIButton * getBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*self.scale, 25*self.scale)];
            [cellView addSubview:getBtn];
            getBtn.centerY=cellView.height/2;
            getBtn.right=cellView.width-10*self.scale;
            getBtn.titleLabel.font=Small10Font(self.scale);
            getBtn.layer.cornerRadius=3;
            getBtn.layer.masksToBounds=YES;
            getBtn.layer.borderColor=lightOrangeColor.CGColor;
            getBtn.layer.borderWidth=0.5;
            [getBtn addTarget:self action:@selector(yanBtn:) forControlEvents:UIControlEventTouchUpInside];
            [getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [getBtn setTitleColor:lightOrangeColor forState:UIControlStateNormal];
            _verBtn=getBtn;
        }
        setY=cellView.bottom;
    }
    _tfs=[NSArray arrayWithArray:tfms];
    
    
    
    UILabel * labelTip=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, setY+10*self.scale, Vwidth-20*self.scale, 0)];
    labelTip.textColor=grayTextColor;
    labelTip.font=DefaultFont(self.scale);
    labelTip.numberOfLines=0;
    labelTip.width=Vwidth-20*self.scale;
//    labelTip.text=[NSString stringWithFormat:@"温馨提示：/n1.您在此平台上最低提现金额为%@/n2.当提现金额超过%@时，只转银行卡账号/n3.如您有任何疑问，请联系平台客服咨询！"];
    
    [self.view addSubview:labelTip];
    _labelTip=labelTip;
    
    
    
    _commitBtn=[[UIButton alloc]initWithFrame:CGRectMake(15*self.scale, setY+20*self.scale, Vwidth-30*self.scale, 35*self.scale)];
    _commitBtn.tag=100;
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateSelected];
    [_commitBtn setBackgroundImage:[UIImage ImageForColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font=BigFont(self.scale);
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBtn.layer.cornerRadius=2;
    _commitBtn.layer.masksToBounds=YES;
    [_commitBtn addTarget:self action:@selector(commitBtn:) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.userInteractionEnabled=NO;
    [self.view addSubview:_commitBtn];

    
    
    
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

-(void)yanBtn:(UIButton *)sender{
    
    
    float jinE=[NSString stringWithFormat:@"%@",_tfJin.text].floatValue;
    if (jinE < _minQuota) {
        [self showPromptBoxWithSting:[NSString stringWithFormat:@"提现金额不能小于%.1f元",_minQuota]];
        return;
    }
    if (jinE > _maxQuota) {
        [self showPromptBoxWithSting:[NSString stringWithFormat:@"提现金额不能大于%.1f元",_maxQuota]];
        return;
    }
    
    
    if (![_tfJin.text isValidateMoneyed]||[_tfJin.text isEmptyString]||jinE==0) {
        [self ShowAlertWithMessage:@"请输入正确的金额\n且不能为0"];
        return;
    }
    
    
    
    NSString * tel=[Stockpile sharedStockpile].Account;

    NSDictionary * dic=@{@"tel":tel,
                         @"type":@"1"};
    [self startAnimating:nil];

    
    [AnalyzeObject getVerifyCodeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        
        
        if ([ret isEqualToString:@"1"]) {
            _textYan=[(NSDictionary *)model valueForKey:@"code"];
                [self timeStart];
//            _tfYan.text=[(NSDictionary *)model valueForKey:@"code"];
            if (![_tfJin.text isEqualToString:@""] && ![_tfYan.text isEqualToString:@""]) {
                _commitBtn.userInteractionEnabled=YES;
                _commitBtn.selected=YES;
            }
            
//            [self showPromptBoxWithSting:@"获取成功!"];
        }else{
            [self showPromptBoxWithSting:msg];
//            if (_timer) {
//                [_timer invalidate];
//                _timer = nil;
//                _verBtn.enabled=YES;
//                [_verBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
//            }
        }
        
    }];
}





-(void)commitBtn:(UIButton *)sender{

    float jinE=[NSString stringWithFormat:@"%@",_tfJin.text].floatValue;
    if (jinE < _minQuota) {
        [self showPromptBoxWithSting:[NSString stringWithFormat:@"提现金额不能小于%.1f元",_minQuota]];
        return;
    }
    if (jinE > _maxQuota) {
        [self showPromptBoxWithSting:[NSString stringWithFormat:@"提现金额不能大于%.1f元",_maxQuota]];
        return;
    }
    
    
    if (![_tfJin.text isValidateMoneyed]||[_tfJin.text isEmptyString]||jinE==0) {
        [self ShowAlertWithMessage:@"请输入正确的金额\n且不能为0"];
        return;
    }
    
    if (![_tfYan.text isEqualToString:_textYan]) {
        [self ShowAlertWithMessage:@"验证码错误!"];
        return;
    }
    
    
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};

 
    
    [self startAnimating:nil];
    [AnalyzeObject getCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        
        if ([ret isEqualToString:@"1"]) {
            NSString * num=[NSString stringWithFormat:@"%@",[model valueForKey:@"bank_num"]];
            NSString * per=[NSString stringWithFormat:@"%@",[model valueForKey:@"bank_person"]];
            
            NSString * uidValue=[[Stockpile sharedStockpile].ID Des_EncryptForKey:DesKey Iv:DesValue];
            NSString * jinValue=[_tfJin.text Des_EncryptForKey:DesKey Iv:DesValue];
            NSString * numValue=[num Des_EncryptForKey:DesKey Iv:DesValue];
            NSString * perValue=[per Des_EncryptForKey:DesKey Iv:DesValue];
            
            
            
            
          NSDictionary *  dic=@{@"uid":uidValue,
                                @"many":jinValue,
                                @"num":numValue,
                                @"person":perValue
                  };
            [AnalyzeObject WithDrawWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                if ([ret isEqualToString:@"1"]) {
                    _tfJin.text=@"";
                    _tfYan.text=@"";
                    _commitBtn.selected=NO;
                    _commitBtn.userInteractionEnabled=NO;
                    [_timer invalidate];
                    _timer = nil;
                    _verBtn.enabled=YES;
                    [_verBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];

                    [self PopVC:sender];
                    if (_block) {
                        _block(YES);
                    }
                 
                }else{
                    
                }
                
                 
                [self ShowAlertWithMessage:msg];
                
            }];
        }else{
            [self showPromptBoxWithSting:msg];
            
        }
    }];
    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 判断  提交按钮是否可用
    _commitBtn.selected=YES;
    _commitBtn.userInteractionEnabled=YES;
    for (UITextField * tf in _tfs) {
        if ([tf isKindOfClass:[UITextField class]]&&tf!=textField) {
            if ([tf.text isEqualToString:@""]) {
                _commitBtn.selected=NO;
                _commitBtn.userInteractionEnabled=NO;
            }
        }
    }
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
        _commitBtn.selected=NO;
        _commitBtn.userInteractionEnabled=NO;
    }
    
    if (textField.tag==100) {
        if (![[textField.text stringByReplacingCharactersInRange:range withString:string] isValidateMoneying]) {
            [self ShowAlertWithMessage:@"请输入正确的金额，且小数点后最多有两位"];
            return NO;
        }
    }
    
    
    return YES;
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
