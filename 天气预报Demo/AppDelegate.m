//
//  AppDelegate.m
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "Reachability.h"

@interface AppDelegate ()
{
    Reachability *_reach;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //数据库文件相关处理
    NSString *pathStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",pathStr);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Citys.sqlite",pathStr]]) {
        NSLog(@"数据库文件不存在，拷贝到沙盒");
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Citys" ofType:@"sqlite"] toPath:[NSString stringWithFormat:@"%@/Citys.sqlite",pathStr] error:nil];
    }
    
    //检测网络
    _reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    _reach.reachableBlock=^(Reachability *reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"网络正常");
        });
    };
    _reach.unreachableBlock=^(Reachability *reach){
        NSLog(@"网络异常");
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [_reach startNotifier];
    
    HomeController *homeCtl=[[HomeController alloc] init];
    UINavigationController *navCtl=[[UINavigationController alloc] initWithRootViewController:homeCtl];
    _window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController=navCtl;
    [_window makeKeyAndVisible];
    
    return YES;
}

-(void)reachabilityChanged:(NSNotification *)notification{
    Reachability *reach=notification.object;
    if (reach.isReachable) {
        NSLog(@"网络正常");
    }else{
        NSLog(@"网络异常");;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
