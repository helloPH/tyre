//
//  EditBankCard.m
//  TyreAlliance
//
//  Created by wdx on 16/9/27.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EditBankCard.h"

@interface EditBankCard ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)NSMutableArray * bankList;
@property (nonatomic,assign)NSInteger selectedIndex;


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
    [self newView];
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
    
}
-(void)reshData{
    
}
-(void)newView{
    NSArray * titles=@[@{@"title":@"姓名:",@"place":@"请输入您的姓名"},
                       @{@"title":@"卡号:",@"place":@"请输入您的银行卡号"},
                       @{@"title":@"所属银行",@"place":@""},
                       @{@"title":@"开户行:",@"place":@"请输入您的开户行地址"}];
    CGFloat setY=0;
    for ( int i = 0; i < titles.count; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale+i *40*self.scale, Vwidth, 40*self.scale)];
        [self.view addSubview:cellView];
        
        cellView.titleLabel.text=[titles[i] valueForKey:@"title"];
        [cellView.titleLabel sizeToFit];
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(cellView.titleLabel.right+10*self.scale, 0, 150*self.scale, cellView.titleLabel.height)];
        
        tf.centerY=cellView.titleLabel.centerY;
        tf.textColor=blackTextColor;
        tf.font=DefaultFont(self.scale);
        tf.placeholder=[titles[i] valueForKey:@"place"];
        
        if (i != 2) {
            [cellView addSubview:tf];
        }
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
        NSDictionary * dic=@{@"id":[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].ID],
                             @"person":[NSString stringWithFormat:@"%@",_tfBankName.text],
                             @"num":[NSString stringWithFormat:@"%@",_tfCardNum.text],
                             @"bank":[NSString stringWithFormat:@"%@",_labelBank.text],
                             @"KaiHuHang":[NSString stringWithFormat:@"%@",_tfBankName.text]};
        [AnalyzeObject updateCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            if ([ret isEqualToString:@"1"]) {
                
            }else{
                
                
            }
            [self showPromptBoxWithSting:msg];
        }];
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
