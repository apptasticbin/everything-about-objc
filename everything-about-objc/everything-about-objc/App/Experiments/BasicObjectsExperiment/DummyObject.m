//
//  DummyObject.m
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DummyObject.h"

@implementation DummyObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _dummyProperty = 10;
    }
    return self;
}

@end
