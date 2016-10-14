//
//  EvaluateDetail.m
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EvaluateDetail.h"
#import "EvaluateDetailCell.h"


@interface EvaluateDetail ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,assign)NSInteger yeIndex;


@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UIButton * btnLeft;
@property (nonatomic,strong)UILabel * labelName,  * labelStander, * labelFive, * labelFour,* labelThree,* labelTwo,* labelOne;
//@property (nonatomic,strong)UILabel * labelStander;
//@property (nonatomic,strong)UILabel * labelLeft;
//@property (nonatomic,strong)UILabel * labelFive;
//@property (nonatomic,strong)UILabel * labelFour;
//@property (nonatomic,strong)UILabel * labelThree;
//@property (nonatomic,strong)UILabel * labelTwo;
//@property (nonatomic,strong)UILabel * labelOne;

@end

@implementation EvaluateDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    
    self.TitleLabel.text=@"评价管理详细";
    
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
    _datas=[NSMutableArray array];
    _yeIndex=1;
    
}
-(void)reshData{
    [self startAnimating:nil];


//    _pid=@"1";
    NSDictionary * dic=@{@"pid":[NSString stringWithFormat:@"%@",_pid],@"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
    [AnalyzeObject getRecomDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];
        
        if (_yeIndex==1) {
            if (_dataDic) {
                [_dataDic removeAllObjects];
            }
            
            if (_datas) {
                [_datas removeAllObjects];
            }
        }
        
        
        if ([ret isEqualToString:@"1"]) {
     
            
            [_dataDic addEntriesFromDictionary:model];
            [_datas addObjectsFromArray:_dataDic[@"comlist"]];
            
            
            
            if ([_dataDic[@"comlist"] count]==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            
            [self reshView];
        }else{
            [_tableView.mj_footer endRefreshing];
            [self showPromptBoxWithSting:msg];
        }
//        [_tableView.mj_footer endRefreshing];

    }];
    
}
-(void)reshView{
    [_headImg setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_dataDic[@"logo"]]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
    _labelName.text=[NSString stringWithFormat:@"名称:%@",_dataDic[@"pmame"]];
    _labelStander.text=[NSString stringWithFormat:@"规格:%@",_dataDic[@"guige"]];
    
    NSString * avgString=[NSString stringWithFormat:@"平均评分\n\n%@",_dataDic[@"avg"]];
    NSString * avgFor=@"平均评分";
    NSMutableAttributedString * attri1=[[NSMutableAttributedString alloc]initWithString:avgString];
    [attri1 addAttribute:NSForegroundColorAttributeName value:lightOrangeColor range:NSMakeRange(avgFor.length, avgString.length-avgFor.length)];
    [_btnLeft setAttributedTitle:attri1 forState:UIControlStateNormal];
    
    
    _labelFive.text=[NSString stringWithFormat:@"5星 ：%@ 个",_dataDic[@"five"]];
    _labelFour.text=[NSString stringWithFormat:@"4星 ：%@ 个",_dataDic[@"four"]];
    _labelThree.text=[NSString stringWithFormat:@"3星 ：%@ 个",_dataDic[@"three"]];
    _labelTwo.text=[NSString stringWithFormat:@"2星 ：%@ 个",_dataDic[@"two"]];
    _labelOne.text=[NSString stringWithFormat:@"1星 ：%@ 个",_dataDic[@"one"]];
    
    [_tableView reloadData];
    
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[EvaluateDetailCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    UIView * headView=[self newHeadView];
    _tableView.tableHeaderView=headView;
    _tableView.estimatedRowHeight=100;
    [_tableView addHeardTarget:self Action:@selector(xiaLa)];
    [_tableView addFooterTarget:self Action:@selector(shangLa)];
    
}

-(void)shangLa{
    _yeIndex++;
    [self reshData];
}
-(void)xiaLa{
    _yeIndex=1;
    [self reshData];
}
-(UIView *)newHeadView{
    UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, Vwidth, 100)];
    firstView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:firstView];
    
    
    
    UIImageView* imgView=[UIImageView new];
    imgView.layer.cornerRadius=5*self.scale;
    imgView.layer.masksToBounds=YES;
    imgView.layer.borderColor=blackLineColore.CGColor;
    imgView.layer.borderWidth=0.5;
    [firstView addSubview:imgView];
    imgView.frame=CGRectMake(10*self.scale, 10*self.scale, 70*self.scale, 70*self.scale);
    _headImg=imgView;
    
    UILabel* labelIntro=[UILabel new];
    labelIntro.numberOfLines=1;
    labelIntro.font=SmallFont(self.scale);
    labelIntro.textColor=blackTextColor;
    [firstView addSubview:labelIntro];
    labelIntro.frame=CGRectMake(imgView.right+10*self.scale, 5*self.scale, Vwidth-30*self.scale-imgView.width, 30*self.scale);
    labelIntro.text=@"名称:--";
    _labelName=labelIntro;
    
    UILabel * labelStandard=[UILabel new];
    labelStandard.numberOfLines=1;
    labelStandard.textColor=blackTextColor;
    labelStandard.font=SmallFont(self.scale);
    [firstView addSubview:labelStandard];
    labelStandard.frame=labelIntro.frame;
    labelStandard.bottom=imgView.bottom;
    labelStandard.text=@"规格:--";
    _labelStander=labelStandard;
    
    UIImageView * segmentLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, imgView.bottom+10*self.scale, firstView.width, 0.5)];
    segmentLine.backgroundColor=blackLineColore;
    [firstView addSubview:segmentLine];
    
    
    UIButton * meanGrade =[[UIButton alloc]initWithFrame:CGRectMake(0, segmentLine.bottom, Vwidth/3, Vwidth/3-20*self.scale)];
    meanGrade.titleLabel.numberOfLines=3;
    meanGrade.titleLabel.textAlignment=NSTextAlignmentCenter;
    meanGrade.titleLabel.font=DefaultFont(self.scale);
    [meanGrade setTitleColor:blackTextColor forState:UIControlStateNormal];
    [meanGrade setTitle:[NSString stringWithFormat:@"平均评分\n\n%.1f",4.2] forState:UIControlStateNormal];
    [firstView addSubview:meanGrade];
    _btnLeft=meanGrade;
    
    UIImageView * vLine = [[UIImageView alloc]initWithFrame:CGRectMake(meanGrade.right,segmentLine.top+ 5*self.scale, 0.5*self.scale, meanGrade.height-10*self.scale)];
    vLine.backgroundColor=blackLineColore;
    [firstView addSubview:vLine];
    
    
    UIView * gradeDetailView=[[UIView alloc]initWithFrame:CGRectMake(vLine.right+10*self.scale, segmentLine.bottom+10*self.scale, Vwidth*(2/3.0)-40*self.scale, 60*self.scale)];
    [firstView addSubview:gradeDetailView];
    gradeDetailView.center=CGPointMake(firstView.width*(2/3.0), meanGrade.centerY);
    
    for (int i = 0; i < 5; i ++) {
        CGFloat labelX=i / 3 * gradeDetailView.width/2;
        CGFloat labelY=i % 3 * gradeDetailView.height/3;
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, gradeDetailView.width/2, gradeDetailView.height/3)];
        [gradeDetailView addSubview:label];
        
        label.text=[NSString stringWithFormat:@"%d星 ：%d 个",5-i,10];
        label.font=SmallFont(self.scale);
        label.textColor=blackTextColor;
        
        if (i == 3 || i == 4) {
            label.textAlignment=NSTextAlignmentRight;
        }
        switch (i) {
            case 0:
                _labelFive=label;
                break;
            case 1:
                _labelFour=label;
                break;
            case 2:
                _labelThree=label;
                break;
            case 3:
                _labelTwo=label;
                break;
            case 4:
                _labelOne=label;
                break;
            default:
                break;
        }
    }
    
    firstView.height=meanGrade.bottom;
    return firstView;
    
}
#pragma  mark --  tableView delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluateDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic=_datas[indexPath.section];
    [cell.imgHead setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"ulogo"]]] placeholderImage:[UIImage imageNamed:@"hands_to"]];
    cell.labelName.text=[NSString stringWithFormat:@"%@",dic[@"uname"]];
    cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"Comment_date"]];
    cell.level=[[NSString stringWithFormat:@"%@",dic[@"comment_score"]] integerValue];
    cell.labelContent.text=[NSString stringWithFormat:@"%@",dic[@"comment_content"]];
    
    
    NSArray * imgs=[dic objectForKey:@"Logos"];
    BOOL isImage=imgs.count!=0;
    [cell layoutHeight:isImage];
    cell.imgs=imgs;
    
 
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1*self.scale;
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
