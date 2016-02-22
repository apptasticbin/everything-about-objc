//
//  ExperimentModel.m
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ExperimentModel.h"
#import "BaseExperiment.h"
#import <objc/objc-runtime.h>

static inline id typed_objc_msgSend(id object, SEL selector) {
    id (*typed_msgSend)(id, SEL) = (void *)objc_msgSend;
    id ret = typed_msgSend(object, selector);
    return ret;
}

@interface ExperimentModel ()

@property(nonatomic, assign) Class experimentClass;

@end

@implementation ExperimentModel

- (instancetype)initWithExperimentClass:(Class)experimentClass {
    self = [super init];
    if (self) {
        _experimentClass = experimentClass;
    }
    return self;
}

- (BaseExperiment *)experimentInstance {
    if (!self.experimentClass) {
        return nil;
    }
    return [[self.experimentClass alloc] init];
}

- (NSString *)displayName {
    return (NSString *)typed_objc_msgSend(self.experimentClass, @selector(displayName));
}

- (NSString *)displayDesc {
    return (NSString *)typed_objc_msgSend(self.experimentClass, @selector(displayDesc));
}

@end
