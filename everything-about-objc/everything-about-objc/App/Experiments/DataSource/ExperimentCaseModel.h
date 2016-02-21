//
//  ExperimentModel.h
//  everything-about-objc
//
//  Created by Bin Yu on 21/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExperimentCase.h"

@interface ExperimentCaseModel : NSObject

@property(nonatomic, readonly, strong) NSString *caseName;
@property(nonatomic, readonly, strong) NSString *caseDescription;

- (instancetype)initWithCaseClass:(Class)caseClass;
- (id<ExperimentCase>)caseInstance;

@end
