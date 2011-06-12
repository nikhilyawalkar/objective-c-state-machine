//
//  StateMachineTests.h
//  StateMachineTests
//
//  Created by Gino Coates on 6/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface StateMachineTests : SenTestCase {
    
}
@end


@interface TestObject : NSObject
{
}

@property (readonly) NSString* testStringProperty;
@property (readonly) BOOL testBoolProperty;
@property (readonly) int testIntProperty;

@end
