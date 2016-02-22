//
//  CaseTableViewCell.m
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CaseTableViewCell.h"

@implementation CaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end
