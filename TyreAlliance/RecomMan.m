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

@property (nonatomic,strong)UIImageView * btnEmpty1;
@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,assign)NSInteger countAll;


@property (nonatomic,strong)NSMutableDictionary * erjiDataDic;
@property (nonatomic,strong)NSMutableArray  * erjiDatas;
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)UILabel * lableCount;
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
    self.TitleLabel.text=@"我推荐的人";
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
    _countAll=0;
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
            if ([ret isEqualToString:@"1"]) {
//                if (_datas.count<=0) {
//                    [_datas removeAllObjects];
//                }
                if (_yeIndex==1) {
                    [_datas removeAllObjects];
                }
                
                
                [_datas addObjectsFromArray:model];
                if ([model count]==0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                }
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            [self reshView];
//             [_tableView reloadData];
                 [self showBtnEmpty1:_datas.count==0?YES:NO];
        }];
        
    }else{
        NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                             @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
        [AnalyzeObject getLevel2RecommanWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            [_tableView.mj_header endRefreshing];
            
            if ([ret isEqualToString:@"1"]) {
                if (_erjiDataDic) {
                    [_erjiDataDic removeAllObjects];
                }
                    [_erjiDataDic addEntriesFromDictionary:model];
                
               NSInteger count=[NSString stringWithFormat:@"%@",_erjiDataDic[@"allcount"]?_erjiDataDic[@"allcount"]:@"0"].integerValue;
                
                
         
                
                if (_yeIndex==1) {
                    _countAll=count;
                    if (_erjiDatas) {
                        [_erjiDatas removeAllObjects];
                    }
                    
                    
                }else{
                    _countAll=_countAll+count;
                }
      
                [_erjiDatas addObjectsFromArray:_erjiDataDic[@"each"]];
                
                if ([_erjiDataDic[@"each"] count]==0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                }
                
               
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            [self reshView];
//             [_tableView reloadData];
                 [self showBtnEmpty1:NO];
        }];
        
    }
    
}
-(void)reshView{
    if (_contentType==ContentTypeLevel1) {
        _tableView.height=Vheight-self.NavImg.height-90*self.scale;
        _bottomView.hidden=YES;
    }else{
        _tableView.height=Vheight-self.NavImg.height-90*self.scale-_bottomView.height-10*self.scale;
        _bottomView.hidden=NO;
        _lableCount.text=[NSString stringWithFormat:@"%d",_countAll];
    }
    
    [_tableView reloadData];

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
    
    
    
    UIView * view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 50*self.scale)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    view1.bottom=Vheight;
    UIView * bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    bottomLine.backgroundColor=blackLineColore;
    [view1 addSubview:bottomLine];
    
    _bottomView=view1;

    
    
    
    UILabel * labelName=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    [view1 addSubview:labelName];
    labelName.centerY=25*self.scale;
    labelName.font=DefaultFont(self.scale);
    labelName.textColor=blackTextColor;
    labelName.text=@"二级推荐人总数";

    UILabel * labelCount=[[UILabel alloc]initWithFrame:labelName.frame];
    [view1 addSubview:labelCount];
    labelCount.centerX=Vwidth-70*self.scale;
    labelCount.textAlignment=NSTextAlignmentCenter;
    labelCount.font=DefaultFont(self.scale);
    labelCount.textColor=blackTextColor;
    _lableCount=labelCount;
    
    
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
    _yeIndex=1;
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
//        return 1;
    }else{
//        return 2;
    }
        return 1;
  
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
        [cell.imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",dic[@"logo"]]]] placeholderImage:[UIImage imageNamed:@"people_hui"]];
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
        
  
        cell.labelPhone.text=[NSString stringWithFormat:@"%@",dic[@"tel"]];
        [cell.labelPhone sizeToFit];
       cell.labelPhone.left=cell.labelName.right+10*self.scale;
        
        
        cell.recomCount.text=[NSString stringWithFormat:@"%@",dic[@"count"]];
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_contentType==ContentTypeLevel1) {
        return 0.001*self.scale;
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
            labelCount.text=[NSString stringWithFormat:@"%@",_erjiDataDic[@"allcount"]?_erjiDataDic[@"allcount"]:@"0"];
        }
        
        
        return view;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_contentType==1) {
        FriendOrderDetail * orderDeatail=[FriendOrderDetail new];
        NSDictionary * dic=_datas[indexPath.row];
        orderDeatail.dlid=[NSString stringWithFormat:@"%@",dic[@"id"]];
        //    orderDeatail.dlid=@"11";
        orderDeatail.type=_contentType==ContentTypeLevel1?@"1":@"2";
        [self.navigationController pushViewController:orderDeatail animated:YES];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark -- dandu

-(void)showBtnEmpty1:(BOOL)show{
    if (show) {
        if (_btnEmpty1) {
            
        }else{
            _btnEmpty1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*self.scale, 100*self.scale)];
            _btnEmpty1.image=[UIImage imageNamed:@"noData"];
            _btnEmpty1.contentMode=UIViewContentModeScaleAspectFit;
            _btnEmpty1.center=CGPointMake(Vwidth/2, _tableView.tableHeaderView.height+ 100*self.scale);
            [self.tableView addSubview:_btnEmpty1];
            UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(0, _btnEmpty1.height+2*self.scale, _btnEmpty1.width, 20*self.scale)];
            lable.textColor=blackTextColor;
            lable.font=DefaultFont(self.scale);
            lable.textAlignment=NSTextAlignmentCenter;
            lable.text=@"暂无数据";
            [_btnEmpty1 addSubview:lable];
        }
        
    }else{
        if (_btnEmpty1) {
            
            [_btnEmpty1 removeFromSuperview];
            _btnEmpty1=nil;
        }
        
    }
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
