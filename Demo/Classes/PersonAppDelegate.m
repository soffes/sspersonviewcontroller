//
//  PersonAppDelegate.m
//  Person
//
//  Created by Sam Soffes on 2/6/11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "PersonAppDelegate.h"
#import "PVDemoViewController.h"

@implementation PersonAppDelegate

@synthesize window = _window;

#pragma mark NSObject

- (void)dealloc {
	[_window release];
	[super dealloc];
}


#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor redColor];
	
	PVDemoViewController *viewController = [[PVDemoViewController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	_window.rootViewController = navigationController;
	[navigationController release];
	
	[_window makeKeyAndVisible];
	
    return YES;
}

@end
