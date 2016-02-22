//
//  ExperimentTableViewCell.m
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ExperimentTableViewCell.h"

@implementation ExperimentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.detailsLabel.numberOfLines = 0;
}

@end
