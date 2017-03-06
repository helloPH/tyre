//
//  SuperViewController.h
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultPageSource.h"
#import "NSString+Helper.h"
#import "NSString+Encrypt.h"
#import "UIViewAdditions.h"
#import "Stockpile.h"
#import "AppDelegate.h"
#import "CellView.h"


#import "UIImageView+AFNetworking.h"
//#import "CustomSearchBar.h"
//#import "UIImageView+AFNetworking.h"
//#import "UIButton+AFNetworking.h"
#import "AnalyzeObject.h"


#import "UIView+MJExtension.h"
#import "UITableView+AddRefresh.h"
#import "UIScrollView+AddRefresh.h"

#import "MJRefresh.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

#import "LineView.h"
#import "UIImage+Helper.h"
#import "IQKeyboardManager.h"


//#import "WPHotspotLabel.h"
//#import "NSString+WPAttributedMarkup.h"
//#import "WPAttributedStyleAction.h"
#import "UITextView+limitText.h"
#import "UITextField+limitText.h"

typedef void(^AlertBlock)(NSInteger index);
@interface SuperViewController : UIViewController


@property(nonatomic,assign)float scale;
@property(nonatomic,copy)void(^fanTime)(NSString *str);
@property(nonatomic,copy)void(^fanaddress)(NSString *str,NSDictionary *dic);
@property(nonatomic,copy)void(^fanzuzhi)(NSString *str,NSString *Id);
@property(nonatomic,strong)UIImageView *NavImg;
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UIActivityIndicatorView *activityVC;
@property(nonatomic,strong)UIImageView *Navline;

@property (nonatomic,strong)UIImageView * btnEmpty;
@property (nonatomic,strong)UIImageView * loadFailed;

@property(nonatomic,strong)AppDelegate *appdelegate;

@property(nonatomic,strong)MBProgressHUD *HUD,*HUDString;

@property(nonatomic,assign)BOOL reshEnd;
-(UIStatusBarStyle)preferredStatusBarStyle;
-(void)ShowAlertWithMessage:(NSString *)message;
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block;
-(void)showSAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate block:(AlertBlock)block;
-(void)dismissKey;
-(void)setName:(NSString *)name;
-(NSMutableAttributedString *)stringColorAllString:(NSString *)string redString:(NSString *)redString;
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone;
-(NSDictionary *)Style;
-(NSMutableAttributedString *)stringColorAllString:(NSString *)string YelloyString:(NSString *)redString;
-(NSString *)getToday;
//-(void)selectr:(NSMutableArray *)dataa;
//-(NSString *)selectTime:(UIView *)view minDate:(NSString *)Date;
//-(void)selectJiBie;
//-(void)selectAddress:(NSArray *)arr;
-(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleBy;
-(void)makePhoneWithTel:(NSString *)string;
-(void)openUrl:(NSString *)string;
-(NSMutableAttributedString*)stringColorAllString:(NSString *)string orgin:(NSString *)orgin;
-(void)showBtnEmpty:(BOOL)show;
-(void)showFailed:(BOOL)show;
/**
 *set字符串如果没有特殊要求请填nil
 */
-(void)startAnimating:(NSString *)set;
-(void)stopAnimating;
-(void)startAnimatingWithString:(NSString *)set;
//-(float)textWithView:(UILabel *)lable withWidth:(float)width;
//-(NSMutableAttributedString*)stringColorAllString:(NSString *)string gradColor:(NSString *)orgin;

//////  ------   彭辉  自家   -----
-(void)showPromptBoxWithSting:(NSString *)prompt;
-(void)showPromptInWindowWithString:(NSString *)prompt;
@end
