//
//  AppDelegate.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"

@interface AppDelegate ()
@property (strong, nonatomic) BaseTabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self showTabbarController];
    
    return YES;
}

- (void)showTabbarController{
    self.tabBarController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = self.tabBarController;
    NSLog(@"我来了！");

//    [self customQueue];
//    [self dispatch_group];
//    [self dispatch_group_enter];
//    [self dispatch_barrier];
//    [self dddd];
}

- (void)dddd{
    dispatch_queue_t defaultQueue = dispatch_queue_create("com.test", DISPATCH_QUEUE_CONCURRENT);
    __block NSString *strTest = @"test";
    
    dispatch_async(defaultQueue, ^{
        if ([strTest isEqualToString:@"test"]) {
            NSLog(@"--%@--1-", strTest);
            [NSThread sleepForTimeInterval:1];
            if ([strTest isEqualToString:@"test"]) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"--%@--2-", strTest);
            } else {
                NSLog(@"====changed===");
            }
        }
    });
    dispatch_async(defaultQueue, ^{
        NSLog(@"--%@--3-", strTest);
    });
    dispatch_barrier_async(defaultQueue, ^{
        strTest = @"modify";
        NSLog(@"--%@--4-", strTest);
    });
    dispatch_async(defaultQueue, ^{
        NSLog(@"--%@--5-", strTest);
    });
}

/*
 dispatch_barrier_sync和dispatch_barrier_async的共同点：
 1、都会等待在它前面插入队列的任务（1、2、3）先执行完
 2、都会等待他们自己的任务（0）执行完再执行后面的任务（4、5、6）
 
 dispatch_barrier_sync和dispatch_barrier_async的不共同点：
 在将任务插入到queue的时候，dispatch_barrier_sync需要等待自己的任务（0）结束之后才会继续程序，然后插入被写在它后面的任务（4、5、6），然后执行后面的任务
 而dispatch_barrier_async将自己的任务（0）插入到queue之后，不会等待自己的任务结束，它会继续把后面的任务（4、5、6）插入到queue
 */
- (void)dispatch_barrier{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD.barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1--");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"2--");
    });
    dispatch_async(queue, ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3--");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"barrier--");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"barrier==");
    });
    NSLog(@"aaa");
    dispatch_async(queue, ^{
        NSLog(@"4");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"4--");
    });
    NSLog(@"bbb");
    dispatch_async(queue, ^{
        NSLog(@"5");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"5--");
    });
    dispatch_async(queue, ^{
        NSLog(@"6");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"6--");
    });
}

- (void)groupSync2{

}

/*
 串行队列：DISPATCH_QUEUE_SERIAL     开启一个子线程，按序执行
 并行队列：DISPATCH_QUEUE_CONCURRENT 开启多个子线程，无序执行
 注意：dispatch_group_notify会与耗时最长的线程在同一个线程
 */
- (void)dispatch_group_enter{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(8);
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"任务三完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"任务完成");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程");
        });
    });
}

/*
 串行队列：DISPATCH_QUEUE_SERIAL     开启一个子线程，按序执行
 并行队列：DISPATCH_QUEUE_CONCURRENT 开启多个子线程，无序执行
 */
- (void)dispatch_group{
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"1--");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2");
        [NSThread sleepForTimeInterval:8];
        NSLog(@"2--");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3--");
    });

    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify：任务都完成了");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程");
        });
    });
}

//自定义一个queue：
- (void)customQueue{
    /*
     第二个参数传：
     串行队列：DISPATCH_QUEUE_SERIAL     开启一个子线程，按序执行
     并行队列：DISPATCH_QUEUE_CONCURRENT 开启多个子线程，无序执行
     同步：串行、并行都会在主线程
     异步：串行、并行都会在子线程
     */
    
    //串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("com.gcd.serialQueue", DISPATCH_QUEUE_SERIAL);
    //并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.gcd.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //可以通过dispatch_queue_get_label(dispatch_queue_t queue)获取你创建queue的名字
    const char *c = dispatch_queue_get_label(concurrentQueue);
    NSLog(@"%s",c);//com.gcd.concurrentQueue
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1--");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2--");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:4];
        NSLog(@"3--");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"4");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"4--");
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
