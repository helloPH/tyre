//
//  AddYinHangKaViewController.m
//  YingXiao
//
//  Created by apple on 16/1/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddYinHangKaViewController.h"
#import "CellView.h"

@interface AddYinHangKaViewController ()<UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,strong)UIImageView *SelectImg;
@property(nonatomic,strong)UIPickerView *TimePickerView;
@property(nonatomic,strong)NSMutableArray *shiData,*shengData;
@end

@implementation AddYinHangKaViewController


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shengData = [[NSMutableArray alloc]initWithObjects:@"储蓄卡",@"信用卡", nil];
    _shiData = [[NSMutableArray alloc]initWithObjects:@"中国工商银行",
    @"中国银行",
    @"建设银行",
   @"中国农业银行",
    @"交通银行",
    @"中国邮政",
    @"中国人民银行",
                
                @"招商银行",
                @"兴业银行",
                @"中国中信银行",
                @"中国光大银行",
                @"中国民生银行",
                @"华夏银行",
                @"中国农村信用社",
                nil];
    
    
    [self retureVi];
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimating];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getInfo:@{@"uid":[Stockpile sharedStockpile].ID} WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"1"]) {
            
        }
        [self newView:models];

    }];
    
}



-(void)newView:(NSDictionary *)dic{
    
    
    if (!dic) {
        dic = [NSDictionary new];
    }
    
    NSArray *arr = @[@"姓名：",@"身份证：",@"卡号：",@"所属银行"];
    NSArray *ar = @[@"请输入您的姓名",@"请输入您的身份证号码",@"请输入您的银行卡号",@""];
//    NSString *cardid = [NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].cardId];
//    NSString *relaname = [NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].relaName];

//    if (![cardid isValidateIdentityCard]) {
//       cardid=@"";
//    }
    
    float setY =self.NavImg.bottom;
    for (int i=0; i<arr.count; i++) {
        
        CellView *cell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 40*self.scale)];
        cell.title=arr[i];
        [self.view addSubview:cell];
        [cell.titleLabel sizeToFit];
        cell.titleLabel.height=20*self.scale;
        
        UITextField *tf  = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right+10*self.scale, cell.titleLabel.top, self.view.width-cell.titleLabel.right-20*self.scale, 20*self.scale)];
        tf.font=DefaultFont(self.scale);
        tf.placeholder=ar[i];
        tf.tag=i+1;
        [cell addSubview:tf];
        
        if (i==0) {
            tf.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
        }
        
        if (i==1) {
            tf.text=[NSString stringWithFormat:@"%@",dic[@"shen"]];
        }
        
        if (i==2) {
            tf.keyboardType=UIKeyboardTypePhonePad;
        }
        
        
        if (i==3) {
            tf.userInteractionEnabled=NO;
            [cell ShowRight:YES];
            [cell.btn addTarget:self action:@selector(suoshuYinHang) forControlEvents:UIControlEventTouchUpInside];
        }
        
        setY = cell.bottom;
    }

    UIButton *queDing = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, self.view.width-20*self.scale, 30*self.scale)];
    queDing.layer.cornerRadius=4;
    queDing.layer.masksToBounds=YES;
    queDing.backgroundColor = [UIColor orangeColor];
    [queDing setTitle:@"确定" forState:0];
    queDing.titleLabel.font=DefaultFont(self.scale);
    [queDing addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queDing];



}

-(void)queding{
    [self.view endEditing:YES];

    UITextField *tf1 = (UITextField *)[self.view viewWithTag:1];//name
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:3];//idcard
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:4];//card
    UITextField *tf4 = (UITextField *)[self.view viewWithTag:5];//bank
    UITextField *tf5 = (UITextField *)[self.view viewWithTag:2];//bankofaddress
    
    NSLog(@"名字=%@",tf1.text);
    NSLog(@"卡号=%@",tf2.text);
    NSLog(@"所属新航=%@",tf3.text);
    NSLog(@"开户行=%@",tf4.text);
    NSLog(@"身份证=%@",tf5.text);

    
    
    if ([[NSString stringWithFormat:@"%@",tf1.text] isEmptyString] || [[NSString stringWithFormat:@"%@",tf2.text] isEmptyString] || [[NSString stringWithFormat:@"%@",tf3.text] isEmptyString] || [[[NSString stringWithFormat:@"%@",tf5.text] trimString]isEmptyString]) {
        [self ShowAlertWithMessage:@"请完善信息后提交"];
        return;
    }
    
    if ([tf2.text trimString].length<16 || [tf2.text trimString].length>19) {
        [self ShowAlertWithMessage:@"请输入正确的银行卡号"];
        return;
    }

    if (![[tf5.text trimString] isValidateIdentityCard]) {
        [self ShowAlertWithMessage:@"请输入正确的身份证号码"];
        return;
    }
    
    
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimating];
    
    
    NSArray *ar = [tf3.text componentsSeparatedByString:@" "];
    
    
    NSInteger a=0;
    
    if ([ar[1] isEqualToString:@"储蓄卡"]) {
        a=0;
    }else{
        a=1;
    }
    
    NSDictionary *dic = @{@"uid":[Stockpile sharedStockpile].ID,@"name":tf1.text,@"num":tf2.text,@"bname":ar[0],@"type":[NSString stringWithFormat:@"%ld",(long)a],@"shen":[tf5.text trimString]};
    
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle bangKa:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];

        if ([code isEqualToString:@"1"]) {
            [self ShowAlertWithMessage:@"添加成功"];
            [[Stockpile sharedStockpile] setCardId:[NSString stringWithFormat:@"%@",models[@"shen"]]];
            [[Stockpile sharedStockpile]setRelaName:[NSString stringWithFormat:@"%@",models[@"name"]]];
            [self.navigationController popViewControllerAnimated:YES];
            if (_reshKa) {
                _reshKa(@"ok");
            }
        }else{
            if ([msg isEqualToString:@"获取失败"]) {
            }else{
                [self ShowAlertWithMessage:msg];
                
            }
;
        }
        
    }];
    
}

#pragma mark------所属银行

-(void)suoshuYinHang{
    
    [self.view endEditing:YES];

    

            
                    _big = [[UIControl alloc]initWithFrame:self.view.bounds];
                    _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                    [self.view addSubview:_big];
                    
                    _SelectImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale)];
                    _SelectImg.userInteractionEnabled=YES;
                    _SelectImg.backgroundColor= [UIColor whiteColor];
                    [self.view addSubview:_SelectImg];
                    
                    [UIView animateWithDuration:.3 animations:^{
                        _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];        _SelectImg.frame=CGRectMake(0, self.view.height-180*self.scale, self.view.width, 180*self.scale);
                        
                    }];
                    
                    
                    
                    
                    _TimePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,_SelectImg.height/2-40*self.scale, self.view.width, 120*self.scale)];
                    _TimePickerView.delegate = self;
                    _TimePickerView.backgroundColor = [UIColor whiteColor];
                    _TimePickerView.dataSource = self;
                    [_SelectImg addSubview:_TimePickerView];
    
                    
                    UIButton *canBtn=[[UIButton alloc]initWithFrame:CGRectMake(30*self.scale, _TimePickerView.top-40*self.scale, 60*self.scale, 30*self.scale)];
                    [canBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [canBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
                    canBtn.tag=1;
                    [canBtn setTitle:@"取消" forState:UIControlStateNormal];
                    [canBtn setTitleColor:[UIColor orangeColor] forState:0];
                    canBtn.titleLabel.font=Big16Font(self.scale);
                    [_SelectImg addSubview:canBtn];
                    
                    UIButton *OKBtn=[[UIButton alloc]initWithFrame:CGRectMake(_SelectImg.width-90*self.scale, _TimePickerView.top-40*self.scale, 60*self.scale, 30*self.scale)];
                    [OKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [OKBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
                    OKBtn.titleLabel.font=Big16Font(self.scale);
                    
                    [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
                    [OKBtn setTitleColor:[UIColor orangeColor] forState:0];
                    OKBtn.tag=2;
                    [_SelectImg addSubview:OKBtn];
                    
                    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
                    topline.backgroundColor=blackLineColore;
                    [_SelectImg addSubview:topline];
                    
                    
                    ///////////
                    
                    
                    
                    

    
    
    
    
    
}

-(void)actionDone:(UIButton *)button{
    
    if (button.tag == 1) {
        [UIView animateWithDuration:.5 animations:^{
            _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
            _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }completion:^(BOOL finished) {
            [_big removeFromSuperview];
            
            
        }];
        return;
    }
    
    NSString *str =@"";
    str =[NSString stringWithFormat:@"%@ %@",[_shiData objectAtIndex:[_TimePickerView selectedRowInComponent:0]],[_shengData objectAtIndex:[_TimePickerView selectedRowInComponent:1]]];
    UITextField *tf = (UITextField *)[self.view viewWithTag:4];
    tf.text=str;
    
    
    [UIView animateWithDuration:.5 animations:^{
        _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
        _big.alpha=0;
    }completion:^(BOOL finished) {
        
        [_big removeFromSuperview];
        
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component==0) {
        return _shiData.count;

    }else{
        return 2;
    }
    
    
}
#pragma mark - UIPickerViewDatasource
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 100, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    if (component==0) {
        pickerLabel.text =  _shiData[row];  // Month

    }else{
        pickerLabel.text =  _shengData[row];  // Month
    }
   
    return pickerLabel;
}






#pragma mark -----返回按钮
-(void)retureVi{
    self.TitleLabel.text=@"添加银行卡";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
