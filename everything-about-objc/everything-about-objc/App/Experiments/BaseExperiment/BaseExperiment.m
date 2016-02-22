//
//  BaseExperimentCase.m
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BaseExperiment.h"
#import <objc/objc-runtime.h>

NSString * const ExperimentCaseMethodSuffix = @"ExperimentCase";

@interface BaseExperiment ()

@property(nonatomic, readwrite, strong) NSArray *caseSelectors;

@end

@implementation BaseExperiment

#pragma mark - Experiment

+ (NSString *)displayName {
    return @"";
}

+ (NSString *)displayDesc {
    return @"";
}

- (NSArray *)caseSelectors {
    if (!_caseSelectors) {
        _caseSelectors = [self filterCaseSelectors];
    }
    return _caseSelectors;
}

#pragma mark - Private

- (NSArray *)filterCaseSelectors {
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(self.class, &methodCount);
    NSMutableArray *methodSelectors = [NSMutableArray array];
    if (methodCount) {
        for (int index=0; index<methodCount; index++) {
            Method method = methodList[index];
            SEL methodSelector = method_getName(method);
            NSString *selectorString = NSStringFromSelector(methodSelector);
            if ([self isExperimentSelector:selectorString]) {
                [methodSelectors
                    addObject:[NSValue valueWithBytes:&methodSelector
                                             objCType:@encode(SEL)]];
            }
        }
    }
    free(methodList);
    return methodSelectors;
}

- (BOOL)isExperimentSelector:(NSString *)selectorString {
    return [selectorString hasSuffix:ExperimentCaseMethodSuffix];
}

@end
