//
//  BaseExperimentCase.h
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Experiment.h"

FOUNDATION_EXTERN NSString * const ExperimentCaseMethodSuffix;

@interface BaseExperiment : NSObject<Experiment>

@property(nonatomic, readonly, strong) NSArray *caseSelectors;

@end
