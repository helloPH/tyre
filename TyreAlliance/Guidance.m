//
//  Guidance.m
//  TyreAlliance
//
//  Created by wdx on 16/9/30.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "Guidance.h"

@interface Guidance ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray * imgs;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIPageControl * pageControl;
@end

@implementation Guidance

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    _imgs=[NSMutableArray arrayWithArray:@[@"02",@"03",@"04"]];
    
}
-(void)newView{
    
    
    self.NavImg.height=0;
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vheight)];
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_scrollView];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 20*self.scale)];
    _pageControl.bottom=Vheight-15*self.scale;
    _pageControl.numberOfPages=_imgs.count;
    [self.view addSubview:_pageControl];
    
    
    
    CGFloat setX=0;
    for (int i =0; i < _imgs.count; i ++) {
        UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(i * Vwidth, 0, Vwidth, Vheight)];
        img.image=[UIImage imageNamed:_imgs[i]];
        img.userInteractionEnabled=YES;
        img.backgroundColor=superBackgroundColor;
        [_scrollView addSubview:img];
        
        
        if (i==_imgs.count-1) {
            img.userInteractionEnabled=YES;
            UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80*self.scale, 30*self.scale)];
            btn.layer.cornerRadius=btn.height/2;
            btn.layer.masksToBounds=YES;
            btn.layer.borderWidth=1*self.scale;
            btn.layer.borderColor=[UIColor whiteColor].CGColor;
            
            btn.center=CGPointMake(Vwidth/2, Vheight*0.69);
//            btn.backgroundColor=[UIColor redColor];
            [btn setTitle:@"进入应用" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

#pragma  mark  -- scroll delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage=scrollView.contentOffset.x/Vwidth;
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
