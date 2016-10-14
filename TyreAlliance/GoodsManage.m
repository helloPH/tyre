//
//  GoodsManage.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "GoodsManage.h"
#import "GoodsManageSingle.h"

@interface GoodsManage ()




@end

@implementation GoodsManage

- (void)viewDidLoad{
    [super viewDidLoad];
    [self newNavi];
    [self newView];

    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"商品管理";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)newView{

    NSArray * datas=@[@"上架商品管理",@"下架商品管理"];
    for (int i =0; i < datas.count;  i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+i*44*self.scale, Vwidth, 44*self.scale)];
        cellView.btn.tag=100+i;
        [cellView.btn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cellView];
        
        cellView.titleLabel.text=datas[i];
        cellView.titleLabel.textColor=blackTextColor;
        [cellView.titleLabel sizeToFit];
        
        [cellView ShowRight:YES];
    }
}
-(void)skip:(UIButton *)sender{
    GoodsManageSingle * goodsSingle=[GoodsManageSingle new];
    if (sender.tag==100) {
        goodsSingle.goodsType=1;
        
    }else{
        goodsSingle.goodsType=0;
        
    }
    [self.navigationController pushViewController:goodsSingle animated:YES];
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
