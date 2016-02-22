//
//  DetailViewController.h
//  everything-about-objc
//
//  Created by Bin Yu on 20/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class ExperimentModel;

@interface DetailViewController : BaseTableViewController

@property(nonatomic, strong) ExperimentModel *expModel;

@end
