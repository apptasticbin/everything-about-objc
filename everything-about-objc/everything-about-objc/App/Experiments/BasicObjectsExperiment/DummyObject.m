//
//  DummyObject.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyObject.h"
#import "MLog.h"

/**
 +(id)alloc:
- Enough memory is allocated not only for the properties defined by an object’s class, 
 but also the properties defined on each of the superclasses in its inheritance chain
- lear out the memory allocated for the object’s properties by setting them to zero. 
 This avoids the usual problem of memory containing garbage from whatever was stored before
 
 -(id)init:
- The init method is used by a class to make sure its properties have suitable initial values at creation
 */

@implementation DummyGrandParentObject

+ (instancetype)alloc {
    MLog(@"%@::%@", @"DummyGrandParentObject", NSStringFromSelector(_cmd));
    return [super alloc];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        MLog(@"%@::%@", @"DummyGrandParentObject", NSStringFromSelector(_cmd));
    }
    return self;
}

- (void)dummyGrandParentMethod {
    MLog(@"%@::%@", @"DummyGrandParentObject", NSStringFromSelector(_cmd));
}

- (void)commonMethod {
    MLog(@"%@::%@", @"DummyGrandParentObject", NSStringFromSelector(_cmd));
}

@end

@implementation DummyParentObject

- (instancetype)init {
    self = [super init];
    if (self) {
        MLog(@"%@::%@", @"DummyParentObject", NSStringFromSelector(_cmd));
    }
    return self;
}

- (void)dummyParentMethod {
    MLog(@"%@::%@", @"DummyParentObject", NSStringFromSelector(_cmd));
}

- (void)commonMethod {
    [super commonMethod];
    MLog(@"%@::%@", @"DummyParentObject", NSStringFromSelector(_cmd));
}

@end

static DummyObject *sharedObject;
static dispatch_once_t once;

@implementation DummyObject

+ (instancetype)sharedObject {
    dispatch_once(&once, ^(void) {
        MLog(@"Singleton only initializes once");
        sharedObject = [self new];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dummyProperty = 10;
        MLog(@"%@::%@", @"DummyObject", NSStringFromSelector(_cmd));
    }
    return self;
}

- (void)commonMethod {
    [super commonMethod];
    MLog(@"%@::%@", @"DummyObject", NSStringFromSelector(_cmd));
}

@end
