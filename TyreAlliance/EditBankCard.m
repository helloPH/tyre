//
//  EditBankCard.m
//  TyreAlliance
//
//  Created by wdx on 16/9/27.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EditBankCard.h"
#import "IQKeyboardManager.h"

@interface EditBankCard ()<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSMutableArray * bankList;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)NSMutableDictionary * dataDic;


@property (nonatomic,strong)UIControl * pickControl;
@property (nonatomic,strong)UIPickerView * pickView;

@property (nonatomic,strong)UITextField * tfName;
@property (nonatomic,strong)UITextField * tfCardNum;
@property (nonatomic,strong)UILabel * labelBank;
@property (nonatomic,strong)UITextField * tfBankName;

@end

@implementation EditBankCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self initData];
    [self newNavi];
//    [self newView];
    [self reshData];
    
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"绑定银行卡";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    _bankList=[NSMutableArray array];
    _selectedIndex=1;
    _dataDic = [NSMutableDictionary dictionary];
    
}
-(void)reshData{
    [self startAnimating:nil];
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
    [AnalyzeObject getCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            if (_dataDic) {
                [_dataDic removeAllObjects];
            }
            [_dataDic addEntriesFromDictionary:model];
           
//            _isHave=YES;
        }else{
            //            if ([msg isEqualToString:@"没有绑定银行卡"]) {
            
            //            }
//            _isHave=NO;
        }
        [self newView];
    }];
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
    
    if (_isHave) {
            self.TitleLabel.text=@"添加银行卡";
    }else{
            self.TitleLabel.text=@"添加银行卡";
    }
    NSArray * titles=@[@{@"title":@"姓名:",@"place":@"请输入您的姓名"},
                       @{@"title":@"卡号:",@"place":@"请输入您的银行卡号"},
                       @{@"title":@"所属银行",@"place":@""},
                       @{@"title":@"开户行:",@"place":@"请输入您的开户行地址"}];
    
    if (_isHave) {
        
        titles=@[@{@"title":@"姓名:",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"bank_person"]?_dataDic[@"bank_person"]:@""]},
                 @{@"title":@"卡号:",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"bank_num"]?_dataDic[@"bank_num"]:@""]},
                 @{@"title":@"所属银行",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"bank_name"]?_dataDic[@"bank_name"]:@""]},
                 @{@"title":@"开户行:",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"bank_zhi_name"]?_dataDic[@"bank_zhi_name"]:@""]}];
    }
    
    CGFloat setY=0;
    for ( int i = 0; i < titles.count; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale+i *40*self.scale, Vwidth, 40*self.scale)];
        [self.view addSubview:cellView];
        
        cellView.titleLabel.text=[titles[i] valueForKey:@"title"];
        [cellView.titleLabel sizeToFit];
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(cellView.titleLabel.right+10*self.scale, 0, 200*self.scale, cellView.titleLabel.height)];
        
        tf.centerY=cellView.titleLabel.centerY;
        tf.textColor=blackTextColor;
        tf.font=DefaultFont(self.scale);
        
        if (_isHave) {
            tf.text=[titles[i] valueForKey:@"place"];
        }else{
          tf.placeholder=[titles[i] valueForKey:@"place"];  
        }
        
        
        if (i != 2) {
            [cellView addSubview:tf];
        }
        switch (i) {
            case 0:
            {
                _tfName=tf;
                [_tfName limitText:@10];
            }
                break;
            case 1:
            {
                _tfCardNum=tf;
                [_tfCardNum limitText:@19];
                _tfCardNum.keyboardType=UIKeyboardTypeNumberPad;
            }
                break;
            case 2:
            {
                [cellView.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
                cellView.btn.tag=100;
                [cellView ShowRight:YES];
                tf.userInteractionEnabled=NO;
                
                UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20*self.scale)];
                label.right=cellView.RightImg.left-10*self.scale;
                label.centerY=cellView.titleLabel.centerY;
                label.font=DefaultFont(self.scale);
                label.textColor=blackTextColor;
                label.textAlignment=NSTextAlignmentRight;
                [cellView addSubview:label];
                if (_isHave) {
                    label.text=[titles[i] valueForKey:@"place"];
                }
                _labelBank=label;
                
                
                
            }
                break;
            case 3:
            {
                _tfBankName=tf;
            }
                break;
            default:
                break;
        }
        setY=cellView.bottom;
        
        
    }
    
    
    UIButton * submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+30*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    submitBtn.tag=1000;
    submitBtn.layer.cornerRadius=5;
    submitBtn.layer.masksToBounds=YES;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}

-(void)newPickControll{
    _pickControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vheight)];
    _pickControl.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    [self.view addSubview:_pickControl];
    [_pickControl addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _pickControl.hidden=NO;
    _pickControl.alpha=1;
    [_pickView selectRow:_selectedIndex inComponent:0 animated:YES];
    
    UIView * pickBG=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 150*self.scale)];
    pickBG.backgroundColor=[UIColor whiteColor];
    [_pickControl addSubview:pickBG];
    pickBG.bottom=_pickControl.height;
    
    NSArray * titles=@[@"取消",@"确定"];
    for (int i = 0; i < titles.count; i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 40*self.scale, 20*self.scale)];
        btn.tag=100+i;
        btn.titleLabel.font=DefaultFont(self.scale);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:lightOrangeColor forState:UIControlStateNormal];
        [pickBG addSubview:btn];
        [btn addTarget:self action:@selector(submitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        if (i==1) {
            btn.right=Vwidth-10*self.scale;
        }
    }
    
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40*self.scale, Vwidth, pickBG.height-40*self.scale)];
    _pickView.delegate=self;
    _pickView.dataSource=self;
    [pickBG addSubview:_pickView];
}

-(void)controlBtn:(UIButton*)sender{
    [self dismissKey];
    
    if (!_pickControl) {
        [self startAnimating:nil];
        NSDictionary * dic;
        [AnalyzeObject getBankListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                if (_bankList) {
                    [_bankList removeAllObjects];
                }
                [_bankList addObjectsFromArray:model];
                [self newPickControll];
            }else{
                [self showPromptBoxWithSting:@"获取银行列表失败"];
            }
            
        }];
        
        
        
        return;
    }
    if (_pickControl.hidden) {
        [_pickView selectRow:_selectedIndex inComponent:0 animated:YES];
        _pickControl.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            _pickControl.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            _pickControl.alpha=0;
        } completion:^(BOOL finished) {
            _pickControl.hidden=YES;
        }];
    }
    
    
}
-(void)submitOrCancel:(UIButton *)sender{
    [self controlBtn:nil];
    if (sender.tag==101) {
        _labelBank.text=[NSString stringWithFormat:@"%@",[_bankList[_selectedIndex] valueForKey:@"Bank_name"]];
        
    }
}
-(void)btnEvent:(UIButton *)sender{
    if (sender.tag!=1000) {//选择所属银行
        [self controlBtn:nil];
    }else{//添加银行卡
        if ([_tfName.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入姓名"];
            return;
        }
        if ([_tfCardNum.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入卡号"];
            return;
        }
        if (![_tfCardNum.text isValidateBank]) {
            [self showPromptBoxWithSting:@"请输入正确的银行卡"];
            return;
        }
        if ([_labelBank.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请选择银行"];
            return;
        }
        if ([_tfBankName.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入开户行地址"];
            return;
        }
        
        
        if (_isHave) {
            if ([[NSString stringWithFormat:@"%@",_dataDic[@"bank_person"]] isEqualToString:_tfName.text]
                &&[[NSString stringWithFormat:@"%@",_dataDic[@"bank_num"]]isEqualToString:_tfCardNum.text]
                &&[[NSString stringWithFormat:@"%@",_dataDic[@"bank_name"]]isEqualToString:_labelBank.text]
                &&[[NSString stringWithFormat:@"%@",_dataDic[@"bank_zhi_name"]]isEqualToString:_tfBankName.text])
                {
                    [self ShowAlertWithMessage:@"你还未修改任何内容!"];
                    return;
                    
                }
        }
        
        
        
        [self startAnimating:nil];
        
        NSString * idValue=[_cId Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * perValue=[_tfName.text Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * numValue=[_tfCardNum.text Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * bankValue=[_labelBank.text Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * kaiValue=[_tfBankName.text Des_EncryptForKey:DesKey Iv:DesValue];
        
        
        
        if (_isHave) {
            NSDictionary * dic=@{@"id":[NSString stringWithFormat:@"%@",idValue],
                                 @"person":[NSString stringWithFormat:@"%@",perValue],
                                 @"num":[NSString stringWithFormat:@"%@",numValue],
                                 @"bank":[NSString stringWithFormat:@"%@",bankValue],
                                 @"KaiHuHang":[NSString stringWithFormat:@"%@",kaiValue]};
            [AnalyzeObject updateCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
                    [self PopVC:nil];
                    if (_block) {
                        _block(YES);
                    }
                }else{
                    
                    
                }
                [self showPromptInWindowWithString:msg];
            }];
        }else{
            idValue=[[Stockpile sharedStockpile].ID Des_EncryptForKey:DesKey Iv:DesValue];
            
            NSDictionary * dic=@{@"uid":[NSString stringWithFormat:@"%@",idValue],
                                 @"person":[NSString stringWithFormat:@"%@",perValue],
                                 @"num":[NSString stringWithFormat:@"%@",numValue],
                                 @"bank":[NSString stringWithFormat:@"%@",bankValue],
                                 @"KaiHuHang":[NSString stringWithFormat:@"%@",kaiValue]};
            [AnalyzeObject  addCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
                    [self PopVC:nil];
                    if (_block) {
                        _block(YES);
                    }
                    
                }else{
                    
                    
                }
                [self showPromptBoxWithSting:msg];
            }];
            
            
        }
        
        

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark  -- pick delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  _bankList.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@",[_bankList[row]valueForKey:@"Bank_name"]];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedIndex=row;
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
