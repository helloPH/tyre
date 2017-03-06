//
//  About.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "About.h"

@interface About ()<UIWebViewDelegate>

@end

@implementation About

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"关于我们";
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
    UIWebView * webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale  , Vwidth, Vheight-self.NavImg.height-10*self.scale)];
    webView.delegate=self;
    webView.backgroundColor=superBackgroundColor;
    [webView loadHTMLString:_urlString baseURL:[NSURL URLWithString:_urlString]];
    [self.view addSubview:webView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- webView delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self startAnimating:nil];
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
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
