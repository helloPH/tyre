//
//  LogIn.h
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

typedef void(^Block)(BOOL ok);

@interface LogIn : SuperViewController
-(id)initWithLogin:(Block)blocks;
@end
