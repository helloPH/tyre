//
//  WithDraw.m
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "WithDraw.h"
#import "WithDrawRecord.h"


@interface WithDraw ()<UITextFieldDelegate>

@property (nonatomic,strong)NSArray * tfs;
@property (nonatomic,strong)UIButton * commitBtn;
@property (nonatomic,strong)UITextField * tfJin;
@property (nonatomic,strong)UITextField * tfYan;
@end

@implementation WithDraw

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    // Do any additional setup after loading the view.
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
-(void)newView{
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
            field.keyboardType=UIKeyboardTypeNumberPad;
        }
        if (i == 1) {
            _tfYan=field;
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
       
        }
        setY=cellView.bottom;
    }
    _tfs=[NSArray arrayWithArray:tfms];
    
    _commitBtn=[[UIButton alloc]initWithFrame:CGRectMake(15*self.scale, setY+20*self.scale, Vwidth-30*self.scale, 35*self.scale)];
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
-(void)yanBtn:(UIButton *)sender{
    
}
-(void)commitBtn:(UIButton *)sender{
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
    [AnalyzeObject getCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        if ([ret isEqualToString:@"1"]) {
            NSString * num=[NSString stringWithFormat:@"%@",[model valueForKey:@"bank_num"]];
            NSString * per=[NSString stringWithFormat:@"%@",[model valueForKey:@"bank_person"]];
            
          NSDictionary *  dic=@{@"uid":[Stockpile sharedStockpile].ID,
                                @"many":_tfJin.text,
                                @"num":num,
                                @"person":per
                                
                  };
            [AnalyzeObject WithDrawWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                if ([ret isEqualToString:@"1"]) {
                    
                }else{
                    
                }
                [self showPromptBoxWithSting:msg];
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
