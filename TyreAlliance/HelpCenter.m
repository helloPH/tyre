//
//  HelpCenter.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "HelpCenter.h"
#import "HelperCenterCell.h"


@interface HelpCenter ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * datas;
@end

@implementation HelpCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self loadData];
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"帮助中心";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData{
    _datas=[NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
    
    
}
-(void)newView{
    UIWebView * webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale  , Vwidth, Vheight-self.NavImg.height-10*self.scale)];
    webView.delegate=self;
    webView.backgroundColor=superBackgroundColor;
    [webView loadHTMLString:_textString baseURL:[NSURL URLWithString:_textString]];
    [self.view addSubview:webView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark --  tableView  delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelperCenterCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.question.text=[NSString stringWithFormat:@"%@",@"怎么计算返利"];
    cell.ask.text=[NSString stringWithFormat:@"%@",@"答：体检订单的三天,点击确认收货按钮的下周一开始返利."];
    
    
    return cell;
}
#pragma mark -- webView delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self startAnimating:nil];
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self stopAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self stopAnimating];
    [self showBtnEmpty:YES];
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
