//
//  VideoTalkManager.h
//  VoIPTest
//
//  Created by Tg W on 17/2/21.
//  Copyright © 2017年 oopsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VideoCallbackDelegate <NSObject>

/**
 *  当APP收到呼叫、处于后台时调用、用来处理通知栏类型和铃声。
 *
 *  @param name 呼叫者的名字
 */
- (void)onCallRing:(NSString*)name;
/**
 *  呼叫取消调用、取消通知栏
 */
- (void)onCancelRing;
/**
 *  APP收到呼叫、从后台回到前台时或者APP就在前台会调用、用于弹出呼叫界面。
 *
 *  @param aSession   会话实体
 *  @param Callername 呼叫者名字
 */

@end

@interface VideoTalkManager : NSObject

+ (VideoTalkManager *)sharedClinet;

- (void)initWithSever;

- (void)setDelegate:(id<VideoCallbackDelegate>)delegate;

@end
