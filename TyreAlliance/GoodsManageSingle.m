//
//  GoodsManageSingle.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "GoodsManageSingle.h"
#import "GoodsDetailCell.h"
#import "DefaultPageSource.h"
#import "EditViewController.h"
@interface GoodsManageSingle ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UITextField * searchTf;
@end

@implementation GoodsManageSingle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    
//     Do any additional setup after loading the view.
}

-(void)newNavi{
    if (_goodsType==GoodsTypeShang) {
        self.TitleLabel.text=@"上架商品管理";
    }else{
        self.TitleLabel.text=@"下架商品管理";

    }
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
    _index=1;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    [self startAnimating:nil];
    NSString * type=_goodsType==GoodsTypeShang?@"1":@"0";
    NSString * key=_searchTf.text;
    NSDictionary * dic;
    
    if ([key isEqualToString:@""]) {
        dic=[NSMutableDictionary dictionaryWithDictionary:@{@"uid":[Stockpile sharedStockpile].ID,
                                                            @"type":type,
                                                            @"ye":[NSString stringWithFormat:@"%d",_index]
                                                            }];
    }else{
        dic=[NSMutableDictionary dictionaryWithDictionary:@{@"uid":[Stockpile sharedStockpile].ID,
                                                            @"type":type,
                                                            @"ye":[NSString stringWithFormat:@"%d",_index],
                                                            @"key":key
                                                            }];
    }
    
//   dic=[NSMutableDictionary dictionaryWithDictionary:@{@"uid":[Stockpile sharedStockpile].ID,
//                                                                              @"type":type,
//                                                                              @"ye":[NSString stringWithFormat:@"%d",_index]
//                                                                              }];
    [AnalyzeObject getProductDatasWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];
        
        
        if ([model count]==0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        

        if (_index==1) {
            [_datas removeAllObjects];
        }
        if ([ret isEqualToString:@"1"]){

            NSArray * datas=(NSArray *)model;
            [_datas addObjectsFromArray:datas];
        }else{
            [self showPromptBoxWithSting:msg];
        }
          [_tableView reloadData];
//         [_datas arrayByAddingObjectsFromArray:datas];
        


    
        
    }];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height-self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView addHeardTarget:self Action:@selector(xiala:)];
    [_tableView addFooterTarget:self Action:@selector(shangla:)];
    
    
    [_tableView registerClass:[GoodsDetailCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headView"];
    
    _tableView.tableHeaderView.height=44*self.scale;
    _tableView.tableHeaderView=[self searchView];
    
    [self.view addSubview:_tableView];
}
-(void)xiala:(UIButton *)sender{
    _index=1;
    [self reshData];
}
-(void)shangla:(UIButton *)sender{
    _index++;
    [self reshData];
    
}
-(UIView *)searchView{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 40*self.scale)];
    UIImageView * bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vwidth*2/3.0, view.height-15*self.scale)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.userInteractionEnabled=YES;
    
    [view addSubview:bgView];
    bgView.center=view.center;
    bgView.layer.cornerRadius=3;
    bgView.layer.masksToBounds=YES;
    bgView.layer.borderColor=blackLineColore.CGColor;
    bgView.layer.borderWidth=1;
    
    
    
    UIImageView * leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, bgView.height-5*self.scale, bgView.height-5*self.scale)];

    leftImg.image=[UIImage imageNamed:@"fangda"];
    leftImg.contentMode=UIViewContentModeCenter;
    [bgView addSubview:leftImg];
    leftImg.centerY=bgView.height/2;
    
    UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(leftImg.right+5*self.scale, 5*self.scale, bgView.width-15*self.scale-leftImg.width, bgView.height-10*self.scale)];
    [bgView addSubview:field];
    field.centerY=leftImg.centerY;
    field.font=Small10Font(self.scale);
    field.placeholder=@"请输入您要查找的商品";
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    field.keyboardType=UIKeyboardTypeAlphabet;
    field.delegate=self;
    _searchTf=field;
    return view;
    
}

#pragma mark -- tableview delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_goodsType==GoodsTypeShang) {
        [cell.btnAction setTitle:@"下架" forState:UIControlStateNormal];
    }else{
        [cell.btnAction setTitle:@"上架" forState:UIControlStateNormal];
    }
    
    NSDictionary * proDic=_datas[indexPath.section];
    cell.labelIntro.text=[NSString stringWithFormat:@"%@",proDic[@"P_name"]];
    [cell.imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",proDic[@"P_Logo"]]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
    
    
    

//    cell.labelPrice.text=[NSString stringWithFormat:@"￥%@ 原价:￥%@",proDic[@"P_NewPrice"],proDic[@"P_OldPrice"]];
    NSString * xian=[NSString stringWithFormat:@"￥%@  ",proDic[@"P_NewPrice"]];
    NSString * yuan=[NSString stringWithFormat:@"原价￥%@",proDic[@"P_OldPrice"]];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithString:xian];
    [att appendAttributedString:[yuan getDeleteLineText]];
    

    cell.labelPrice.attributedText=att;
    
    cell.labelStandard.text=[NSString stringWithFormat:@"规格：%@",proDic[@"P_GuiGe"]];
    cell.indexPath=indexPath;
    cell.delegate=self;
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CellView * view=[[CellView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 30*self.scale)];
    view.bottomline.hidden=NO;
    view.backgroundColor=[UIColor whiteColor];
    NSDictionary * dic=_datas[section];
    
//
    UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, 60, 20*self.scale)];
    labelTitle.font=SmallFont(self.scale);
    labelTitle.textColor=blackTextColor;
    labelTitle.centerY=view.height/2;
    [view addSubview:labelTitle];
    labelTitle.text=[NSString stringWithFormat:@"%@",dic[@"bname"]];
//    labelTitle.text=@"郑州米其林轮胎专卖";
       [labelTitle sizeToFit];
    
    
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(labelTitle.right+10*self.scale, labelTitle.top, 50*self.scale, labelTitle.height)];
    [imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",dic[@"logo"]]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
//    imgView.image=[UIImage imageNamed:@"logo_dingbu"];
    [view addSubview:imgView];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120*self.scale;
}

#pragma  mark -- cellDelegate
-(void)actionWithIndexPath:(NSIndexPath *)indexPath{
    [self ShowAlertTitle:@"确定要进行此操作？" Message:nil Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            
            NSString * pid=((NSDictionary *)(_datas[indexPath.section]))[@"P_id"];
            NSString * type=_goodsType==GoodsTypeShang?@"0":@"1";
            
            NSDictionary * dic=@{@"pid":pid,@"type":type};
            [AnalyzeObject upOrDownProductDatasWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                if ([ret isEqualToString:@"1"]) {
                    [self showPromptBoxWithSting:@"操作成功"];
                    [self reshData];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
              
            }];
            
            
//            [self ShowAlertWithMessage:@"已成功！"];
            
        }
        
    }];
}
-(void)editWithIndexPath:(NSIndexPath *)indexPath{
    EditViewController * editViewController=[EditViewController new];
    editViewController.callBack=^(BOOL isSubmit){
        if (isSubmit) {
            [self reshData];
        }
    };
    NSString * pid=((NSDictionary *)(_datas[indexPath.section]))[@"P_id"];
    editViewController.pid=pid;
    [self.navigationController pushViewController:editViewController animated:YES];
}
#pragma  mard  uitextfeild delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _index=1;
    [self reshData];
    [textField resignFirstResponder];
    return  YES;
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
