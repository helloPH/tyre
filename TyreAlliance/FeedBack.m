//
//  FeedBack.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "FeedBack.h"
#import "ZLPickerViewController.h"
#import "ZLPickerBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface FeedBack ()<UITextViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,assign)CGFloat setY;
@property (nonatomic,strong)UIButton * commitBtn;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UILabel * labelPlace;
@end

@implementation FeedBack

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"留言反馈";
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
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    
    CellView * cellView1=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, Vwidth, 40*self.scale)];
    [_scrollView addSubview:cellView1];
    cellView1.titleLabel.text=@"留言反馈";
    
    
    UIView * editView = [[UIView alloc]initWithFrame:CGRectMake(0, cellView1.bottom, Vwidth, Vwidth*0.4)];
    editView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:editView];
    
    UITextView * textView=[[UITextView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, editView.width-20*self.scale,editView.height-20*self.scale)];
    textView.font=DefaultFont(self.scale);
    textView.delegate=self;
    _textView=textView;
    [editView addSubview:textView];
    
    UILabel * labelPlace=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, textView.width, 20*self.scale)];
    labelPlace.font=DefaultFont(self.scale);
    labelPlace.textColor=[UIColor lightGrayColor];
    [textView addSubview:labelPlace];
    labelPlace.text=@"意见被采纳后可留联系方式，方便联系";
    _labelPlace=labelPlace;

    _scrollView.contentSize=CGSizeMake(Vwidth, labelPlace.bottom+50*self.scale);
    
    

    
  
    
    _commitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 0, Vwidth-20*self.scale, 30*self.scale)];
    _commitBtn.titleLabel.font=DefaultFont(self.scale);
    [_commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
    _commitBtn.layer.cornerRadius=4;
    _commitBtn.layer.masksToBounds=YES;
    [_commitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitBtn];
    _commitBtn.bottom=_scrollView.height-20*self.scale;
    
    
    
    
}
-(void)submitBtn:(UIButton *)sender{
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                         @"reson":_textView.text};
    [AnalyzeObject feedBackWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        if ([ret isEqualToString:@"1"]) {
            
        }else{
            
            
        }
        [self showPromptBoxWithSting:msg];
    }];
    
}

#pragma mark -- textfield delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _labelPlace.hidden=YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        _labelPlace.hidden=NO;
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
