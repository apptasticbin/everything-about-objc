//
//  ViewGeometricViewController.h
//  everything-about-objc
//
//  Created by Bin Yu on 27/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewGeometricViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// Labels
@property (weak, nonatomic) IBOutlet UILabel *frameXLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameYLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *boundsXLabel;
@property (weak, nonatomic) IBOutlet UILabel *boundsYLabel;
@property (weak, nonatomic) IBOutlet UILabel *boundsWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *boundsHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerXLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerYLabel;
@property (weak, nonatomic) IBOutlet UILabel *rotationLabel;

@end
