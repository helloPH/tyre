//
//  WithDrawRecord.h
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"
typedef  NS_ENUM(NSInteger,RecordType){
    RecordTypeVerifing,
    RecordTypeVerified,
};
@interface WithDrawRecord : SuperViewController
@property (nonatomic,assign)RecordType recordType;
@end
