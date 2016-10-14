//
//  SuperTableViewCell.m
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@implementation SuperTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scale = 1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
    }
    return self;
}
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:fone, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return   [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}




- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    // 获取一个UITouch
    UITouch *touch = [touches anyObject];
    
    // 获取当前的位置
    CGPoint current = [touch locationInView:self];
    CGFloat x = [UIScreen mainScreen].bounds.size.width;
    if (current.x >= x + 1) {
        //在地图上
        NSLog(@"在地图上, 不滚动, view class is %@", view.class);
        return YES;
    } else {
        return [self touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"cancle class is %@", view.class);
    
    if ([view isKindOfClass:NSClassFromString(@"TapDetectingView")]) {
        return NO;
    } else {
        return [self touchesShouldCancelInContentView:view];
    }
}


@end
