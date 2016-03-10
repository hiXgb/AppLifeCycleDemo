//
//  AppDelegate.m
//  AppLifeCycleDemo
//
//  Created by 谢国碧 on 16/3/10.
//  Copyright © 2016年 xieguobi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//App由Not running状态启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"app didFinishLaunchingWithOptions");
    
    return YES;
}

//来系统电话、呼出通知中心、呼出控制中心
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"app willResignActive");
}

//1.点击home
//2.锁屏
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"app didEnterBackground");
    
    //start background task
    __block UIBackgroundTaskIdentifier background_task;
    
    //background task running time differs on different iOS versions.
    //about 10 mins on early iOS, but only 3 mins on iOS7.
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^{
        
        NSLog(@"task expired...");
        [application endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while (true) {
            float remainingTime = [application backgroundTimeRemaining];
            NSLog(@"remaining background time:%f", remainingTime);
            
            [NSThread sleepForTimeInterval:1.0];
            
            __block BOOL inForeground = false;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                inForeground = ([UIApplication sharedApplication].applicationState == UIApplicationStateActive);
            });
            
            if (remainingTime <= 3.0 || inForeground) {
                NSLog(@"endBackgroundTask");
                break;
            }
        }
        
        [application endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
    });
}

//1.点击App icon图标
//2.原本停留在前台然后锁屏再解锁也会调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"app willEnterForeground");
}

//1.处于Inactive状态又恢复，例如被系统电话打断电话挂断后执行
//2.从后台进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"app didBecomeActive");
}

//处于前台或者处于后台模式（没有被挂起）用户主动kill或是被系统kill才会执行
//注意处于挂起状态不管用户主动kill还是被系统kill都不会进到这个回调
//参考：https://blog.newrelic.com/2016/01/13/ios9-background-execution/
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"app willTerminate");
}

@end
