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

@property(nonatomic, assign) NSUInteger currentStepCount;
@property(nonatomic, strong) NSArray<ExperimentCaseStep> *caseSteps;

@end

@implementation BaseExperiment

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentStepCount = 0;
    }
    return self;
}

#pragma mark - Experiment

+ (NSString *)displayName {
    @throw NSGenericException;
}

+ (NSString *)displayDesc {
    @throw NSGenericException;
}

#pragma mark - Public

- (void)setupCaseSteps:(NSArray<ExperimentCaseStep> *)steps forView:(UIView *)view {
    self.caseSteps = steps;
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runSteps:)];
    [view addGestureRecognizer:tapRecognizer];
}

- (void)runExperimentCase:(SEL)caseSelector
{
    MLog(@"++++++++++++ %@ ++++++++++++", NSStringFromSelector(caseSelector));
    [self resetCurrentStep];
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

- (void)showResultViewController:(UIViewController *)resultViewController {
    if (self.delegate &&
        [self.delegate
            respondsToSelector:@selector(caseFinishedWithResultViewController:)]) {
            [self.delegate caseFinishedWithResultViewController:resultViewController];
    }
}

#pragma mark - Generate dummy data

- (UIImage *)dummyImage {
    NSString *urlString = @"http://www.umbitious.com/media/16172/hello_world_crop.jpg";
    NSData *helloWorldImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *helloWorldImage = [UIImage imageWithData:helloWorldImageData];
    return helloWorldImage;
}

- (UIView *)rootView {
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    rootView.backgroundColor = [UIColor whiteColor];
    return rootView;
}

#pragma mark - Private

- (void)resetCurrentStep {
    self.caseSteps = nil;
    self.currentStepCount = 0;
}

- (void)runSteps:(UIGestureRecognizer *)gestureRecognizer {
    self.currentStepCount = self.currentStepCount % self.caseSteps.count;
    MLog(@"Step %lu", self.currentStepCount);
    ExperimentCaseStep currentStep = self.caseSteps[self.currentStepCount];
    currentStep(gestureRecognizer.view);
    self.currentStepCount++;
}

@end
