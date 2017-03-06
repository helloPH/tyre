//
//  MessageCenter.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MessageCenter.h"
#import "MessageCenterNotiCell.h"
#import "MessageCenterFeedBackCell.h"

#import "MessageDeatail.h"
#import "FeedBackDeatil.h"


@interface MessageCenter ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation MessageCenter

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"消息中心";
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
    _datas=[NSMutableArray array];
    _messageType=0;
    
}
-(void)reshData{
    [self startAnimating:nil];
    if (_yeIndex==1) {
        [_datas removeAllObjects];
    }
    
    if (_messageType==MessageTypeNoti) {//消息通知
        NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                             @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
        [AnalyzeObject getPushMessageWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            [_tableView.mj_header endRefreshing];
            
            if ([ret isEqualToString:@"1"]) {
                [_datas addObjectsFromArray:model];
                if ([model count]==0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                }
//                [self showFailed:NO];
            }else{
//                [self showFailed:YES];
                [_tableView.mj_footer endRefreshing];
  
            }
                [self showBtnEmpty:_datas.count==0?YES:NO];
               [self reshView];
        }];
    }else{//售后反馈
        NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                             @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
        [AnalyzeObject getFeedBackWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            [_tableView.mj_header endRefreshing];
            
            if ([ret isEqualToString:@"1"]) {
                [_datas addObjectsFromArray:model];
                if ([model count]==0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                }
//                [self showFailed:NO];
            }else{
                [_tableView.mj_footer endRefreshing];
                if (_datas.count==0) {
//                    [self showFailed:YES];
                }
            }
            [self showBtnEmpty:_datas.count==0?YES:NO];
              [self reshView];
        }];
    }
    
    
}
-(void)reshView{
    [_tableView reloadData];
//    [self showBtnEmpty:_datas.count==0?YES:NO];
//    if (self.btnEmpty) {
//        self.btnEmpty.centerY=Vheight/2+(self.NavImg.height+80*self.scale)/2;
//    }
}
-(void)newView{
    UIView * selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 80*self.scale)];
    selectedView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:selectedView];
    NSArray * titles=@[@{@"title":@"消息通知",@"img":@"tongzhi_messge"},@{@"title":@"售后反馈",@"img":@"shouhou_fankui"}];
    
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
        if (_messageType==MessageTypeNoti && i == 0) {
            btn.selected=YES;
            label.textColor=navigationControllerColor;
        }else if(_messageType==MessageTypeBack && i == 1){
            btn.selected=YES;
            label.textColor=navigationControllerColor;
        }
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+selectedView.height+10*self.scale, Vwidth, Vheight-self.NavImg.height-selectedView.height-10*self.scale) style:UITableViewStylePlain];
    _tableView.backgroundColor=superBackgroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _tableView.estimatedRowHeight=50;
    [_tableView registerClass:[MessageCenterNotiCell class] forCellReuseIdentifier:@"cell1"];
    [_tableView registerClass:[MessageCenterFeedBackCell class] forCellReuseIdentifier:@"cell2"];
    
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)selectBtn:(UIButton*)sender{
    _messageType=sender.tag-100;
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
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 40*self.scale;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSDictionary * dic=_datas[indexPath.row];
     MessageCenterNotiCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (_messageType==MessageTypeNoti) {
//        MessageCenterNotiCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
//        cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"push_date"]];
        cell.labelContent.text=[NSString stringWithFormat:@"%@  %@",dic[@"push_date"],dic[@"push_title"]];
//        cell.labelContent.text=[NSString stringWithFormat:@"%@",@"用户订购了米其林R60规格轮胎请及时查收"];
        
        
        return  cell;
    }else{
//        MessageCenterFeedBackCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
//        cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"date"]];
//        [cell.labelTime sizeToFit];
        cell.labelContent.text=[NSString stringWithFormat:@"%@ %@",dic[@"date"],dic[@"reson"]];
        
        return cell;
    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_messageType==MessageTypeNoti) {
        MessageDeatail * messageDetail=[MessageDeatail new];
        NSDictionary * dic=_datas[indexPath.row];
        messageDetail.infoDic=dic;
        [self.navigationController pushViewController:messageDetail animated:YES];

    }else{
        NSDictionary * dic=_datas[indexPath.row];
        FeedBackDeatil  * feedBack=[FeedBackDeatil new];
        feedBack.fid=dic[@"id"];
        [self.navigationController pushViewController:feedBack animated:YES];
    }
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (_messageType==MessageTypeNoti) {
//        return 0.0001;
//    }else{
//        return 50*self.scale;
//    }
//    
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if (_messageType==MessageTypeNoti) {
//        return nil;
//    }else{
//        
//        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 50*self.scale)];
//        view.backgroundColor=[UIColor whiteColor];
//        
//        UILabel * labelName=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
//        [view addSubview:labelName];
//        labelName.centerY=25*self.scale;
//        labelName.font=DefaultFont(self.scale);
//        labelName.textColor=blackTextColor;
//        
//        
//        
//        
//        UILabel * labelCount=[[UILabel alloc]initWithFrame:labelName.frame];
//        [view addSubview:labelCount];
//        labelCount.centerX=Vwidth-70*self.scale;
//        labelCount.textAlignment=NSTextAlignmentCenter;
//        labelCount.font=DefaultFont(self.scale);
//        labelCount.textColor=blackTextColor;
//        
//        
//        if (section==0) {
//            labelName.text=@"一级推荐人";
//            labelCount.text=@"推广人数";
//        }else{
//            labelName.text=@"二级推荐人总数";
//            labelCount.text=[NSString stringWithFormat:@"%d",6];
//        }
//        
//        
//        return view;
//    }
//    
//}

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
