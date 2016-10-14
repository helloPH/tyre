//
//  UITextView+limitText.m
//  DemoForKey
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UITextView+limitText.h"

@implementation UITextView (limitText)
-(void)limitText:(NSNumber *)number{
    [self setValue:number forKey:@"xianzhi"];
}
@end
