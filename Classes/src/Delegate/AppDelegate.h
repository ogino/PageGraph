//
//  AppDelegate.h
//  CoreGraph
//
//  Created by 荻野 雅 on 11/01/31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
@private
	UIWindow* window_;
	GraphViewController* viewController_;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) GraphViewController* viewController;

@end

