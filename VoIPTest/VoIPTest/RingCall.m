//
//  RingCall.m
//  VoIPTest
//
//  Created by Tg W on 17/2/21.
//  Copyright © 2017年 oopsr. All rights reserved.
//

#import "RingCall.h"
#import "VideoTalkManager.h"
#import <UserNotifications/UserNotifications.h>

@interface RingCall ()<VideoCallbackDelegate>{
    UILocalNotification *callNotification;
    UNNotificationRequest *request;//ios 10
}
@end

@implementation RingCall
+ (instancetype)sharedMCCall {
    
    static  RingCall *callInstane;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (callInstane == nil) {
            callInstane = [[RingCall alloc] init];
            [[VideoTalkManager sharedClinet] setDelegate:callInstane];
        }
    });
    return callInstane;
}

- (void)regsionPush {
    //iOS 10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    
}

#pragma mark-VideoCallbackDelegate

- (void)onCallRing:(NSString *)CallerName {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body =[NSString localizedUserNotificationStringForKey:[NSString
                                                                       stringWithFormat:@"%@%@", CallerName,
                                                                       @"邀请你进行通话。。。。"] arguments:nil];;
        UNNotificationSound *customSound = [UNNotificationSound soundNamed:@"voip_call.caf"];
        content.sound = customSound;
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:1 repeats:NO];
        request = [UNNotificationRequest requestWithIdentifier:@"Voip_Push"
                                                       content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else {
        
        callNotification = [[UILocalNotification alloc] init];
        callNotification.alertBody = [NSString
                                      stringWithFormat:@"%@%@", CallerName,
                                      @"邀请你进行通话。。。。"];
        
        callNotification.soundName = @"voip_call.caf";
        [[UIApplication sharedApplication]
         presentLocalNotificationNow:callNotification];
        
    }
    
}

- (void)onCancelRing {
    //取消通知栏
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        NSMutableArray *arraylist = [[NSMutableArray alloc]init];
        [arraylist addObject:@"Voip_Push"];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:arraylist];
    }else {
        [[UIApplication sharedApplication] cancelLocalNotification:callNotification];
    }
    
}

@end
