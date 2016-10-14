//
//  MyOrderFooterView.h
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol footerDelegate <NSObject>
-(void)actionWithSection:(NSInteger )section;
@end


@interface MyOrderFooterView : UITableViewHeaderFooterView
@property (nonatomic,assign)BOOL isHave;

@property (nonatomic,strong)id <footerDelegate> delegate;
@property (nonatomic,strong)UILabel * labelGodsCount;
@property (nonatomic,strong)UILabel * labelPaid;
@property (nonatomic,strong)UIView * line;
@property (nonatomic,strong)UIButton * btnAction;
@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic,assign)NSInteger section;
@end
