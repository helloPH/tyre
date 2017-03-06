//
//  EvaluateManage.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EvaluateManage.h"
#import "EvaluateCell.h"
#import "EvaluateDetail.h"


@interface EvaluateManage ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)BOOL isB;
@property (nonatomic,assign)BOOL isS;


@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)NSMutableArray * brands;
@property (nonatomic,strong)NSMutableArray * standards;
@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSString * brandsId;
@property (nonatomic,strong)NSString * standerId;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIControl * screenControl;
@end

@implementation EvaluateManage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
//    [self newView];
    // Do any additional setup after loading the view.
}

-(void)newNavi{
    self.TitleLabel.text=@"评价管理";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
        [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];

    screenBtn.right=self.NavImg.right-10*self.scale;
    screenBtn.height=25*self.scale;
    screenBtn.centerY=self.TitleLabel.centerY;
//    screenBtn.width=popBtn.width*(3/2.0);
    [screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [screenBtn addTarget:self action:@selector(screenBtn:) forControlEvents:UIControlEventTouchUpInside];

    [screenBtn setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal];
    screenBtn.layer.cornerRadius=3;
    screenBtn.layer.masksToBounds=YES;
    screenBtn.titleLabel.font=SmallFont(self.scale);
    [self.NavImg addSubview:screenBtn];
    
}

-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    _yeIndex=1;
    _brandsId=@"-1";
    _standerId=@"-1";
    _datas=[NSMutableArray arrayWithArray:@[]];
}

-(void)reshData{
    [self startAnimating:nil];
    NSDictionary * dic=@{@"bid":[Stockpile sharedStockpile].ID,
                         @"ye":[NSString stringWithFormat:@"%d",_yeIndex],
                         @"pinpai":_brandsId,
                         @"guige":_standerId
                         };
    [AnalyzeObject getRecomListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];

        
        
        
        if (_yeIndex==1) {
            [_datas removeAllObjects];
        }
        if ([ret isEqualToString:@"1"]) {
  
            NSArray * datas=[(NSDictionary *)model objectForKey:@"Product_list"];
            
            [_datas addObjectsFromArray:datas];
            [self reshView];
            
            if ([datas count]==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            
            
//            [self showFailed:NO];
        }else{
            [_tableView.mj_footer endRefreshing];
//            if (_datas.count==0) {
//                [self showFailed:YES];
//            }
        }
        [self showBtnEmpty:_datas.count==0?YES:NO];
        
    }];
    
    
}
-(void)reshView{
//    [self showBtnEmpty:_datas.count==0?YES:NO];
    [_tableView reloadData];
}
-(void)screenBtn:(UIButton *)sender{
    if (!_screenControl) {
        [self loadScreenData];
        [self.view bringSubviewToFront:_screenControl];
//        _screenControl=[self newScreenControl];
        return;
    }
    
    
    if (_screenControl.hidden==YES) {
        _screenControl.hidden=NO;
        [self.view bringSubviewToFront:_screenControl];
        [UIView animateWithDuration:0.3 animations:^{
            _screenControl.alpha=1;
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            _screenControl.alpha=0;
        } completion:^(BOOL finished) {
            _screenControl.hidden=YES;
        }];
    }
    
}
-(void)loadScreenData{

    _brands=[NSMutableArray arrayWithArray:@[@{@"P_name":@"全部",@"P_id":@"-1"}]];
    _standards=[NSMutableArray arrayWithArray:@[@{@"G_name":@"全部",@"G_id":@"-1"}]];
    _isB=NO;
    _isS=NO;
    [self startAnimating:nil];

    
    NSDictionary * dic1;
    [AnalyzeObject getBrandsListWithDic:dic1 WithBlock:^(id model, NSString *ret, NSString *msg) {

        if ([ret isEqualToString:@"1"]) {
            [_brands addObjectsFromArray:model];
//            for (NSDictionary * dic in (NSArray *)model) {
//                if ([dic isKindOfClass:[NSDictionary class]]) {
//                    [_brands addObject:dic[@"P_name"]];
//                }
//            }
        }else{
            [self showPromptBoxWithSting:msg];
        }

        _isB=YES;
        if (_isS) {
            [self stopAnimating];
            _screenControl=[self newScreenControl];

        }
    }];
    
    
    NSDictionary * dic2;
    [AnalyzeObject getStanderListWithDic:dic2 WithBlock:^(id model, NSString *ret, NSString *msg) {

        if ([ret isEqualToString:@"1"]) {
            [_standards addObjectsFromArray:model];
//            for (NSDictionary * dic in (NSArray *)model) {
//                if ([dic isKindOfClass:[NSDictionary class]]) {
//                    [_standards addObject:dic[@"G_name"]];
//                }
//            }
         
        }else{
            [self showPromptBoxWithSting:msg];
        }
        
        
        _isS=YES;
        if (_isB) {
            [self stopAnimating];
           _screenControl=[self newScreenControl];
        }
    }];
    
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[EvaluateCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    [_tableView addHeardTarget:self Action:@selector(xiaLa)];
    [_tableView addFooterTarget:self Action:@selector(shangLa)];
//    _screenControl=[self newScreenControl];

    
}
-(void)shangLa{
    _yeIndex++;
    [self reshData];
}
-(void)xiaLa{
    _yeIndex=1;
    [self reshData];
}



#pragma mark -- tableView delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluateCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dataDic=_datas[indexPath.section];

 
//    NSMutableString * baseUrl=[NSString stringWithFormat:@"%@", @"http://tlm.ruanmengapp.com"];
//    [baseUrl stringByAppendingString:[NSString stringWithFormat:@"%@",dataDic[@"P_Logo"]]];
    
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",dataDic[@"P_Logo"]]]] placeholderImage:[UIImage imageNamed:@"noData"]];
    
   
    
    
//    cell.labelIntro.text=[NSString stringWithFormat:@"名称:%@",dataDic[@"P_name"]];
    NSMutableAttributedString * text11=[[NSMutableAttributedString alloc]initWithString:@"名称："];
    NSMutableAttributedString * text12=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",dataDic[@"P_name"]]];
    [text12 addAttribute:NSForegroundColorAttributeName value:grayTextColor range:NSMakeRange(0, text12.length)];
    [text11 appendAttributedString:text12];
    cell.labelIntro.attributedText=text11;
    
    
    
    
    NSMutableAttributedString * text21=[[NSMutableAttributedString alloc]initWithString:@"规格："];
    NSMutableAttributedString * text22=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",dataDic[@"P_GuiGe"]]];
    [text22 addAttribute:NSForegroundColorAttributeName value:grayTextColor range:NSMakeRange(0, text22.length)];
    [text21 appendAttributedString:text22];
    cell.labelStandard.attributedText=text21;
    
    
    NSMutableAttributedString * text31=[[NSMutableAttributedString alloc]initWithString:@"评价数量："];
    NSMutableAttributedString * text32=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",dataDic[@"count"]]];
    [text32 addAttribute:NSForegroundColorAttributeName value:grayTextColor range:NSMakeRange(0, text32.length)];
    [text31 appendAttributedString:text32];
    cell.labelComCount.attributedText=text31;
//    cell.labelComCount.text=[NSString stringWithFormat:@"评价数量:%@",dataDic[@"count"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluateDetail * evaluateDetail=[EvaluateDetail new];
    NSDictionary * dataDic=_datas[indexPath.section];
    evaluateDetail.pid=dataDic[@"P_id"];
    [self.navigationController pushViewController:evaluateDetail animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1*self.scale;
}


#pragma  mark  -- screen 
-(UIControl *)newScreenControl{
    UIControl * bgControl=[[UIControl alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    bgControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 100)];
    bgView.backgroundColor=[UIColor whiteColor];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]init]];
    [bgControl addSubview:bgView];
    bgView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenBtn:)];
    [bgControl addGestureRecognizer:tap];
    CGFloat setY=0;
    // -------------------- 品牌---------------------------
    
    UILabel * labelBrand=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 50*self.scale, 20*self.scale)];
    [bgView addSubview:labelBrand];
    labelBrand.text=@"品牌:";
    labelBrand.font=DefaultFont(self.scale);
    labelBrand.textColor=blackTextColor;
    setY=labelBrand.bottom+10*self.scale;
    
    NSInteger column =4;
    CGFloat margin=20*self.scale;
    CGFloat spaceX=10*self.scale;
    CGFloat spaceY=10*self.scale;
    CGFloat btnW =(Vwidth - margin*2 -spaceX * (column -1))/column;
    CGFloat btnH =25*self.scale;

  
    for (int i =0; i < _brands.count; i ++) {
        NSDictionary * dic=_brands[i];
        
        CGFloat btnX= (i % column) * (btnW + spaceX) + margin;
        CGFloat btnY= i / column * (btnH + spaceY) +labelBrand.bottom+10*self.scale;
        
        
        UIButton * bgBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        bgBtn.titleLabel.font=Small10Font(self.scale);
        [bgBtn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [bgBtn setTitleColor:navigationControllerColor forState:UIControlStateNormal];
        
        [bgBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
        [bgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        if (i==0) {
            [bgBtn setBackgroundImage:[UIImage imageNamed:@"all_ding"] forState:UIControlStateSelected];
            [bgBtn setTitleColor:navigationControllerColor forState:UIControlStateSelected];
            bgBtn.selected=YES;
        }
        bgBtn.layer.cornerRadius=3;
        bgBtn.layer.masksToBounds=YES;
        bgBtn.layer.borderColor=navigationControllerColor.CGColor;
        bgBtn.layer.borderWidth=0.5*self.scale;
        [bgBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"P_name"]] forState:UIControlStateNormal];


      
        bgBtn.tag=100+i;
        
        [bgView addSubview:bgBtn];
        [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        bgBtn.selected=YES;
        setY=bgBtn.bottom+spaceY;
    }
    
    UIImageView * segmentLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 0.5)];
    segmentLine.backgroundColor=blackLineColore;
    [bgView addSubview:segmentLine];
    setY=segmentLine.bottom;
        // -------------------- 规格---------------------------
    UILabel * labelStand=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, segmentLine.bottom+10*self.scale, 50*self.scale, 20*self.scale)];
    [bgView addSubview:labelStand];
    labelStand.text=@"规格:";
    labelStand.font=DefaultFont(self.scale);
    labelStand.textColor=blackTextColor;
    setY=labelStand.bottom+10*self.scale;

    
    for (int i =0; i < _standards.count; i ++) {
        NSDictionary * dic= _standards[i];
        CGFloat btnX= (i % column) * (btnW + spaceX) + margin;
        CGFloat btnY= i / column * (btnH + spaceY) +labelStand.bottom+10*self.scale;
        
        
        UIButton * bgBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        bgBtn.titleLabel.font=Small10Font(self.scale);
        [bgBtn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [bgBtn setTitleColor:navigationControllerColor forState:UIControlStateNormal];
        [bgBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
        [bgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [bgBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"G_name"]] forState:UIControlStateNormal];
        
        if (i==0) {
            [bgBtn setBackgroundImage:[UIImage imageNamed:@"all_ding"] forState:UIControlStateSelected];
            [bgBtn setTitleColor:navigationControllerColor forState:UIControlStateSelected];
            bgBtn.selected=YES;
        }
        bgBtn.layer.cornerRadius=3;
        bgBtn.layer.masksToBounds=YES;
        bgBtn.layer.borderColor=navigationControllerColor.CGColor;
        bgBtn.layer.borderWidth=0.5*self.scale;
        bgBtn.tag=1000+i;
        
        [bgView addSubview:bgBtn];
        [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//          bgBtn.selected=YES;
        setY=bgBtn.bottom+spaceY;
    }
    
    
    
    
    
    
    
    CGFloat setYY=setY;
    NSArray * btnTitles=@[@"确定",@"取消"];
    CGFloat bottonBtnH=40*self.scale;
    for (int i =0; i < 2;  i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(bgControl.width/2 * i, setYY, bgControl.width/2, bottonBtnH)];
        [bgView addSubview:btn];
        [btn addTarget:self action:@selector(commitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:blueTextColor forState:UIControlStateNormal];
        btn.titleLabel.font=DefaultFont(self.scale);
        btn.tag=10000+i;
        if (i==0) {
            [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            UIImageView * btnLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vwidth/2, 0.5)];
            btnLine.backgroundColor=blackLineColore;
            [btn addSubview:btnLine];
        }
        setY=btn.bottom;
    }
    bgView.height=setY;
    
    
    
    bgControl.hidden=NO;
    bgControl.alpha=1;
    [self.view addSubview:bgControl];
    return bgControl;
}
-(void)btnClick:(UIButton *)sender{
//    sender.selected=!sender.selected;
    
    NSInteger baseTag;
    NSInteger count;
    
    if (sender.tag<1000) {//品牌
        baseTag=100;
        count=_brands.count;
        
    }else{//规格
        baseTag=1000;
        count=_standards.count;
        
    }

    if (!sender.selected && sender.tag==baseTag) {//点击的是全部按钮  状态是NO
        for (int i=baseTag; i < count+baseTag; i ++) {//单选
            UIButton * btn=(UIButton *)[_screenControl viewWithTag:i];
            btn.selected=NO;
        }
        
        sender.selected=YES;
        
//        for (int i=baseTag; i < count+baseTag; i ++) {
//            UIButton * btn=(UIButton *)[_screenControl viewWithTag:i];
//            btn.selected=YES;
//        }

    }else   if (sender.tag!=baseTag) {
        for (int i=baseTag; i < count+baseTag; i ++) {//单选
            UIButton * btn=(UIButton *)[_screenControl viewWithTag:i];
            btn.selected=NO;
        }
        
        sender.selected=YES;
    }
    
    if (baseTag==100) {
        NSDictionary * dic=_brands[sender.tag-100];
        _brandsId=[NSString stringWithFormat:@"%@",dic[@"P_id"]];
    }else{
        NSDictionary * dic=_standards[sender.tag-1000];
        _standerId=[NSString stringWithFormat:@"%@",dic[@"G_id"]];
    }

}
-(void)commitOrCancel:(UIButton *)sender{
    if (sender.tag==10000) {
        _yeIndex=1;
        [self reshData];
    }
    [self screenBtn:nil];
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
