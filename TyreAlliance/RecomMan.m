//
//  RecomMan.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RecomMan.h"
#import "FriendOrderDetail.h"
#import "RecomManLevel1Cell.h"
#import "RecomManLevel2Cell.h"


@interface RecomMan ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSMutableArray * datas;

@property (nonatomic,strong)NSMutableDictionary * erjiDataDic;
@property (nonatomic,strong)NSMutableArray  * erjiDatas;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation RecomMan

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"推荐的人";
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
    _yeIndex=1;
    _contentType=ContentTypeLevel1;
    _datas=[NSMutableArray array];
    _erjiDataDic=[NSMutableDictionary dictionary];
    _erjiDatas=[NSMutableArray array];
    
}
-(void)reshData{

    
    
    [self startAnimating:nil];
    if (_contentType==ContentTypeLevel1) {
        NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                             @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
        [AnalyzeObject getLevel1RecommanWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if (_datas) {
                [_datas removeAllObjects];
            }
            
            if ([ret isEqualToString:@"1"]) {

                [_datas addObjectsFromArray:model];

                
                [_tableView reloadData];
            }else{
                [self showPromptBoxWithSting:msg];
            }
        }];
        
    }else{
        NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                             @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
        [AnalyzeObject getLevel2RecommanWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if ([ret isEqualToString:@"1"]) {
                if (_erjiDataDic) {
                    [_erjiDataDic removeAllObjects];
                }
                if (_erjiDatas) {
                    [_erjiDatas removeAllObjects];
                }
                [_erjiDataDic addEntriesFromDictionary:model];
                [_erjiDatas addObjectsFromArray:_erjiDataDic[@"each"]];
                
                [_tableView reloadData];
            }else{
                [self showPromptBoxWithSting:msg];
            }
        }];
        
    }
    
}

-(void)newView{
    UIView * selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 80*self.scale)];
    selectedView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:selectedView];
    NSArray * titles=@[@{@"title":@"一级推荐人",@"img":@"yiji_tuijianren"},@{@"title":@"二级推荐人",@"img":@"erji_tuijianren"}];
    
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i * Vwidth/2, 0, Vwidth/2, selectedView.height)];
         btn.tag=100+i;
        
        [selectedView addSubview:btn];
        if (i!=0) {
            UIView * segment = [[UIView alloc]initWithFrame:CGRectMake(0, 5*self.scale, 0.5*self.scale, selectedView.height-10*self.scale)];
            segment.backgroundColor=blackLineColore;
            [btn addSubview:segment];
        }
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10*self.scale, btn.height-40*self.scale, btn.height-40*self.scale)];
        imgView.image=[UIImage imageNamed:[titles[i] valueForKey:@"img"]];
        [btn addSubview:imgView];
       
        imgView.centerX=btn.width/2;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, 80*self.scale, 20*self.scale)];
        label.font=SmallFont(self.scale);
        label.textColor=blackTextColor;
        label.textAlignment=NSTextAlignmentCenter;
        [btn addSubview:label];
        label.text=[titles[i]valueForKey:@"title"];
        label.centerX=imgView.centerX;
        if (_contentType==ContentTypeLevel1 && i == 0) {
            btn.selected=YES;
            label.textColor=navigationControllerColor;
        }else if(_contentType==ContentTypeLevel2 && i == 1){
            btn.selected=YES;
            label.textColor=navigationControllerColor;
        }
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+selectedView.height+10*self.scale, Vwidth, Vheight-self.NavImg.height-selectedView.height-10*self.scale) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=superBackgroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    
    
    [_tableView registerClass:[RecomManLevel1Cell class] forCellReuseIdentifier:@"cell1"];
    [_tableView registerClass:[RecomManLevel2Cell class] forCellReuseIdentifier:@"cell2"];
    
    
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)selectBtn:(UIButton*)sender{
    _contentType=sender.tag-99;
    
    [self reshData];
    
   
    sender.selected=!sender.selected;
    for (UIButton * btn in sender.superview.subviews) {
        for (UILabel * label in btn.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                if (btn.tag==sender.tag) {
                    label.textColor=navigationControllerColor;
                }else{
                    label.textColor=blackTextColor;
                }
            }
        }
    }
}


#pragma  mark -- delegate datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_contentType==ContentTypeLevel1) {
        return _datas.count;
    }else{
        if (section==0) {
            return _erjiDatas.count;
        }else{
            return 0;
        }
        
//        return 3;
    }
    
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_contentType==ContentTypeLevel1) {
        return 1;
    }else{
        return 2;
    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_contentType==ContentTypeLevel1) {
        return 70*self.scale;
    }else{
        return 40*self.scale;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_contentType==ContentTypeLevel1) {
        RecomManLevel1Cell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        NSDictionary * dic=_datas[indexPath.row];
        [cell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"logo"]]] placeholderImage:[UIImage imageNamed:@"yiji_tuijianren"]];
        cell.labelName.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
        [cell.labelName sizeToFit];
        cell.labelPhone.text=[NSString stringWithFormat:@"联系方式:%@",dic[@"tel"]];
        [cell.labelPhone sizeToFit];
        cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"date"]];
        return  cell;
    }else{
        RecomManLevel2Cell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        NSDictionary * dic=_erjiDatas[indexPath.row];
        cell.labelName.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
        [cell.labelName sizeToFit];
        cell.recomCount.text=[NSString stringWithFormat:@"%@",dic[@"count"]];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_contentType==ContentTypeLevel1) {
        return 0.0001;
    }else{
        return 50*self.scale;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_contentType==ContentTypeLevel1) {
        return nil;
    }else{
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 50*self.scale)];
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel * labelName=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
        [view addSubview:labelName];
        labelName.centerY=25*self.scale;
        labelName.font=DefaultFont(self.scale);
        labelName.textColor=blackTextColor;
        
        
        
        
        UILabel * labelCount=[[UILabel alloc]initWithFrame:labelName.frame];
        [view addSubview:labelCount];
        labelCount.centerX=Vwidth-70*self.scale;
        labelCount.textAlignment=NSTextAlignmentCenter;
        labelCount.font=DefaultFont(self.scale);
        labelCount.textColor=blackTextColor;
        
        
        if (section==0) {
            labelName.text=@"一级推荐人";
            labelCount.text=@"推广人数";
        }else{
            labelName.text=@"二级推荐人总数";
            labelCount.text=[NSString stringWithFormat:@"%@",_erjiDataDic[@"allcount"]];
        }
        
        
        return view;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendOrderDetail * orderDeatail=[FriendOrderDetail new];
    NSDictionary * dic=_datas[indexPath.row];
    orderDeatail.dlid=[NSString stringWithFormat:@"%@",dic[@"id"]];
//    orderDeatail.dlid=@"11";
    orderDeatail.type=_contentType==ContentTypeLevel1?@"1":@"2";
    [self.navigationController pushViewController:orderDeatail animated:YES];
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
