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
    @throw NSGenericException;
}

+ (NSString *)displayDesc {
    @throw NSGenericException;
}

- (void)runExperimentCase:(SEL)caseSelector
{
    MLog(@"++++++++++++ %@ ++++++++++++", NSStringFromSelector(caseSelector));
    if ([self respondsToSelector:caseSelector]) {
        [self performSelector:caseSelector];
    }
}

- (void)showResultView:(UIView *)resultView {
    if (self.delegate &&
        [self.delegate
            respondsToSelector:@selector(caseFinishedWithResultView:)]) {
            [self.delegate caseFinishedWithResultView:resultView];
    }
}

@end
