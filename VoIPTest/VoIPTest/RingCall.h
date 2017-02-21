//
//  RingCall.h
//  VoIPTest
//
//  Created by Tg W on 17/2/21.
//  Copyright © 2017年 oopsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RingCall : NSObject
+ (instancetype)sharedMCCall;
- (void)regsionPush;

@end
