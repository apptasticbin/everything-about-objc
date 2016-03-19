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

- (NSString *)description {
    return [NSString stringWithFormat:@"dummyAttribute: %@", self.dummyAttribute];
}

@end
