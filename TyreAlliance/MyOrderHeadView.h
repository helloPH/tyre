//
//  MyOrderHeadView.h
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol headerDelegate <NSObject>
-(void)headerActionWithSection:(NSInteger )section;
@end
@interface MyOrderHeadView : UITableViewHeaderFooterView
@property (nonatomic,strong)id <headerDelegate> delegate;
@property (nonatomic,assign)NSInteger section;
@property (nonatomic,strong)UILabel * labelOrderNum;
@property (nonatomic,strong)UILabel * labelOrderStates;
@property (nonatomic,strong)UIView * line1;

@property (nonatomic,strong)UILabel * labelConsignee;
@property (nonatomic,strong)UILabel * labelNumber;
@property (nonatomic,strong)UIImageView * imgAdd;
@property (nonatomic,strong)UILabel * btnAddress;
@end
