//
//  AppDelegate.m
//  iCastelli
//
//  Created by Eyolph on 19/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "FeedViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"]];
    NSString *appID = [dictionary objectForKey:@"AppID"];
    NSString *clientKey = [dictionary objectForKey:@"parseClientKey"];
    
    [Parse setApplicationId:appID
                  clientKey:clientKey];
    
    

    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PFUser *user = [PFUser currentUser];
    
    if (user == nil) {
        
        HomeViewController *home = [[HomeViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
        nav.toolbar.barTintColor = [UIColor colorWithHue:0.494 saturation:0.5 brightness:0.7 alpha:1];
        nav.toolbar.tintColor = [UIColor whiteColor];
        nav.navigationBar.barTintColor = [UIColor colorWithHue:0.494 saturation:0.5 brightness:0.7 alpha:1];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.interactivePopGestureRecognizer.enabled = NO;

        self.window.rootViewController = nav;

    

    } else {

        FeedViewController *f = [[FeedViewController alloc] init];
          UINavigationController *nev = [[UINavigationController alloc] initWithRootViewController:f];

        PFQuery *que = [PFUser query];
        [que whereKey:@"username" equalTo:[PFUser currentUser].username];
        [que getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error){
                NSNumber *num = object[@"color"];
                nev.toolbar.barTintColor = [UIColor colorWithHue:num.floatValue saturation:0.5 brightness:0.7 alpha:1];
                nev.toolbar.tintColor = [UIColor whiteColor];
                nev.navigationBar.barTintColor = [UIColor colorWithHue:num.floatValue saturation:0.5 brightness:0.7 alpha:1];
                nev.navigationBar.tintColor = [UIColor whiteColor];

                
            } else {
                nev.navigationBar.barTintColor = [UIColor colorWithHue:0.494 saturation:0.5 brightness:0.7 alpha:1];
                nev.navigationBar.tintColor = [UIColor whiteColor];
            }
        }];
        
        nev.interactivePopGestureRecognizer.enabled = NO;

        self.window.rootViewController = nev;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
