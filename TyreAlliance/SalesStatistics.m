//
//  SalesStatistics.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SalesStatistics.h"
#import "EvaluateCell.h"

@interface SalesStatistics ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSDate * starttime;
@property (nonatomic,strong)NSDate * endtime;


@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)NSMutableArray * datas;


@property (nonatomic,strong)UILabel * labelAllCount;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIControl * screenControl;

@property (nonatomic,strong)UIControl * dateControl;
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)UIButton * btnStart;
@property (nonatomic,strong)UIButton * btnEnd;

@end

@implementation SalesStatistics

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"销售统计";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
        [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
 
    
    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    
    screenBtn.right=self.NavImg.right-10*self.scale;
    screenBtn.height=25*self.scale;
    screenBtn.centerY=self.TitleLabel.centerY;
    screenBtn.tag=100;
    [screenBtn setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal];
    [screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [screenBtn setTitle:@"确定" forState:UIControlStateSelected];
    
    [screenBtn addTarget:self action:@selector(screenBtn:) forControlEvents:UIControlEventTouchUpInside];

    screenBtn.layer.cornerRadius=3;
    screenBtn.layer.masksToBounds=YES;
    screenBtn.titleLabel.font=SmallFont(self.scale);
    [self.NavImg addSubview:screenBtn];
    
}
-(void)screenBtn:(UIButton *)sender{
    UIButton * btn=[self.NavImg viewWithTag:100];
    
    if (_screenControl.hidden==YES) {
        btn.selected=YES;
        _screenControl.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            _screenControl.alpha=1;
        }];
    }else{
        btn.selected=NO;
        if (sender.tag==100) {
            _yeIndex=1;
            [self reshData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _screenControl.alpha=0;
        } completion:^(BOOL finished) {
            _screenControl.hidden=YES;
        }];
    }
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData{
    _dataDic=[NSMutableDictionary dictionary];
    _datas=[NSMutableArray array];
    _yeIndex=1;
    
    
    
    NSDateFormatter * fo=[[NSDateFormatter alloc]init];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    [fo setDateFormat:@"yyyy-MM-dd"];
    _starttime=[fo dateFromString:@"2000-01-01"];
    _endtime=[NSDate date];
    
    
}
-(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter * fo=[[NSDateFormatter alloc]init];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    [fo setDateFormat:@"yyyy-MM-dd"];
    
   return  [fo stringFromDate:date];
}
-(void)reshData{
    [self startAnimating:nil];
    NSDictionary *dic=@{@"bid":[Stockpile sharedStockpile].ID,
                        @"startime":[self stringFromDate:_starttime],
                        @"endtime":[self stringFromDate:_endtime],
                        @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
    
    [AnalyzeObject getSalesStatisticsWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];
        
        
        if (_dataDic) {
            [_dataDic removeAllObjects];
        }
        [_dataDic addEntriesFromDictionary:model];
        NSArray * datas=_dataDic[@"Product_list"];
        
        if ([ret isEqualToString:@"1"]) {
 
            if (_yeIndex==1) {
                [_datas removeAllObjects];
            }
            [_datas addObjectsFromArray:datas];
            
            if (datas.count==0) {
                [self showPromptBoxWithSting:@"没有更多数据"];
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self showPromptBoxWithSting:msg];
                [_tableView.mj_footer endRefreshing];
            }
   
        }else{
            [_tableView.mj_footer endRefreshing];
            [self showPromptBoxWithSting:msg];
            
        }
                 [self reshView];
    }];
    
    
}
-(void)reshView{
    _labelAllCount.text=[NSString stringWithFormat:@"%@",_dataDic[@"soldcount"]];
    [_tableView reloadData];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _tableView.tableHeaderView=[self headView];
    [_tableView registerClass:[EvaluateCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor=superBackgroundColor;
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    
    _screenControl=[self newScreenControl];
    _screenControl.hidden=YES;
    _screenControl.alpha=1;
    [self.view addSubview:_screenControl];
    
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(UIView *)headView{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 40*self.scale)];
    headView.backgroundColor=[UIColor whiteColor];
    
    
    UILabel * totalSale=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 20*self.scale)];
    totalSale.font=DefaultFont(self.scale);
    totalSale.textColor=blackTextColor;
    [headView addSubview:totalSale];
    totalSale.text=@"总销量";
    
    
    UILabel * totalSaleCount=[[UILabel alloc]initWithFrame:totalSale.frame];
    totalSaleCount.right=Vwidth-10*self.scale;
    totalSaleCount.font=DefaultFont(self.scale);
    totalSaleCount.textAlignment=NSTextAlignmentRight;
    totalSaleCount.textColor=lightOrangeColor;
    [headView addSubview:totalSaleCount];
    totalSaleCount.text=[NSString stringWithFormat:@"%d",0];
    _labelAllCount=totalSaleCount;
    return headView;
}


#pragma  mark --- delegate datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic=_datas[indexPath.section];
    [cell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"P_Logo"]]] placeholderImage:[UIImage imageNamed:@"luntai_tai"]];
    cell.labelIntro.text=[NSString stringWithFormat:@"名称:%@",dic[@"P_name"]];
    cell.labelStandard.text=[NSString stringWithFormat:@"规格:%@",dic[@"P_GuiGe"]];
    cell.labelComCount.text=[NSString stringWithFormat:@"评价数量:%@",dic[@"count"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1*self.scale;
}
-(UIControl *)newScreenControl{
    UIControl * bgControl=[[UIControl alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    bgControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [bgControl addTarget:self action:@selector(screenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 30*self.scale)];
    timeView.backgroundColor=[UIColor whiteColor];
    [bgControl addSubview:timeView];
    
    UILabel * startLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 45*self.scale, 20*self.scale)];
    startLabel.font=DefaultFont(self.scale);
    startLabel.textColor=blackTextColor;
    [timeView addSubview:startLabel];
    startLabel.text=@"起时间";
    
    NSDateFormatter * fo=[[NSDateFormatter alloc]init];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    [fo setDateFormat:@"yyyy-MM-dd"];
    
    
    UIButton * startBtn=[[UIButton alloc]initWithFrame:CGRectMake(startLabel.right+10*self.scale, startLabel.top, 70*self.scale, 20*self.scale)];
    startBtn.titleLabel.font=Small10Font(self.scale);
    [startBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    startBtn.layer.cornerRadius=3;
    startBtn.layer.masksToBounds=YES;
    startBtn.layer.borderColor=blackLineColore.CGColor;
    startBtn.layer.borderWidth=1;
    [timeView addSubview:startBtn];
    [startBtn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [startBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    startBtn.tag=100;
    _btnStart=startBtn;
    [startBtn addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
    NSString * start=[fo stringFromDate:_starttime];
    start = [start stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [startBtn setTitle:start forState:UIControlStateNormal];
    
    UIButton * endBtn=[[UIButton alloc]initWithFrame:CGRectMake(startLabel.right+10*self.scale, startLabel.top, 70*self.scale, 20*self.scale)];
    endBtn.right=Vwidth-10*self.scale;
    endBtn.titleLabel.font=Small10Font(self.scale);
    [endBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    endBtn.layer.cornerRadius=3;
    endBtn.layer.masksToBounds=YES;
    endBtn.layer.borderColor=blackLineColore.CGColor;
    endBtn.layer.borderWidth=1;
    [timeView addSubview:endBtn];
//    [endBtn setTitle:@"08/27/2016" forState:UIControlStateNormal];
    [endBtn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [endBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    [endBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
    [endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    endBtn.tag=101;
    _btnEnd=endBtn;
    [endBtn addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
    NSString * end=[fo stringFromDate:_endtime];
    end = [end stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [endBtn setTitle:end forState:UIControlStateNormal];
    
    
    UILabel * endLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 45*self.scale, 20*self.scale)];
    endLabel.right=endBtn.left-10*self.scale;
    endLabel.font=DefaultFont(self.scale);
    endLabel.textColor=blackTextColor;
    [timeView addSubview:endLabel];
    endLabel.text=@"止时间";
    
    UIView * line=[[UIView alloc]initWithFrame:CGRectMake(startBtn.right+5*self.scale, startLabel.centerY, endLabel.left-startBtn.right-10*self.scale, 1*self.scale)];
    line.backgroundColor=blackLineColore;
    [timeView addSubview:line];
    
//    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 100*self.scale)];
//    [bgControl addSubview:_datePicker];
//    _datePicker.backgroundColor=[UIColor whiteColor];
//    _datePicker.bottom=bgControl.height;
//    _datePicker.hidden=YES;
//      _datePicker.alpha=0;
    
    return bgControl;
}
//-(void)chooseTime:(UIButton*)sender{
//    [self newDateControl];
//    _btnEnd.selected=NO;
//    _btnStart.selected=NO;
//    sender.selected=YES;
//    
//    
////    if (_datePicker.hidden==YES) {
////        _datePicker.hidden=NO;
////        [UIView animateWithDuration:0.3 animations:^{
////            _datePicker.alpha=1;
////        }];
////    }else{
////        [UIView animateWithDuration:0.3 animations:^{
////            _datePicker.alpha=0;
////        } completion:^(BOOL finished) {
////            _datePicker.hidden=YES;
////        }];
////    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- date picker
-(void)newDateControl{
    
    UIControl * control=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vheight)];
    control.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    control.hidden=NO;
    control.alpha=1;
    [self.view addSubview:control];
    [control addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIDatePicker * datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 150*self.scale)];
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.bottom=control.height;
    [control addSubview:datePicker];
    datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker=datePicker;
    _dateControl=control;
    
    
    UIView * btnBg=[[UIView  alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 30*self.scale)];
    [_dateControl addSubview:btnBg];
    btnBg.bottom=_datePicker.top;
    btnBg.backgroundColor=[UIColor whiteColor];
    
    
    NSArray * btnTitles=@[@"取消",@"确定"];
    //        CGFloat bottonBtnH=30*self.scale;
    for (int i =0; i < 2;  i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 0, 50*self.scale,btnBg.height)];
        [btnBg addSubview:btn];
        [btn addTarget:self action:@selector(commitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:lightOrangeColor forState:UIControlStateNormal];
        btn.titleLabel.font=DefaultFont(self.scale);
        btn.tag=10000+i;
        if (i==0) {
            //                [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
            //                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.right=Vwidth-10*self.scale;
        }
        //            btn.bottom=_datePicker.top;
    }
    
    if (_btnStart.selected) {
        _datePicker.date=_starttime;
    }else{
        _datePicker.date=_endtime;
    }
}
-(void)timeBtn:(UIButton *)sender{
    if (sender.tag==100 || sender.tag==101) {
        _btnStart.selected=NO;
        _btnEnd.selected=NO;
        sender.selected=YES;
    }
    
    if (!_dateControl) {
        [self newDateControl];
        return;
    }
    
    
    
    if (self.dateControl.hidden==YES) {
        if (_btnStart.selected) {
            _datePicker.date=_starttime;
        }else{
            _datePicker.date=_endtime;
        }
        _dateControl.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            _dateControl.alpha=1;
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            _dateControl.alpha=0;
        } completion:^(BOOL finished) {
            _dateControl.hidden=YES;
        }];
    }
    
    
}
-(void)commitOrCancel:(UIButton *)sender{
    
    if (sender.tag!=10000) {
        NSDateFormatter * fo=[[NSDateFormatter alloc]init];
        [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
        [fo setDateFormat:@"yyyy-MM-dd"];
        NSString * time=[fo stringFromDate:_datePicker.date];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
        if (_btnStart.selected==YES) {
            _starttime=[fo dateFromString:time];
            [_btnStart setTitle:time forState:UIControlStateNormal];
        }
        if (_btnEnd.selected==YES) {
            _endtime=[fo dateFromString:time];
            [_btnEnd setTitle:time forState:UIControlStateNormal];
        }
//        [self reshData];
    }
    [self timeBtn:nil];
    
    
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
