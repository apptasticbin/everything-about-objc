//
//  DynamicSizeView.h
//  everything-about-objc
//
//  Created by Bin Yu on 12/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicSizeView : UIView

@property (weak, nonatomic) IBOutlet UIView *dummyView;
@property (weak, nonatomic) IBOutlet UILabel *dummyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dummyViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLabelVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dummyLabelBottomConstraint;


@end
