//
//  ExperimentDataSource.m
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ExperimentDataSource.h"
#import "Experiment.h"
#import "ExperimentModel.h"
#import <objc/objc-runtime.h>

@interface ExperimentDataSource ()

@property(nonatomic, strong) NSArray *experiments;

@end

@implementation ExperimentDataSource

+ (ExperimentDataSource *)sharedDataSource {
    static dispatch_once_t once;
    static ExperimentDataSource *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)loadExperimentsComplete:(LoadExperimentsCompleteHandler)completeHandler {
    if (!self.experiments) {
        self.experiments = [self loadExperiments];
    }
    if (completeHandler) {
        completeHandler(self.experiments);
    }
}

#pragma mark - Private

- (NSArray *)loadExperiments {
    int bufferSize = objc_getClassList(NULL, 0);
    Class *buffer = (Class *)malloc(bufferSize * sizeof(Class));
    objc_getClassList(buffer, bufferSize);
    
    NSMutableArray *experiments = [NSMutableArray array];
    for (int index=0; index<bufferSize; index++) {
        Class classObject = buffer[index];
        if (class_conformsToProtocol(class_getSuperclass(classObject), @protocol(Experiment))) {
            ExperimentModel *caseModel = [[ExperimentModel alloc] initWithExperimentClass:classObject];
            [experiments addObject:caseModel];
        }
    }
    free(buffer);
    return experiments;
}

@end
