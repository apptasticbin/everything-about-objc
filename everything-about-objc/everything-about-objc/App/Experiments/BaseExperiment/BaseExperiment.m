//
//  BaseExperimentCase.m
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BaseExperiment.h"
#import <objc/objc-runtime.h>

@interface BaseExperiment ()

@end

@implementation BaseExperiment

#pragma mark - Experiment

+ (NSString *)displayName {
    return @"";
}

+ (NSString *)displayDesc {
    return @"";
}

- (void)runExperimentCase:(SEL)caseSelector
{
    NSLog(@"++++++++++++ %@ ++++++++++++", NSStringFromSelector(caseSelector));
    if ([self respondsToSelector:caseSelector]) {
        [self performSelector:caseSelector];
    }
}

@end
