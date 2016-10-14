//
//  Guidance.m
//  TyreAlliance
//
//  Created by wdx on 16/9/30.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "Guidance.h"

@interface Guidance ()
@property (nonatomic,strong)NSMutableArray * imgs;
@property (nonatomic,strong)UIScrollView * scrollView;
@end

@implementation Guidance

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    _imgs=[NSMutableArray arrayWithArray:@[@"",@"",@""]];
    
}
-(void)newView{
    
    
    self.NavImg.height=0;
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vheight)];
    _scrollView.pagingEnabled=YES;
    [self.view addSubview:_scrollView];
    

    CGFloat setX=0;
    for (int i =0; i < _imgs.count; i ++) {
        UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(i * Vwidth, 0, Vwidth, Vheight)];
        img.image=[UIImage imageNamed:_imgs[i]];
        img.userInteractionEnabled=YES;
        img.backgroundColor=superBackgroundColor;
        [_scrollView addSubview:img];
        
        
        if (i==_imgs.count-1) {
            img.userInteractionEnabled=YES;
            UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*self.scale, 30*self.scale)];
            btn.center=CGPointMake(Vwidth/2, Vheight-70*self.scale);
            btn.backgroundColor=[UIColor redColor];
            [img addSubview:btn];
            [btn addTarget:self action:@selector(exitGuide) forControlEvents:UIControlEventTouchUpInside];
            
        }
        setX=img.right;
    }
    _scrollView.contentSize=CGSizeMake(setX, Vheight);
    
}
-(void)exitGuide{
    [[Stockpile sharedStockpile] setIsSign:YES];
    [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootController];
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
