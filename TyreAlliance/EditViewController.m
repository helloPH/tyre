//
//  EditViewController.m
//  TyreAlliance
//
//  Created by wdx on 16/9/13.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EditViewController.h"
#import "SelectViewController.h"
#import "ZLPickerBrowserViewController.h"

@interface EditViewController ()<UIScrollViewDelegate,ZLPickerBrowserViewControllerDelegate,ZLPickerBrowserViewControllerDataSource
,UITextFieldDelegate>
@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,assign)BOOL isSubmit;
@property (nonatomic,strong) UILabel * labelMark;
@property (nonatomic,strong)UIPageControl * pageControl;


@property (nonatomic,strong) NSMutableArray * imgS;
@property (nonatomic,strong) NSMutableDictionary * dataDic;

@property (nonatomic,strong)UIScrollView * headScroll;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger wholeIndex;

@property (nonatomic,strong)UITextField *  tfYj;
@property (nonatomic,strong)UITextField *  tfXj;
@property (nonatomic,strong)UILabel *  labBrands;
@property (nonatomic,strong)UILabel *  labStander;
@property (nonatomic,strong)UITextField *  tfKucun;
@property (nonatomic,strong)UITextField *  tfSort;

@property (nonatomic,strong)UIButton * btnSubmit;

@property (nonatomic,strong)NSString * sId;
@property (nonatomic,strong)NSString * bId;

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
    _sId=@"1";
    _bId=@"1";
    _wholeIndex=0;
    
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
            _bId=[NSString stringWithFormat:@"%@",_dataDic[@"Pinpaiid"]];
            _sId=[NSString stringWithFormat:@"%@",_dataDic[@"Guigeid"]];
            
            [self reshView];
        }else{
            
        }
    }];
}
-(void)reshView{
    [self reshWholeScroll];
    _tfYj.text= [NSString stringWithFormat:@"%@",_dataDic[@"OldPrice"]];
    _tfXj.text= [NSString stringWithFormat:@"%@",_dataDic[@"NewPrice"]];
    _labBrands.text= [NSString stringWithFormat:@"%@",_dataDic[@"Pinpai"]];
    _labStander.text= [NSString stringWithFormat:@"%@",_dataDic[@"Guige"]];
    _tfKucun.text=[NSString stringWithFormat:@"%@",_dataDic[@"kucun"]];
    _tfSort.text= [NSString stringWithFormat:@"%@",_dataDic[@"sort"]];
}
-(void)reshWholeScroll{
    _imgS=_dataDic[@"Logos"];
    _pageControl.numberOfPages=_imgS.count;
    _labelMark.text=[NSString stringWithFormat:@"%ld/%lu",_wholeIndex+1,(unsigned long)_imgS.count];
    
    for (UIImageView * imgView in _headScroll.subviews) {
        
        NSInteger index=_wholeIndex;
        switch (imgView.tag-100) {
            case 0:{
                index-=1;
                if (index<0) {
                    index=_imgS.count-1;
                }
                [imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_imgS[index]]]] placeholderImage:[UIImage imageNamed:@"noData"]];
                
            }
                break;
            case 1:{//中间页应显示的图片
                if (index<0) {
                    index=0;
                }
                if (index>_imgS.count-1) {
                    index=_imgS.count-1;
                }
                [imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_imgS[index]]]] placeholderImage:[UIImage imageNamed:@"noData"]];
                
                
            }
                break;
            case 2:{
                index+=1;
                if (index>_imgS.count-1) {
                    index=0;
                }
                [imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_imgS[index]]]] placeholderImage:[UIImage imageNamed:@"noData"]];
                
                
            }
                break;
            default:
                break;
        }
        
    }
    
    
    
    //    _headScroll.contentSize=CGSizeMake(setX, _headScroll.height);
    
}
-(void)scrollWhole{
    
    [UIView animateWithDuration:0.6 animations:^{
        _headScroll.contentOffset=CGPointMake(_headScroll.contentOffset.x+_headScroll.width, 0);
    }completion:^(BOOL finished) {
        int page= (_headScroll.contentOffset.x)/(_headScroll.frame.size.width);
        //        _labelMark.text=[NSString stringWithFormat:@"%ld/%lu",_wholeIndex+1,(unsigned long)_imgS.count];
        if (page==2) {//向后翻
            _wholeIndex++;
            if (_wholeIndex>_imgS.count-1) {
                _wholeIndex=0;
            }
            [self reshWholeScroll];
            
        }
        if (page==0) {//向前翻
            _wholeIndex--;
            if (_wholeIndex<0) {
                _wholeIndex=_imgS.count-1;
            }
            [self reshWholeScroll];
        }
        if (_wholeIndex==_pageControl.currentPage) {//没动
            
        }
        _pageControl.currentPage=_wholeIndex;
        _headScroll.contentOffset=CGPointMake(_headScroll.width, 0);
    }];
    
    
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _scrollView.tag=100;
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];
    [_scrollView addGestureRecognizer:tap];
    _timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollWhole) userInfo:nil repeats:YES];
    
    
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vwidth*3/7.0)];
    headView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:headView];
    _headScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, headView.width, headView.height)];
    _headScroll.showsHorizontalScrollIndicator=NO;
    _headScroll.pagingEnabled=YES;
    _headScroll.delegate=self;
    _headScroll.centerX=headView.width/2;
    _headScroll.contentSize=CGSizeMake(_headScroll.width*3, _headScroll.height);
    [headView addSubview:_headScroll];
    
    _headScroll.contentOffset=CGPointMake(_headScroll.width, 0);
    _headScroll.tag=101;
    for (int i =0;  i < 3; i ++) {
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(i * _headScroll.width, 0*self.scale, _headScroll.width, _headScroll.height-0*self.scale)];
        imgView.tag=100+i;
        //        if (i==1) {
        //            imgView.backgroundColor=[UIColor redColor];
        //        }
        //
        imgView.layer.masksToBounds=YES;
        imgView.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * press=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [imgView addGestureRecognizer:press];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToBrower:)];
        [imgView addGestureRecognizer:tap];
        [_headScroll addSubview:imgView];
    }
    
    
    
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, headView.height+10*self.scale, Vwidth, 20*self.scale)];
    _pageControl.numberOfPages=_imgS.count;
    _pageControl.centerX=Vwidth/2;
    _pageControl.bottom=headView.height;
    _pageControl.pageIndicatorTintColor= [UIColor colorWithRed:57/255.0 green:99/255.0 blue:197/255.0 alpha:0.6];
    _pageControl.currentPageIndicatorTintColor=navigationControllerColor;
    //    pageControll.backgroundColor=[UIColor redColor];
    _pageControl.currentPage=_wholeIndex;
    [headView addSubview:_pageControl];
    
    
    _labelMark =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30*self.scale, 30*self.scale)];
    _labelMark.text=[NSString stringWithFormat:@"%d/%lu",1,(unsigned long)_imgS.count];
    [headView addSubview:_labelMark];
    _labelMark.layer.cornerRadius=_labelMark.width/2;
    _labelMark.layer.masksToBounds=YES;
    _labelMark.backgroundColor=[UIColor lightGrayColor];
    _labelMark.textColor=[UIColor whiteColor];
    _labelMark.textAlignment=NSTextAlignmentCenter;
    _labelMark.font=SmallFont(self.scale);
    _labelMark.right=headView.width-20*self.scale;
    _labelMark.bottom=headView.height-15*self.scale;
    
    
    
    
    
    NSArray * titles=@[@"原价:",@"现价:",@"品牌:",@"规格:",@"库存:",@"排序:"];
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
        textField.keyboardType=UIKeyboardTypeDecimalPad;
        textField.tag=100+i;
        textField.delegate=self;
        if (i == 0 || i == 1) {
            [cellView addSubview:textField];
            textField.keyboardType=UIKeyboardTypeDecimalPad;
            textField.placeholder=@"请输入价格";
        }
        if (i==4 || i==5) {
            textField.keyboardType=UIKeyboardTypeNumberPad;
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
                [cellView addSubview:textField];
                textField.placeholder=@"请输入库存数量";
                _tfKucun=textField;
                [textField limitText:@8];
                break;
            case 5:{
                
                
                _tfSort=textField;
                [textField limitText:@4];
                [cellView addSubview:textField];
                textField.placeholder=@"请输入排序";
                
                UILabel * labelTip=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
                labelTip.centerY=cellView.height/2;
                labelTip.textColor=grayTextColor;
                labelTip.font=BoldSmall11Font(self.scale);
                labelTip.textAlignment=NSTextAlignmentRight;
                labelTip.text=@"*数字越小越靠前";
                [labelTip sizeToFit];
                labelTip.right=Vwidth-10*self.scale;
                [cellView addSubview:labelTip];
            }
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
    
    if ([_tfYj.text isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入原价"];
        return;
    }
    if (![_tfYj.text isValidateMoneyed]) {
        [self ShowAlertWithMessage:@"请输入正确的原价"];
        return;
    }
    
    if ([_tfXj.text isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入现价"];
        return;
    }
    
    if (![_tfXj.text isValidateMoneyed]) {
        [self ShowAlertWithMessage:@"请输入正确的现价"];
        return;
    }
    
    
    
    if ([_labBrands.text isEmptyString]||[_labBrands.text isEqualToString:@"未知"]) {
        [self ShowAlertWithMessage:@"请选择品牌"];
        return;
    }
    if ([_labStander.text isEmptyString]||[_labStander.text isEqualToString:@"未知"]) {
        [self ShowAlertWithMessage:@"请选择规格"];
        return;
    }
    if ([_tfKucun.text isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入库存数量"];
        return;
    }
    if ([_tfSort.text isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入排序"];
        return;
    }
    
    
    if ([[NSString stringWithFormat:@"%@",_dataDic[@"OldPrice"]]isEqualToString:_tfYj.text]
        &&[[NSString stringWithFormat:@"%@",_dataDic[@"NewPrice"]]isEqualToString:_tfXj.text]
        &&[[NSString stringWithFormat:@"%@",_dataDic[@"Pinpaiid"]]isEqualToString:_bId]
        &&[[NSString stringWithFormat:@"%@",_dataDic[@"Guigeid"]]isEqualToString:_sId]
        &&[[NSString stringWithFormat:@"%@",_dataDic[@"kucun"]]isEqualToString:_tfKucun.text]
        &&[[NSString stringWithFormat:@"%@",_dataDic[@"sort"]]isEqualToString:_tfSort.text]
        ) {
        
        [self ShowAlertWithMessage:@"您还未做任何修改"];
        return;
        
        
    }
    
    
    
    [self startAnimating:@"正在提交"];
    //    _pid=@"1";
    NSDictionary * dic=@{@"pid":_pid,
                         @"oldprice":_tfYj.text,
                         @"newprice":_tfXj.text,
                         @"guige":_sId,
                         @"pinpai":_bId,
                         @"kucun":_tfKucun.text,
                         @"sort":_tfSort.text
                         };
    [AnalyzeObject submitEditProductDatasWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            [self reshData];
            _isSubmit=YES;
            [self PopVC:nil];
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
        selectVC.callBack=^(NSString * para,NSString * index){
            _labBrands.text=para;
            _bId=index;
        };
    }
    if (sender.tag==103) {
        selectVC.listType=ListTypeStander;
        selectVC.selectedPara=_labStander.text;
        selectVC.callBack=^(NSString * para,NSString * index){
            _labStander.text=para;
            _sId=index;
            
        };
    }
    [self.navigationController pushViewController:selectVC animated:YES];
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag==101) {
        int page= (scrollView.contentOffset.x)/(scrollView.frame.size.width);
        //        _labelMark.text=[NSString stringWithFormat:@"%ld/%lu",_wholeIndex+1,(unsigned long)_imgS.count];
        if (page==2) {//向后翻
            _wholeIndex++;
            if (_wholeIndex>_imgS.count-1) {
                _wholeIndex=0;
            }
            [self reshWholeScroll];
            
        }
        if (page==0) {//向前翻
            _wholeIndex--;
            if (_wholeIndex<0) {
                _wholeIndex=_imgS.count-1;
            }
            [self reshWholeScroll];
        }
        if (_wholeIndex==_pageControl.currentPage) {//没动
            
        }
        _pageControl.currentPage=_wholeIndex;
        _headScroll.contentOffset=CGPointMake(_headScroll.width, 0);
    }
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    if (scrollView.tag==100) {
    [self dismissKey];
    //    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

#pragma  mark photoBrower
-(void)longPress:(UILongPressGestureRecognizer*)press{
    if (press.state==UIGestureRecognizerStateBegan) {
        [_timer invalidate];
        _timer=nil;
    }
    if (press.state==UIGestureRecognizerStateEnded) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollWhole) userInfo:nil repeats:YES];
    }
    
}
-(void)skipToBrower:(UITapGestureRecognizer *)tap{
    [self skipToPhotoBrowerImgs:_imgS currentIndex:_wholeIndex];
}

-(void)skipToPhotoBrowerImgs:(NSArray * )imgs currentIndex:(NSInteger)currentIndex{
    ZLPickerBrowserViewController * brower=[ZLPickerBrowserViewController new];
    brower.delegate=self;
    brower.dataSource=self;
    brower.currentPage=currentIndex;
    //    _imgS=[NSMutableArray arrayWithArray:imgs];
    [self.navigationController pushViewController:brower animated:YES];
}
-(NSInteger)numberOfPhotosInPickerBrowser:(ZLPickerBrowserViewController *)pickerBrowser{
    return _imgS.count;
}
-(ZLPickerBrowserPhoto *)photoBrowser:(ZLPickerBrowserViewController *)pickerBrowser photoAtIndex:(NSUInteger)index{
    NSString * imgString= [NSString stringWithFormat:@"%@%@",ImgDuanKou,_imgS[index]];
    NSURL * imgUrl=[NSURL URLWithString:imgString];
    ZLPickerBrowserPhoto * photo=[ZLPickerBrowserPhoto photoAnyImageObjWith:imgUrl];
    return photo;
}
#pragma  mark -- textfield delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag<102) {
        if (![newString isValidateMoneying]) {
            if (textField.tag==100) {
                [self ShowAlertWithMessage:@"请输入正确的原价，且小数点后最多有两位"];
                return  NO;
            }
            [self ShowAlertWithMessage:@"请输入正确的现价，且小数点后最多有两位"];
            return  NO;
        }
    }else{
        
        
    }
    
    
    return YES;
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
