//
//  StateMachineTests.m
//  StateMachineTests
//
//  Created by Gino Coates on 6/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StateMachineTests.h"
#import "StateMachine.h"

//--test class to test predicates against
@implementation TestObject

-(void) testFn
{
}

-(NSString*) testStringProperty
{
	return @"value";
}

-(BOOL) testBoolProperty
{
	return YES;
}

-(int) testIntProperty
{
	return -1;
}
@end

@implementation StateMachineTests
-(void) testStateInfo
{
	NSString* stateName = @"initial";
	StateInfo* state = [[StateInfo alloc] initWithStateName:stateName];
	STAssertTrue([state.stateName isEqual:stateName],@"expected state name %@",stateName);
    [state release];
}

-(void) testTransitionExecute
{
	StateInfo* state = [[StateInfo alloc] initWithStateName:@"initial"];
	NSString* testString = @"dummy";
	NSString* condition = @"SELF LIKE 'dummy'";
	Transition* target = [[Transition alloc] initWithCondition:condition andState:state];
	[state release];
	
	StateInfo* nextState = [target execute:testString];
	STAssertNotNil(nextState,@"Next state was nil");
	STAssertEquals(nextState,state,@"States should have been equal");
}

-(void) testInitStateMachine
{
	NSString* stateName = @"initial";
	StateInfo* state = [[StateInfo alloc] initWithStateName:stateName];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerInitialState:state];
	STAssertNotNil(target.states,@"State machine init failed, states collection null");
	STAssertTrue(1==[target.states count],@"Expected 1 states");
	STAssertNotNil(target.currentState,@"current state was nil");
	STAssertEquals(target.currentState,state,@"current state was not the expected state");
	STAssertTrue([target.currentState.stateName isEqual:stateName],@"expected state called initial");
}

-(void) testRegisterState
{
	StateInfo* state = [[StateInfo alloc] initWithStateName:@"initial"];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerState:state];
	STAssertTrue(1==[target.states count],@"Expected 1 states");
    [state release];
    //[target release];
}

-(void) testRegisterDuplicateState
{
	StateInfo* state = [[StateInfo alloc] initWithStateName:@"initial"];
	StateInfo* state2 = [[StateInfo alloc] initWithStateName:@"initial"];
	
	StateMachine* target = [[StateMachine alloc] initWithInitialState:state];
	
	@try {
		[target registerState:state2];
		STFail(@"This should have failed!");
	}
	@catch (NSException* e) {
		STAssertTrue(1==[target.states count],@"Expected 1 states");
        
	}
}

-(void) testSetState
{
	StateInfo* state = [[StateInfo alloc] initWithStateName:@"initial"];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerInitialState:state];
	StateInfo* nextState = [[StateInfo alloc] initWithStateName:@"nextState"];
	[target registerState:nextState];
	
	STAssertNotNil(target.states,@"State machine init failed, states collection null");
	STAssertTrue(2==[target.states count],@"Expected 1 states");
	STAssertNotNil(target.currentState,@"current state was nil");
}

-(void) testRegisterTransition
{
	StateInfo* initialState = [[StateInfo alloc] initWithStateName:@"initial"];
	StateInfo* nextState = [[StateInfo alloc] initWithStateName:@"next"];
	
	//--register transition
	NSString* condition = @"SELF LIKE %@";
	[initialState registerNextState:nextState withCondition:condition];
	STAssertTrue([initialState.transitions count]==1,@"Expected 1 transition");
    [initialState release];
    [nextState release];
}

-(void) testNextState
{
	StateInfo* initialState = [[StateInfo alloc] initWithStateName:@"initial"];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerInitialState:initialState];
	StateInfo* nextState = [[StateInfo alloc] initWithStateName:@"next"];
	
	//--register additional states
	[target registerState:nextState];
	
	//--register transition
	TestObject* testObj = [[TestObject alloc] init];
    NSString* condition = @"SELF.testStringProperty LIKE 'value' AND SELF.testBoolProperty == YES and SELF.testIntProperty == -1";
	[initialState registerNextState:nextState withCondition:condition];
	
	//--go to next state
	StateInfo* actual = [target nextState:testObj];
	STAssertNotNil(target.states,@"State machine init failed, states collection null");
	STAssertTrue(2==[target.states count],@"Expected 1 states");
	STAssertNotNil(target.currentState,@"current state was nil");
	STAssertEquals(target.currentState,nextState,@"current state was not the expected state");
	STAssertEquals(actual,nextState,@"actual state was not the expected state");
}

-(void) testCanTransitionToNextState
{
	StateInfo* initialState = [[StateInfo alloc] initWithStateName:@"initial"];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerInitialState:initialState];
	StateInfo* nextState = [[StateInfo alloc] initWithStateName:@"next"];
	
	//--register additional states
	[target registerState:nextState];
	TestObject* testObj = [[TestObject alloc] init];
	NSString* condition = @"SELF.testStringProperty LIKE 'value' AND SELF.testBoolProperty == YES and SELF.testIntProperty == -1";
	[initialState registerNextState:nextState withCondition:condition];
    
	BOOL actual = [target canTransition:testObj];
	STAssertTrue(actual,@"Actual should have been true, can't transition to next state");
    
    [testObj release];
    [initialState release];
    [nextState release];
    [target release];
}

-(void) testStateExecute
{
	StateInfo* initialState = [[StateInfo alloc] initWithStateName:@"initial"];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerInitialState:initialState];
	StateInfo* nextState = [[StateInfo alloc] initWithStateName:@"next"];
	
	//--register additional states
	[target registerState:nextState];
	TestObject* testObj = [[TestObject alloc] init];
	NSString* condition = @"SELF.testStringProperty LIKE 'value' AND SELF.testBoolProperty == YES and SELF.testIntProperty == -1";
	[initialState registerNextState:nextState withCondition:condition];
	
	nextState.selector = @selector(testFn:);
	
	BOOL actual = [target canTransition:testObj];
	STAssertTrue(actual,@"Actual should have been true, can't transition to next state");
    [testObj release];
    [initialState release];
    [nextState release];
    [target release];
}

-(void) testStateCheck
{
	StateInfo* state = [[StateInfo alloc] initWithStateName:@"initial"];
	StateMachine* target = [[StateMachine alloc] init];
	[target registerInitialState:state];
	
	BOOL actual = [target isCurrentState:@"initial"];
	STAssertTrue(actual,@"Expected initial state");
	
	actual = [target isCurrentState:@"notinitial"];
	STAssertFalse(actual,@"Expected initial state");
    
    [state release];
    //[target release];
}
@end

