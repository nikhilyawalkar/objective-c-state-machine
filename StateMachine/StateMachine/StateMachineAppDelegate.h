//
//  StateMachineAppDelegate.h
//  StateMachine
//
//  Created by Gino Coates on 6/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StateMachineViewController;

@interface StateMachineAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet StateMachineViewController *viewController;

@end
