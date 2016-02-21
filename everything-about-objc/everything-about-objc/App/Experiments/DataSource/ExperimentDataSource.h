//
//  ExperimentDataSource.h
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoadExperimentsCompleteHandler)(NSArray *);

@interface ExperimentDataSource : NSObject

+ (ExperimentDataSource *)sharedDataSource;
- (void)loadExperimentsComplete:(LoadExperimentsCompleteHandler)completeHandler;

@end
