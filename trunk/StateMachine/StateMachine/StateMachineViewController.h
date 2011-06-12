//
//  StateMachineViewController.h
//  StateMachine
//
//  Created by Gino Coates on 6/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StateMachine;

@interface StateMachineViewController : UIViewController {
    StateMachine* _stateMachine;
    UILabel* _stateNameLabel;
    int _count;
}

@property (nonatomic, retain) StateMachine* stateMachine;
@property (nonatomic, retain) IBOutlet UILabel* stateNameLabel;
@property (nonatomic, readonly) NSString* currentStateName;
@property (nonatomic) int count;

-(IBAction) onNextState:(id)sender;
@end
