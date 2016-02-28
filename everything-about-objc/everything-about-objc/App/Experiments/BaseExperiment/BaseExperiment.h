//
//  BaseExperimentCase.h
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Experiment.h"
#import "MLog.h"

@protocol ExperimentDelegate<NSObject>

@optional
- (void)caseFinishedWithResultView:(UIView *)resultView;
- (void)caseFinishedWithResultViewController:(UIViewController *)resultViewController;

@end

@interface BaseExperiment : NSObject<Experiment>

@property(nonatomic, weak)id<ExperimentDelegate> delegate;

- (void)runExperimentCase:(SEL)caseSelector;
- (void)showResultView:(UIView *)resultView;
- (void)showResultViewController:(UIViewController *)resultViewController;

@end
