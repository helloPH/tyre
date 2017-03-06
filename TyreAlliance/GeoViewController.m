//
//  GeoViewController.m
//  TyreAlliance
//
//  Created by wdx on 16/10/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "GeoViewController.h"
#import "SuperTableViewCell.h"

@interface GeoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableDictionary * geoInfo;

@end

@implementation GeoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    
   
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"店铺地址";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
 
    if (_geoIndex==3) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
  
    }
    

}
-(void)initData{
    _geoInfo=[NSMutableDictionary dictionaryWithDictionary:@{@"province":@"",
                                                             @"city":@"",
                                                             @"county":@""}];
    _datas=[NSMutableArray array];
    _getMS=[NSMutableString string];
}
-(void)reshData{
    [_datas removeAllObjects];
    [self startAnimating:nil];
    switch (_geoIndex) {
        case 1:{
            
            
            NSDictionary * dic=@{};
            
            
            [AnalyzeObject getProvinceListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
//                    [_geoDatas addObjectsFromArray:model];
                    [_datas addObjectsFromArray:model];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
                [self reshView];
//                [self reshPickViewWithIndex:0];
                
            }];
        }
            break;
        case 2:{
            NSDictionary * dic=@{@"id":_geoId};
            [AnalyzeObject getCityListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
//                    [_geoDatas addObjectsFromArray:model];
                       [_datas addObjectsFromArray:model];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
                    [self reshView];
//                [self reshPickViewWithIndex:0];
            }];
            
        }
            break;
        case 3:{
            NSDictionary * dic=@{@"id":_geoId};
            [AnalyzeObject getCountyListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
//                    [_geoDatas addObjectsFromArray:model];
                       [_datas addObjectsFromArray:model];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
                 [self reshView];
//                [self reshPickViewWithIndex:0];
            }];
            
        }
    }
    
    

}
-(void)reshView{
    switch (_geoIndex) {
        case 1:
            self.TitleLabel.text=@"请选择省";
            break;
        case 2:
            self.TitleLabel.text=@"请选择市";
            break;
        case 3:
            self.TitleLabel.text=@"请选择区";
            break;
            
        default:
            break;
    }
    
    
    [_tableView reloadData];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SuperTableViewCell class] forCellReuseIdentifier:@"cell"];
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=superBackgroundColor;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
}

#pragma mark -- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  10*self.scale;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuperTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    
    NSDictionary * dic=_datas[indexPath.row];
    NSString * string;
    switch (_geoIndex) {
        case 1:
        
            string= [NSString stringWithFormat:@"%@",dic[@"Province_name"]];
            
            break;
        case 2:
            
            string= [NSString stringWithFormat:@"%@",dic[@"city_name"]];
            break;
        case 3:
            
            string= [NSString stringWithFormat:@"%@",dic[@"county_name"]];
            break;
        default:
            break;
    }
    cell.textLabel.text=string;
    
    return cell;
//    cell.textLabel.text=[NSString stringWithFormat:@""]
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic=_datas[indexPath.row];
    UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    [_getMS appendString:[NSString stringWithFormat:@"%@  ",cell.textLabel.text]];
   
    
    if (_geoIndex==3) {
        [_geoInfo setObject:[NSString stringWithFormat:@"%@",dic[@"county_name"]] forKey:@"county"];
        [self.navigationController popViewControllerAnimated:YES];
        if (_block) {
            _block(_getMS,_geoInfo);
        }
        
        
    }else{
        switch (_geoIndex) {
            case 1:
                _geoId=[NSString stringWithFormat:@"%@",dic[@"Province_id"]];
            [_geoInfo setObject:[NSString stringWithFormat:@"%@",dic[@"Province_name"]] forKey:@"province"];
                break;
            case 2:
                _geoId=[NSString stringWithFormat:@"%@",dic[@"city_id"]];
            [_geoInfo setObject:[NSString stringWithFormat:@"%@",dic[@"city_name"]] forKey:@"city"];
                break;
            default:
                break;
        }
         _geoIndex++;
         [self reshData];
    }
   
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
