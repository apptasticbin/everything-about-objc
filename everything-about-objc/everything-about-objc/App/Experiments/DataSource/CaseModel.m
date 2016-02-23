//
//  CaseModel.m
//  everything-about-objc
//
//  Created by Bin Yu on 23/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CaseModel.h"

@implementation CaseModel

- (instancetype)initWithDiaplayName:(NSString *)displayName
                       caseSelector:(SEL)selector {
    self = [super init];
    if (self) {
        _displayName = displayName;
        _caseSelector = selector;
    }
    return self;
}

@end
