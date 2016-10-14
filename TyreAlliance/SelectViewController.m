//
//  SelectViewController.m
//  TyreAlliance
//
//  Created by wdx on 16/9/13.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()
@property (nonatomic,strong)NSMutableArray * datas;


@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSArray * titleLabels;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self initData];
//    [self newView];
    // Do any additional setup after loading the view.
}
-(void)initData{
    [self startAnimating:nil];
    _datas=[NSMutableArray array];
    if (_datas) {
        [_datas removeAllObjects];
    }
    
    if (_listType==ListTypeBrands) {
//          NSDictionary * dic =@{};
        [AnalyzeObject getBrandsListWithDic:nil WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                [_datas addObjectsFromArray:model];
            }else{
                [self showPromptBoxWithSting:msg];
            }
            [self newView];
        }];
        
    }else{
          NSDictionary * dic =@{};
        [AnalyzeObject getStanderListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
             [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                   [_datas addObjectsFromArray:model];
            }else{
                [self showPromptBoxWithSting:msg];
            }
            [self newView];
        }];
        
    }
}
-(void)newNavi{
    if (_listType==ListTypeBrands) {
    self.TitleLabel.text=@"品牌";
    }else{
    self.TitleLabel.text=@"规格";
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
-(void)newView{
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    NSInteger column =4;
    CGFloat btnW =Vwidth /6;
    CGFloat btnH =btnW +20*self.scale;
    CGFloat margin=20*self.scale;
    CGFloat spaceX=(Vwidth-btnW * column - 2 * margin)/3;
    CGFloat spaceY=spaceX;
    CGFloat setY=0;
    NSMutableArray * labels=[NSMutableArray array];
    if (labels) {
        [labels removeAllObjects];
    }
    for (int i =0; i < _datas.count; i ++) {
        CGFloat btnX= i % column * (btnW + spaceX) +margin;
        CGFloat btnY= i / column * (btnH + spaceY) +spaceY;
        
        
        UIButton * bgBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [_scrollView addSubview:bgBtn];
        bgBtn.tag=100+i;
        [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgBtn.width, bgBtn.width)];
        imgView.layer.cornerRadius=imgView.width/2;
        imgView.layer.masksToBounds=YES;
        imgView.image=[UIImage ImageForColor:[UIColor lightGrayColor]];
        imgView.userInteractionEnabled=YES;
        [bgBtn addSubview:imgView];
        imgView.image=[UIImage imageNamed:@"gui_ge"];
        imgView.userInteractionEnabled=NO;
        
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, bgBtn.width, bgBtn.height-imgView.height)];
        [labels addObject:title];
        title.font=DefaultFont(self.scale);
        title.textColor=blackTextColor;
        title.textAlignment=NSTextAlignmentCenter;
        title.text=@"--";
        title.tag=100;
        [bgBtn addSubview:title];
        
          NSDictionary * dic=_datas[i];
        if (_listType==ListTypeBrands) {
          
            
            [imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[dic valueForKey:@"P_logo"]]] placeholderImage:[UIImage imageNamed:@"gui_ge"]];
            title.text=[dic valueForKey:@"P_name"];
            if ([title.text isEqualToString:_selectedPara]) {
                title.textColor=navigationControllerColor;
            }
            
        }else{
           
            title.text=[NSString stringWithFormat:@"规格%d",i+1];
            
            UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, bgBtn.width, bgBtn.height-imgView.height)];
            label.font=Small10Font(self.scale);
            label.textColor=[UIColor whiteColor];
            label.textAlignment=NSTextAlignmentCenter;
            label.text=@"--";
            label.text=[dic valueForKey:@"G_name"];
            [bgBtn addSubview:label];
            label.center=imgView.center;
            if ([label.text isEqualToString:_selectedPara]) {
                title.textColor=navigationControllerColor;
            }
//            title.textColor=[UIColor whiteColor];
//            title.font=[UIFont systemFontOfSize:8*self.scale];
        }
        
      
        setY=bgBtn.bottom+spaceY;
    }
    _titleLabels=[NSArray arrayWithArray:labels];
    if (setY < Vheight-50*self.scale) {
        _scrollView.size=CGSizeMake(Vwidth, setY);
    }
    _scrollView.contentSize=CGSizeMake(_scrollView.width, setY);
    
    
    NSArray * btnTitles=@[@"确定",@"取消"];
    CGFloat bottonBtnH=44*self.scale;
    for (int i =0; i < 2;  i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(Vwidth/2 * i, Vheight-bottonBtnH, Vwidth/2, bottonBtnH)];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(commitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:blueTextColor forState:UIControlStateNormal];
        btn.titleLabel.font=DefaultFont(self.scale);
        btn.tag=100+i;
        if (i==0) {
            [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    
}


-(void)btnClick:(UIButton *)sender{
    for (UILabel * label in _titleLabels) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=blackTextColor;
        }
    }
    for (UILabel * label in sender.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            if (label.tag==100) {
                label.textColor=navigationControllerColor;
                
                if (_listType==ListTypeBrands) {
                _selectedPara=label.text;
                }
            }else{
                if (_listType==ListTypeStander) {
                    _selectedPara=label.text;
                }
            }
        }
    }
    
//    if (_callBack) {
//        _callBack(sender.tag-100);
//    }
}
-(void)commitOrCancel:(UIButton *)sender{
    if (sender.tag==100) {
        if (_callBack) {
            _callBack(_selectedPara);
        }
    }else{
        
    }

    [self PopVC:nil];
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
