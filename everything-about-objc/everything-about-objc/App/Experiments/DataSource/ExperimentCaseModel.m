//
//  ExperimentModel.m
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ExperimentCaseModel.h"
#import <objc/objc-runtime.h>

static inline id typed_objc_msgSend(id object, SEL selector) {
    id (*typed_msgSend)(id, SEL) = (void *)objc_msgSend;
    id ret = typed_msgSend(object, selector);
    return ret;
}

@interface ExperimentCaseModel ()

@property(nonatomic, assign) Class caseClass;

@end

@implementation ExperimentCaseModel

- (instancetype)initWithCaseClass:(Class)caseClass {
    self = [super init];
    if (self) {
        _caseClass = caseClass;
    }
    return self;
}

- (id<ExperimentCase>)caseInstance {
    if (!self.caseClass) {
        return nil;
    }
    return [[self.caseClass alloc] init];
}

- (NSString *)caseName {
    return (NSString *)typed_objc_msgSend(self.caseClass, @selector(caseName));
}

- (NSString *)caseDescription {
    return (NSString *)typed_objc_msgSend(self.caseClass, @selector(caseDescription));
}

@end
