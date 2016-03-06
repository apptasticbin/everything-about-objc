//
//  DummyObject.h
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int dummyIvar;
} DummyStructure;

@interface DummyGrandParentObject : NSObject

- (void)dummyGrandParentMethod;
- (void)commonMethod;

@end

@interface DummyParentObject : DummyGrandParentObject

- (void)dummyParentMethod;
- (void)commonMethod;

@end

@interface DummyObject : DummyParentObject

@property(nonatomic, assign) NSInteger dummyProperty;

+ (instancetype)sharedObject;
- (void)commonMethod;

@end
