//
//  SettingCenter.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SettingCenter.h"
#import "HelpCenter.h"
#import "FeedBack.h"
#import "About.h"
#import "RelationService.h"
#import "CacheManager.h"
#import "UpDatePassWord.h"

#import "GuideViewViewController.h"

@interface SettingCenter ()
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)UILabel * labelCache;
@end

@implementation SettingCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"设置";
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
    
}
-(void)reshData{
    NSDictionary * dic=@{@"":@""};
    [AnalyzeObject getSetWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        if ([ret isEqualToString:@"1"]) {
            if (_dataDic) {
                [_dataDic removeAllObjects];
            }
            [_dataDic addEntriesFromDictionary:model];
            [self reshView];
        }else{
            [self showPromptBoxWithSting:msg];
        }
    }];
}
-(void)reshView{
//    _lableVer.textColor=navigationControllerColor;
//    _lableVer.text=[NSString stringWithFormat:@"V%@",_dataDic[@"Userversion"]];
    
    
}
-(void)newView{
    NSArray * titles=@[@"帮助中心",@"意见反馈",@"关于我们",@"联系客服",@"清除缓存",@"修改密码"];
    CGFloat setY=0;
    for (int i = 0; i < titles.count; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale + i * 40*self.scale, Vwidth, 40*self.scale)];
        [self.view addSubview:cellView];
        cellView.titleLabel.text=titles[i];
        [cellView ShowRight:YES];
        cellView.btn.tag=100+i;
        [cellView.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        setY=cellView.bottom;
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.right=cellView.RightImg.left-10*self.scale;
        label.centerY=cellView.RightImg.centerY;
        label.textColor=lightOrangeColor;
        label.textAlignment=NSTextAlignmentRight;
        label.font=DefaultFont(self.scale);
        [cellView addSubview:label];
        if (i==4) {
            label.text=[NSString stringWithFormat:@"%.2fM",[[CacheManager defaultCacheManager] GetCacheSize]];
            _labelCache=label;
        }
        if (i==5) {
//            _lableVer=label;
        }
       
        
        
    }
    
    UIButton * logoutbtn=[[UIButton alloc]initWithFrame:CGRectMake(20*self.scale, setY+20*self.scale, Vwidth-40*self.scale, 40*self.scale)];
    logoutbtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    [self.view addSubview:logoutbtn];
    logoutbtn.layer.cornerRadius=4;
    logoutbtn.layer.masksToBounds=YES;
    logoutbtn.titleLabel.font=BigFont(self.scale);
    [logoutbtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutbtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
    [logoutbtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    logoutbtn.tag=1000;
    
}
-(void)btnEvent:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{//帮助中心
            HelpCenter * help=[HelpCenter new];
            NSString * bodyString=[[NSString stringWithFormat:@"%@",_dataDic[@"help"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"help"]];

            help.textString=[NSString stringWithFormat:@"<!DOCTYPE><html><head></head><body>%@</body></html>",bodyString];
            [self.navigationController pushViewController:help animated:YES];
        
        }
            break;
            
        case 101:{//意见反馈
            [self.navigationController pushViewController:[FeedBack new] animated:YES];
        }
            break;
         
        case 102:{//关于我们
            About * about=[About new];
            NSString * aboutString=[[NSString stringWithFormat:@"%@",_dataDic[@"about"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"about"]];
            
            about.urlString=[NSString stringWithFormat:@"<!DOCTYPE><html><head></head><body>%@</body></html>",aboutString];
            [self.navigationController pushViewController:about animated:YES];
   
//            [self.navigationController pushViewController:[GuideViewViewController new] animated:YES];
            
        }
            break;
            
            
        case 103:{//联系客服
            
            RelationService * relation=[RelationService new];
            relation.telString=[[NSString stringWithFormat:@"%@",_dataDic[@"tel"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"tel"]] ;
            relation.qqString=[[NSString stringWithFormat:@"%@",_dataDic[@"qq"]]isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"qq"]];
            [self.navigationController pushViewController:relation animated:YES];
            
        }
            break;
        case 104:{//清除缓存
            [self ShowAlertTitle:@"提示" Message:@"确定要清除缓存？" Delegate:self Block:^(NSInteger index) {
                if (index==1) {
                    [[CacheManager defaultCacheManager]clearCache:^(BOOL success) {
                        [self showPromptBoxWithSting:@"已清空全部缓存!"];
                        _labelCache.text=[NSString stringWithFormat:@"%.2fM",[[CacheManager defaultCacheManager] GetCacheSize]];
                    }];
                }
            }];
            

        }
            break;
        case 105:{//修改密码
            
            UpDatePassWord * upDate=[UpDatePassWord new];
            [self.navigationController pushViewController:upDate animated:YES];
            
            
        }
            break;
        case 106:{
            
            
        }
            break;
        case 1000:{
            [self ShowAlertTitle:@"提示" Message:@"确定退出登录?" Delegate:self Block:^(NSInteger index) {
                if (index==1) {
                    [[Stockpile sharedStockpile] setAccount:@""];
                    [[Stockpile sharedStockpile] setID:@""];
                    [[Stockpile sharedStockpile] setName:@""];
                    [[Stockpile sharedStockpile] setLogo:@""];
                    [[Stockpile sharedStockpile] setIsLogin:NO];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate unRegistNoti];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootController];
                }
            }];
            
            

        }
            break;
            
        default:
            break;
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
