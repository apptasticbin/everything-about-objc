//
//  ExperimentModel.h
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseExperiment;

@interface ExperimentModel : NSObject

@property(nonatomic, readonly, strong) NSString *displayName;
@property(nonatomic, readonly, strong) NSString *displayDesc;

- (instancetype)initWithExperimentClass:(Class)experimentClass;
- (BaseExperiment *)experimentInstance;

@end
