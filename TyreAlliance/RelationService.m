//
//  RelationService.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RelationService.h"


@interface RelationService ()

@end

@implementation RelationService

- (void)viewDidLoad {
    [super viewDidLoad];
//       _qqString=@"942261721";
    [self newNavi];
    [self newView];
 
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"联系客服";
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
    NSArray * titles=@[@{@"title":@"一键拨号",@"content":_telString,@"img":@"red_phone"},@{@"title":@"在线客服",@"content":@"",@"img":@"messgea_yellow"}];
    
    for (int i =0; i < titles.count; i ++) {
   
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale+i * 40*self.scale, Vwidth, 40*self.scale)];
        cellView.titleLabel.text=[titles[i] valueForKey:@"title"];
        cellView.RightImg.image=[UIImage imageNamed:[titles[i] valueForKey:@"img"]];
        [cellView ShowRight:YES];
        [self.view addSubview:cellView];
        
        
        cellView.content=[NSString stringWithFormat:@"%@",[titles[i] valueForKey:@"content"]];
        cellView.contentLabel.right=cellView.RightImg.left-10*self.scale;
        cellView.contentLabel.textAlignment=NSTextAlignmentRight;
        cellView.btn.tag=100+i;
        [cellView.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
}
-(void)btnEvent:(UIButton *)sender{
    if (sender.tag==100) {
//        [self openUrl:@"https://www.baidu.com"];
        [self makePhoneWithTel:_telString];
    }else{
      [self openUrl:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",_qqString]];
//        mqq://im/chat?chat_type=wpa&uin=942261721&version=1&src_type=web
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
