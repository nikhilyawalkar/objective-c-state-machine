//
//  StateMachineViewController.m
//  StateMachine
//
//  Created by Gino Coates on 6/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StateMachineViewController.h"
#import "StateMachine.h"

@implementation StateMachineViewController
@synthesize stateMachine = _stateMachine, stateNameLabel = _stateNameLabel, count = _count;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//*****************************************************************************
//--Return the current state name
//*****************************************************************************
-(NSString*) currentStateName
{
    return self.stateNameLabel.text;
}

//*****************************************************************************
//--Executes when state machine enters state 1
//*****************************************************************************
-(void) state1Method
{
    self.stateNameLabel.text = self.stateMachine.currentState.stateName;
}

//*****************************************************************************
//--Executes when state machine enters state 2
//*****************************************************************************
-(void) state2Method
{
    self.stateNameLabel.text = self.stateMachine.currentState.stateName;
    self.count++;
}

//*****************************************************************************
//--Executes when state machine enters final state
//*****************************************************************************
-(void) finalStateMethod
{
    self.stateNameLabel.text = self.stateMachine.currentState.stateName;
}

//*****************************************************************************
//--Setup a statemachine that operates based on the value of the currentStateName 
//--attribute
//*****************************************************************************
-(void) setupStateMachine
{
    StateInfo* initialState = [[StateInfo alloc] initWithStateName:@"initialState"];
    self.stateMachine = [[StateMachine alloc] initWithInitialState:initialState];
    self.stateNameLabel.text = initialState.stateName;
    [initialState release];
    
    StateInfo* state1 = [[StateInfo alloc] initWithStateName:@"state1"];
    state1.selector = @selector(state1Method);
    
    StateInfo* state2 = [[StateInfo alloc] initWithStateName:@"state2"];
    state2.selector = @selector(state2Method);
    
    StateInfo* finalState = [[StateInfo alloc] initWithStateName:@"finalState"];
    finalState.selector = @selector(finalStateMethod);
    
    [initialState registerNextState:state1 withCondition:@"TRUEPREDICATE"];
    [state1 registerNextState:state2 withCondition:@"SELF.currentStateName == 'state1'"];
    [state2 registerNextState:state1 withCondition:@"SELF.currentStateName == 'state2' && SELF.count <  5"];
    [state2 registerNextState:finalState withCondition:@"SELF.currentStateName == 'state2' && SELF.count >= 5"];
    [state1 release];
    [state2 release];
    [finalState release];
}

//*****************************************************************************
//When the NextState button is clicked, transition the state machine to the next
//state
//*****************************************************************************
-(IBAction) onNextState:(id)sender
{
    //--pass the object to evaluate the next state against
    [self.stateMachine nextState:self];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //--setup the state machine
    [self setupStateMachine];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self.stateMachine release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
