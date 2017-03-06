//
//  MyBankCard.m
//  TyreAlliance
//
//  Created by wdx on 16/9/26.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MyBankCard.h"
#import "EditBankCard.h"
//#import "AddBankCard.h"
#import "EditFinanceAccount.h"



@interface MyBankCard ()
@property (nonatomic,strong)NSMutableDictionary * dataDic;



@end

@implementation MyBankCard

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
//    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"我的银行卡";
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
    _isHave=NO;
    _dataDic=[NSMutableDictionary dictionary];
    
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
            [self newView:YES];
            _isHave=YES;
        }else{
//            if ([msg isEqualToString:@"没有绑定银行卡"]) {
                [self newView:NO];
//            }
            _isHave=NO;
        }
    }];
}

-(void)newView:(BOOL)isHave{
    
    CGFloat setY=self.NavImg.bottom+10*self.scale;
    for (int i =0; i < 2; i ++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0,  setY, Vwidth, 40*self.scale)];
        [self.view addSubview:cellView];
       
        if (i==0) {

//            if (isHave) {//判断有无银行卡
//            cellView.height=60*self.scale;
//                UILabel * labelBankName =[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 80*self.scale, 20*self.scale)];
//                labelBankName.font=DefaultFont(self.scale);
//                labelBankName.textColor=blackTextColor;
//                [cellView addSubview:labelBankName];
//                labelBankName.text=[NSString stringWithFormat:@"%@",_dataDic[@"bank_name"]];
//                
//                UILabel * labelZhiName=[[UILabel alloc]initWithFrame:CGRectMake(labelBankName.left, labelBankName.bottom, labelBankName.width, labelBankName.height)];
//                labelZhiName.font=Small10Font(self.scale);
//                labelZhiName.textColor=blackTextColor;
//                [cellView addSubview:labelZhiName];
//                labelZhiName.text=[NSString stringWithFormat:@"%@",_dataDic[@"bank_zhi_name"]];
//                
//                UILabel * labelOwer=[[UILabel alloc]initWithFrame:labelBankName.frame];
//                labelOwer.top=labelZhiName.bottom;
//                labelOwer.font=DefaultFont(self.scale);
//                labelOwer.textColor=blackTextColor;
//                [cellView addSubview:labelOwer];
//                labelOwer.text=[NSString stringWithFormat:@"持卡人:%@",_dataDic[@"bank_person"]];
//                [labelOwer sizeToFit];
//                
//                UILabel * labelNum=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Vwidth-20*self.scale-labelZhiName.width, 20*self.scale)];
//                [cellView addSubview:labelNum];
//                labelNum.font=DefaultFont(self.scale);
//                labelNum.textColor=blackTextColor;
//                labelNum.textAlignment=NSTextAlignmentRight;
//                labelNum.right=Vwidth-10*self.scale;
//                labelNum.centerY=labelZhiName.centerY;
//                labelNum.text=[NSString stringWithFormat:@"%@",_dataDic[@"bank_num"]];
//                
//                cellView.height=labelOwer.bottom+10*self.scale;
//                
//                
//            }else{
//                cellView.height=50*self.scale;
//                cellView.titleLabel.text=@"你还没有绑定银行卡";
//                [cellView.titleLabel sizeToFit];
//            }

        }
        
        if (i==1) {
           
            if (isHave) {
                cellView.titleLabel.text=@"编辑银行卡";
            }else{
                cellView.titleLabel.text=@"添加银行卡";
            }
            cellView.top=self.NavImg.bottom+10*self.scale;
            [cellView.titleLabel sizeToFit];
            [cellView ShowRight:YES];
            [cellView.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
         setY=cellView.bottom+10*self.scale;
    }
    UILabel * labelTip=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, setY, Vwidth-20*self.scale, 20*self.scale)];
    labelTip.font=DefaultFont(self.scale);
    labelTip.textColor=grayTextColor;
    labelTip.numberOfLines=1;
    [self.view addSubview:labelTip];
    labelTip.text=@"温馨提示:只能添加本人的银行卡!";
    
    setY=labelTip.bottom+10*self.scale;
}
-(void)btnEvent:(UIButton *)sender{
    
    EditBankCard * edit=[EditBankCard new];
    edit.isHave=_isHave;
    edit.cardInfo=_dataDic;
    edit.block=^(BOOL secc){
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popViewControllerAnimated:YES];
        
        if (_block) {
            _block(YES);
        }
    };
    edit.cId=[NSString stringWithFormat:@"%@",_dataDic[@"bank_id"]];
    [self.navigationController pushViewController:edit animated:YES];
    
    
 
    
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
