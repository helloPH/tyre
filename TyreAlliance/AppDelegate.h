//
//  AppDelegate.h
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertBloc)(NSInteger index);
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)switchRootController;
-(void)zhuce;
-(void)unRegistNoti;
@end

