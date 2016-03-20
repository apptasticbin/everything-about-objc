//
//  DummyEntry.m
//  everything-about-objc
//
//  Created by Bin Yu on 17/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyEntryMO.h"

@implementation DummyEntryMO

/**
 The @dynamic tag informs the compiler that the variable will be resolved at runtime.
 */
@dynamic dummyAttribute;
@dynamic parents;
@dynamic children;
@dynamic friends;
@dynamic beFriendedBy;

/**
 Although the standard description method does not cause a fault to fire, 
 if you implement a custom description method that accesses the object’s 
 persistent properties, the fault will fire. You are strongly discouraged 
 from overriding description in this way
 */
- (NSString *)description {
    return [NSString stringWithFormat:@"dummyAttribute: %@", self.dummyAttribute];
}

@end
