//
//  EditFinanceAccount.m
//  TyreAlliance
//
//  Created by wdx on 2016/12/15.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EditFinanceAccount.h"

@interface EditFinanceAccount ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)NSMutableArray * bankList;



@property (nonatomic,strong)UITextField * tfName;
@property (nonatomic,strong)UITextField * tfCardNum;
@property (nonatomic,strong)UILabel * labelBank;
@property (nonatomic,strong)UITextField * tfBankName;

@property (nonatomic,strong)CellView * selectView;
@property (nonatomic,strong)UIControl * pickControl;
@property (nonatomic,strong)UIPickerView * pickView;



@property (nonatomic,assign)NSInteger typeIndex;

@property (nonatomic,assign)NSInteger selectedIndex;

@end

@implementation EditFinanceAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    [self reshSelectView];
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"添加账号";
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
    _dataDic=[NSMutableDictionary dictionary];
    _bankList=[NSMutableArray array];
    _typeIndex=1;
    _selectedIndex=0;
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
            
            _isHave=YES;
//             [self reshView];
            
            
            NSString * typeString=[NSString stringWithFormat:@"%@",_dataDic[@"type"]];
            NSInteger typeIndex = 0;
            if ([typeString isEqualToString:@"0"]) {
                typeIndex=1;
            }
            if ([typeString isEqualToString:@"1"]) {
                typeIndex=2;
            }
            if ([typeString isEqualToString:@"2"]) {
                typeIndex=0;
            }
            
            
     
            _typeIndex=typeIndex;
            [self reshSelectView];
//
//            UIButton * temBtn=[[UIButton alloc]init];
//            temBtn.tag=100+_typeIndex;
//            [self selectBtn:temBtn];
//            NSLog(@"%ld",(long)temBtn.tag);
            
  
        }else{
            //            if ([msg isEqualToString:@"没有绑定银行卡"]) {
//            [self newView:NO];
            //            }
            _isHave=NO;
        }
        

        
       
    }];

}


-(void)reshView{
    if (_typeIndex!=0) {
        _tfCardNum.keyboardType=UIKeyboardTypeAlphabet;
        
        _labelBank.superview.hidden=YES;
        _tfBankName.superview.hidden=YES;
        
    }else{
        _tfCardNum.keyboardType=UIKeyboardTypeNumberPad;
        
        _labelBank.superview.hidden=NO;
        _tfBankName.superview.hidden=NO;
    }
    


    
    

    
    
    
    
    NSString * typeString=[NSString stringWithFormat:@"%@",_dataDic[@"type"]];
    NSInteger typeIndex = 0;
    if ([typeString isEqualToString:@"0"]) {
        typeIndex=1;
    }
    if ([typeString isEqualToString:@"1"]) {
        typeIndex=2;
    }
    if ([typeString isEqualToString:@"2"]) {
        typeIndex=0;
    }
    if (typeIndex==_typeIndex) {
        _tfName.text=[[NSString stringWithFormat:@"%@",_dataDic[@"bank_person"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"bank_person"]];
        _tfCardNum.text=[[NSString stringWithFormat:@"%@",_dataDic[@"bank_num"]]isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"bank_num"]];
        
        _labelBank.text=[[NSString stringWithFormat:@"%@",_dataDic[@"bank_name"]]isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"bank_name"]];
        _tfBankName.text=[[NSString stringWithFormat:@"%@",_dataDic[@"bank_zhi_name"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"bank_zhi_name"]];
    }else{
        _tfName.text=@"";
        _tfCardNum.text=@"";
        
        _labelBank.text=@"";
        _tfBankName.text=@"";
    }
    
    
   


    
    
    
    
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    
    
   ///  选择账号类型的  头部  选项卡
    
    
    CellView * selectView=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, Vwidth, 40*self.scale)];
    selectView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:selectView];
    _selectView=selectView;
    
    
    
    UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [selectView addSubview:labelTitle];
    labelTitle.font=DefaultFont(self.scale);
    labelTitle.textColor=blackTextColor;
    labelTitle.text=@"请选择账号类型";
    [labelTitle sizeToFit];
    labelTitle.left=10*self.scale;
    labelTitle.centerY=selectView.height/2;
    
    
    NSArray * titles=@[@"银行卡",@"支付宝",@"微信"];
    
    CGFloat iw=(selectView.width -labelTitle.width-30*self.scale)/6;
    for (int i =  0 ; i < titles.count; i ++) {
        
        
        CGFloat btnCenterX=labelTitle.width+20*self.scale + (i*2+1)*iw;
        
        UIButton * bgBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        bgBtn.tag=100+i;
        [selectView addSubview:bgBtn];
        bgBtn.center=CGPointMake(btnCenterX, selectView.height/2);
        [bgBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
//        if (_typeIndex==i) {
//            bgBtn.selected=YES;
//        }else{
//            bgBtn.selected=NO;
//        }
        
        
        
        UIButton * seBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15*self.scale, 15*self.scale)];//选择按钮
        [bgBtn addSubview:seBtn];
        seBtn.userInteractionEnabled=NO;
        seBtn.left=5*self.scale;
        seBtn.centerY=bgBtn.height/2;
        seBtn.selected=bgBtn.selected;
        [seBtn setBackgroundImage:[UIImage imageNamed:@"right_light"] forState:UIControlStateNormal];
        [seBtn setBackgroundImage:[UIImage imageNamed:@"big_right"] forState:UIControlStateSelected];
        
        
        
        
        UILabel * seTitle=[[UILabel alloc]initWithFrame:CGRectMake(seBtn.right, 0, 0, 0)];  //选择标题
        [bgBtn addSubview:seTitle];
        seTitle.font=DefaultFont(self.scale);
        seTitle.text=[NSString stringWithFormat:@"%@",titles[i]];
        [seTitle sizeToFit];
        seTitle.left=seBtn.right+5*self.scale;
        seTitle.centerY=bgBtn.height/2;
        
        
        
        bgBtn.width=seTitle.right+5*self.scale;
        bgBtn.centerX=btnCenterX;
    
    }
    
    
    
    
    ///////     账号的显示项
    
    NSArray * contentTitles=@[@{@"title":@"姓名",@"place":@"请输入您的姓名"},
                              @{@"title":@"账号",@"place":@"请输入您的账号"},
                              @{@"title":@"所属银行",@"place":@"请选择银行"},
                              @{@"title":@"开户行",@"place":@"请输入您的开户行地址"}];
    
    CGFloat setY=selectView.bottom+10*self.scale;
    for (int i = 0 ; i < contentTitles.count; i ++) {
        NSDictionary * dic=contentTitles[i];
        
        
        CellView * cell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cell];
        
        cell.titleLabel.text=[NSString stringWithFormat:@"%@",dic[@"title"]];
    
        
        
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right+10*self.scale, 0, 200*self.scale, cell.titleLabel.height)];
        [cell addSubview:tf];
        tf.placeholder=[NSString stringWithFormat:@"%@",dic[@"place"]];
        tf.centerY=cell.titleLabel.centerY;
        tf.textColor=blackTextColor;
        tf.font=DefaultFont(self.scale);
        tf.clearButtonMode=UITextFieldViewModeAlways;
        switch (i) {
            case 0:
            {
                _tfName=tf;
            }
                break;
            case 1:
            {
                _tfCardNum=tf;
            }
                break;
            case 2:
            {
                [cell.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn.tag=100;
                [cell ShowRight:YES];
                tf.hidden=YES;
                
                
                //            tf.userInteractionEnabled=NO;
                
                UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20*self.scale)];
                label.right=cell.RightImg.left-10*self.scale;
                label.centerY=cell.titleLabel.centerY;
                label.font=DefaultFont(self.scale);
                label.textColor=blackTextColor;
                label.textAlignment=NSTextAlignmentRight;
                [cell addSubview:label];
                //            if (_isHave) {
                //                label.text=[titles[i] valueForKey:@"place"];
                //            }
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
        

        
        setY=cell.bottom;
    }
    
    
    
    
    
    UIButton * submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+30*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    submitBtn.bottom=_scrollView.height-10*self.scale;
    submitBtn.tag=1000;
    submitBtn.layer.cornerRadius=5;
    submitBtn.layer.masksToBounds=YES;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    
}
-(void)reshSelectView{
    for (UIButton * bgBtn in _selectView.subviews) {
        if ([bgBtn isKindOfClass:[UIButton class]]) {
            bgBtn.selected=NO;
            if (bgBtn.tag==_typeIndex+100) {
                bgBtn.selected=YES;
            }
            for (UIButton * subBtn in bgBtn.subviews) {
                if ([subBtn isKindOfClass:[UIButton class]]) {
                    subBtn.selected=bgBtn.selected;
                }
            }
            
            
        }
    }
    [self reshView];
}
-(void)selectBtn:(UIButton *)sender{
    for (UIButton * bgBtn in sender.superview.subviews) {
        if ([bgBtn isKindOfClass:[UIButton class]]) {
            bgBtn.selected=NO;
            for (UIButton * subBtn in bgBtn.subviews) {
                if ([subBtn isKindOfClass:[UIButton class]]) {
                    subBtn.selected=bgBtn.selected;
                }
            }
        }
    }
    sender.selected=YES;
    for (UIButton * subBtn in sender.subviews) {
        if ([subBtn isKindOfClass:[UIButton class]]) {
            subBtn.selected=sender.selected;
        }
    }
    _typeIndex=sender.tag-100;
    
    
    
    //  处理   btn 事件
    
    [self reshView];

}
-(void)btnEvent:(UIButton *)sender{
    if (sender.tag==100) {///   银行列表点击事件
        [self controlBtn:nil];
        return;
    }


    if (sender.tag==1000) { ////    编辑银行卡
        
        if ([_tfName.text isEqualToString:[NSString stringWithFormat:@"%@",_dataDic[@"bank_person"]]]&&
            [_tfCardNum.text isEqualToString:[NSString stringWithFormat:@"%@",_dataDic[@"bank_num"]]]&&
            [_labelBank.text isEqualToString:[NSString stringWithFormat:@"%@",_dataDic[@"bank_name"]]]&&
            [_tfBankName.text isEqualToString:[NSString stringWithFormat:@"%@",_dataDic[@"bank_zhi_name"]]]) {
            [self showPromptBoxWithSting:@"您还未做任何修改！"];
            return;
        }
        
        
        
        if ([_tfName.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入姓名"];
            return;
        }
        if ([_tfCardNum.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入卡号"];
            return;
        }
        if (_typeIndex==0) {//银行卡
//            if (![_tfCardNum.text isValidateNum]) {
//                [self showPromptBoxWithSting:@"请输入有效的银行卡账号"];
//                return;
//            }
            
            if (![_tfCardNum.text isValidateBank]) {
                [self showPromptBoxWithSting:@"请输入有效的银行卡账号"];
                return;
            }
            
            
            if ([_labelBank.text isEmptyString]) {
                [self showPromptBoxWithSting:@"请选择银行"];
                return;
            }
            if ([_tfBankName.text isEmptyString]) {
                [self showPromptBoxWithSting:@"请输入支行名称"];
                return;
            }
          
            
        }else{//支付宝   和  微信
            
            
            
            
        }
        
        
        NSString * idValue=[_cId Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * perValue=[_tfName.text Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * numValue=[_tfCardNum.text Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * bankValue=[_labelBank.text Des_EncryptForKey:DesKey Iv:DesValue];
        NSString * kaiValue=[_tfBankName.text Des_EncryptForKey:DesKey Iv:DesValue];
        
        
        
        

        if (_isHave) {

            
            NSDictionary * dic;
            
            NSString * type=_typeIndex==0?@"2":[NSString stringWithFormat:@"%d",_typeIndex-1];
            if ([type isEqualToString:@"2"]) {
                dic =@{@"id":[NSString stringWithFormat:@"%@",idValue],
                       @"person":[NSString stringWithFormat:@"%@",perValue],
                       @"num":[NSString stringWithFormat:@"%@",numValue],
                       @"bank":[NSString stringWithFormat:@"%@",bankValue],
                       @"KaiHuHang":[NSString stringWithFormat:@"%@",kaiValue],
                       @"type":type};
            }else{
                dic =@{@"id":[NSString stringWithFormat:@"%@",idValue],
                       @"person":[NSString stringWithFormat:@"%@",perValue],
                       @"num":[NSString stringWithFormat:@"%@",numValue],
                       //                   @"bank":[NSString stringWithFormat:@"%@",bankValue],
                       //                   @"KaiHuHang":[NSString stringWithFormat:@"%@",kaiValue],
                       @"type":type};
            }

            [self startAnimating:nil];
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
            NSDictionary * dic;
            
            NSString * type=_typeIndex==0?@"2":[NSString stringWithFormat:@"%d",_typeIndex-1];
            if ([type isEqualToString:@"2"]) {
               dic =@{@"uid":[NSString stringWithFormat:@"%@",idValue],
                   @"person":[NSString stringWithFormat:@"%@",perValue],
                   @"num":[NSString stringWithFormat:@"%@",numValue],
                   @"bank":[NSString stringWithFormat:@"%@",bankValue],
                   @"KaiHuHang":[NSString stringWithFormat:@"%@",kaiValue],
                   @"type":type};
            }else{
                dic =@{@"uid":[NSString stringWithFormat:@"%@",idValue],
                   @"person":[NSString stringWithFormat:@"%@",perValue],
                   @"num":[NSString stringWithFormat:@"%@",numValue],
//                   @"bank":[NSString stringWithFormat:@"%@",bankValue],
//                   @"KaiHuHang":[NSString stringWithFormat:@"%@",kaiValue],
                   @"type":type};
            }
            
            

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
-(void)submitOrCancel:(UIButton *)sender{
    [self controlBtn:nil];
    if (sender.tag==101) {
        _labelBank.text=[NSString stringWithFormat:@"%@",[_bankList[_selectedIndex] valueForKey:@"Bank_name"]];
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
