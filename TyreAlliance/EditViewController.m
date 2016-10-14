//
//  EditViewController.m
//  TyreAlliance
//
//  Created by wdx on 16/9/13.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EditViewController.h"
#import "SelectViewController.h"


@interface EditViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,assign)BOOL isSubmit;
@property (nonatomic,strong) UILabel * labelMark;
@property (nonatomic,strong)UIPageControl * pageControl;


@property (nonatomic,strong) NSMutableArray * imgS;
@property (nonatomic,strong) NSMutableDictionary * dataDic;

@property (nonatomic,strong)UIScrollView * headScroll;
@property (nonatomic,strong)UITextField *  tfYj;
@property (nonatomic,strong)UITextField *  tfXj;
@property (nonatomic,strong)UILabel *  labBrands;
@property (nonatomic,strong)UILabel *  labStander;
@property (nonatomic,strong)UITextField *  tfSort;

@property (nonatomic,strong)UIButton * btnSubmit;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{

    self.TitleLabel.text=@"编辑";

    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
        [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (_callBack) {
        _callBack(_isSubmit);
    };
}

-(void)initData{
    _isSubmit=NO;
    _dataDic=[NSMutableDictionary dictionary];
//    _imgS=[NSMutableArray arrayWithArray:@[@""]];
}
-(void)reshData{
    [self startAnimating:nil];
    
    NSDictionary * dic=@{@"pid":_pid};
    if (_dataDic) {
         [_dataDic removeAllObjects];
    }

  [AnalyzeObject showProductDatasWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
      [self stopAnimating];
      if ([ret isEqualToString:@"1"]) {
          [_dataDic addEntriesFromDictionary:model];
          [self reshView];
      }else{
          
      }
  }];
}
-(void)reshView{
    _imgS=_dataDic[@"Logos"];
    _pageControl.numberOfPages=_imgS.count;
    _labelMark.text=[NSString stringWithFormat:@"1/%d",_imgS.count];
    [_headScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat setX=0;
    for (int i =0;  i < _imgS.count; i ++) {
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(i * _headScroll.width, 0, _headScroll.width, _headScroll.height)];
        imgView.image=[UIImage ImageForColor:[UIColor lightGrayColor]];
        imgView.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imgS[i]]]];
        imgView.image=[UIImage imageNamed:@"luntai_tai"];
        [_headScroll addSubview:imgView];
        setX=imgView.right;
    }
    _headScroll.contentSize=CGSizeMake(setX, _headScroll.height);

   
    _tfYj.text= [NSString stringWithFormat:@"%@",_dataDic[@"OldPrice"]];
    _tfXj.text= [NSString stringWithFormat:@"%@",_dataDic[@"NewPrice"]];
    _labBrands.text= [NSString stringWithFormat:@"%@",_dataDic[@"Pinpai"]];
    _labStander.text= [NSString stringWithFormat:@"%@",_dataDic[@"Guige"]];
    _tfSort.text= [NSString stringWithFormat:@"%@",_dataDic[@"sort"]];
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vwidth*3/7.0)];
    headView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:headView];
    
    UIScrollView * headScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10*self.scale, 90, 90)];
    headScroll.pagingEnabled=YES;
    headScroll.delegate=self;
    headScroll.centerX=headView.width/2;
//    headScroll.backgroundColor=[UIColor redColor];
    [headView addSubview:headScroll];
    _headScroll=headScroll;
    
    CGFloat setX=0;
    for (int i =0;  i < _imgS.count; i ++) {
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(i * headScroll.width, 0, headScroll.width, headScroll.height)];
        imgView.image=[UIImage ImageForColor:[UIColor lightGrayColor]];
        
        imgView.image=[UIImage imageNamed:@"luntai_tai"];
        [headScroll addSubview:imgView];
        setX=imgView.right;

        
    }
    headScroll.contentSize=CGSizeMake(setX, headScroll.height);
    
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, headScroll.bottom+10*self.scale, headScroll.width, 20*self.scale)];
    _pageControl.numberOfPages=_imgS.count;
    _pageControl.centerX=headScroll.centerX;
    _pageControl.pageIndicatorTintColor= [UIColor colorWithRed:57/255.0 green:99/255.0 blue:197/255.0 alpha:0.6];
    _pageControl.currentPageIndicatorTintColor=navigationControllerColor;
//    pageControll.backgroundColor=[UIColor redColor];
    _pageControl.currentPage=0;
    [headView addSubview:_pageControl];
    
    
    _labelMark =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30*self.scale, 30*self.scale)];
    _labelMark.text=[NSString stringWithFormat:@"%d/%lu",1,(unsigned long)_imgS.count];
    [headView addSubview:_labelMark];
    _labelMark.layer.cornerRadius=_labelMark.width/2;
    _labelMark.layer.masksToBounds=YES;
    _labelMark.backgroundColor=[UIColor lightGrayColor];
    _labelMark.textColor=[UIColor whiteColor];
    _labelMark.textAlignment=NSTextAlignmentCenter;
    _labelMark.right=headView.width-20*self.scale;
    _labelMark.bottom=headView.height-15*self.scale;
    
    

    
    
    NSArray * titles=@[@"原价:",@"现价:",@"品牌:",@"规格:",@"排序索引:"];
    CGFloat setY=0;
    CGFloat cellH=40*self.scale;
    
    for (int i =0; i < titles.count; i ++) {
        
        CellView * cellView =[[CellView alloc]initWithFrame:CGRectMake(0, headView.bottom + 10*self.scale +  i * cellH, Vwidth, cellH)];
        cellView.titleLabel.text=titles[i];
        [cellView.titleLabel sizeToFit];
        [_scrollView addSubview:cellView];
        cellView.btn.tag=100+i;
        
        UITextField * textField =[[UITextField alloc]initWithFrame:CGRectMake(cellView.titleLabel.right+10*self.scale, cellView.titleLabel.top, Vwidth/2, 15*self.scale)];
        textField.font=SmallFont(self.scale);
        textField.textColor=blackTextColor;
        textField.centerY=cellView.titleLabel.centerY;
        
        if (i == 0 || i == 1) {
          [cellView addSubview:textField];
            textField.keyboardType=UIKeyboardTypeNumberPad;
            textField.placeholder=@"请输入价格";
        }
        if (i == 4) {
            [cellView addSubview:textField];
            textField.placeholder=@"请输入排序索引";
        }
        
          UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*self.scale, 20*self.scale)];
        if (i == 2 || i == 3) {
            [cellView ShowRight:YES];
            label.right=cellView.RightImg.left-10*self.scale;
            label.centerY=cellView.titleLabel.centerY;
            label.font=DefaultFont(self.scale);
            label.textColor=blackTextColor;
            label.textAlignment=NSTextAlignmentRight;
            [cellView addSubview:label];
            

         
            [cellView.btn addTarget:self action:@selector(cellViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        }

        setY=cellView.bottom;
        
        switch (i) {
            case 0:
                _tfYj=textField;
                break;
            case 1:
                _tfXj=textField;
                break;
            case 2:
                _labBrands=label;
                break;
            case 3:
                _labStander=label;
                break;
            case 4:
                _tfSort=textField;
                break;
            default:
                break;
        }
    }

    UIButton * commitBtn=[[UIButton alloc]initWithFrame:CGRectMake(15*self.scale, setY+10*self.scale, Vwidth-30*self.scale, 40*self.scale)];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font=BigFont(self.scale);
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.layer.cornerRadius=2;
    commitBtn.layer.masksToBounds=YES;
    [commitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    setY=commitBtn.bottom+10*self.scale;
    _scrollView.contentSize=CGSizeMake(Vwidth, setY);
    _btnSubmit=commitBtn;
    [_scrollView addSubview:commitBtn];
    
}
-(void)submitBtn:(UIButton *)sender{
    [self startAnimating:@"正在提交"];
    _pid=@"1";
    NSDictionary * dic=@{@"pid":_pid,
                         @"oldprice":_tfYj.text,
                         @"newprice":_tfXj.text,
                         @"guige":_labStander.text,
                         @"pinpai":_labBrands.text,
                         @"sort":_tfSort.text
                         };
    [AnalyzeObject submitEditProductDatasWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            _isSubmit=YES;
//            [self showPromptBoxWithSting:@"修改成功"];
        }else{
    
        }
                [self showPromptBoxWithSting:msg];
    }];
    
}
-(void)cellViewBtn:(UIButton *)sender{

    SelectViewController * selectVC=[SelectViewController new];
    if (sender.tag==102) {
        selectVC.listType=ListTypeBrands;
        selectVC.selectedPara=_labBrands.text;
        selectVC.callBack=^(NSString * para){
            _labBrands.text=para;
        };
    }
    if (sender.tag==103) {
        selectVC.listType=ListTypeStander;
        selectVC.selectedPara=_labStander.text;
        selectVC.callBack=^(NSString * para){
            _labStander.text=para;
        };
    }
    [self.navigationController pushViewController:selectVC animated:YES];
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   int page= (scrollView.contentOffset.x)/(scrollView.frame.size.width);
    _labelMark.text=[NSString stringWithFormat:@"%d/%lu",page+1,(unsigned long)_imgS.count];
    _pageControl.currentPage=page;
    
//    NSLog(@"%d",page);
    
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
