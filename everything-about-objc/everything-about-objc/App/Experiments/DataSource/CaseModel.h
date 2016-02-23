//
//  CaseModel.h
//  everything-about-objc
//
//  Created by Bin Yu on 23/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaseModel : NSObject

@property(nonatomic, strong) NSString *displayName;
@property(nonatomic, assign) SEL caseSelector;

- (instancetype)initWithDiaplayName:(NSString *)displayName
                       caseSelector:(SEL)selector;

@end
