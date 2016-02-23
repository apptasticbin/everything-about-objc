//
//  ExperimentModel.m
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ExperimentModel.h"
#import "CaseModel.h"
#import <objc/objc-runtime.h>

NSString * const CaseMethodSuffix = @"ExperimentCase";

static inline id typed_objc_msgSend(id object, SEL selector) {
    id (*typed_msgSend)(id, SEL) = (void *)objc_msgSend;
    id ret = typed_msgSend(object, selector);
    return ret;
}

@interface ExperimentModel ()

@property(nonatomic, assign) Class experimentClass;
@property(nonatomic, readwrite, strong) NSArray *caseModels;

@end

@implementation ExperimentModel

- (instancetype)initWithExperimentClass:(Class)experimentClass {
    self = [super init];
    if (self) {
        _experimentClass = experimentClass;
    }
    return self;
}

- (NSArray *)caseModels {
    if (!_caseModels) {
        _caseModels = [self generateCaseModels];
    }
    return _caseModels;
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

#pragma mark - Private

- (NSArray *)generateCaseModels {
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(self.experimentClass.class, &methodCount);
    NSMutableArray *caseModels = [NSMutableArray array];
    if (methodCount) {
        for (int index=0; index<methodCount; index++) {
            Method method = methodList[index];
            SEL methodSelector = method_getName(method);
            NSString *selectorString = NSStringFromSelector(methodSelector);
            if ([self isExperimentSelector:selectorString]) {
                NSString *displayName = [self displayNameFromSelector:methodSelector];
                CaseModel *caseModel = [[CaseModel alloc] initWithDiaplayName:displayName caseSelector:methodSelector];
                [caseModels addObject:caseModel];
            }
        }
    }
    free(methodList);
    return caseModels;
}

- (BOOL)isExperimentSelector:(NSString *)selectorString {
    return [selectorString hasSuffix:CaseMethodSuffix];
}

- (NSString *)displayNameFromSelector:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    return [self removeSuffix:CaseMethodSuffix fromString:selectorString];
}

- (NSString *)removeSuffix:(NSString *)suffix fromString:(NSString *)orig {
    return [orig stringByReplacingOccurrencesOfString:suffix withString:@""];
}

@end
