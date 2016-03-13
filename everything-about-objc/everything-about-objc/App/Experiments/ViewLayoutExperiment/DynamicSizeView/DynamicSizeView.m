//
//  DynamicSizeView.m
//  everything-about-objc
//
//  Created by Bin Yu on 12/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DynamicSizeView.h"
#import "MLog.h"

@implementation DynamicSizeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dummyLabel.numberOfLines = 0;
    self.dummyLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

#pragma mark - Layout overrides

- (void)layoutSubviews {
    MARK;
    /**
     http://stackoverflow.com/questions/12789013/ios-multi-line-uilabel-in-auto-layout
     
     https://www.objc.io/issues/3-views/advanced-auto-layout-toolbox/#intrinsic-content-size
     - The first call to [super layoutSubviews] is necessary for the label to get its frame set, 
     while the second call is necessary to update the layout after the change. If we omit the second
     call we get a NSInternalInconsistencyException error, because we’ve made changes in the layout pass 
     which require updating the constraints, but we didn’t trigger layout again
     */
    [super layoutSubviews];
    self.dummyLabel.preferredMaxLayoutWidth = self.frame.size.width;
    [super layoutSubviews];
}

- (void)updateConstraints {
    MARK;
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize {
    /**
     - Custom views typically have content that they display of ### which the layout system is UNAWARE ###.
     Overriding this method allows a custom view to communicate to the layout system what size it
     would like to be based on its content. This intrinsic size must be independent of the content frame,
     because there’s no way to dynamically communicate a changed width to the layout system based on a changed height
     */
    MARK;
    return [super intrinsicContentSize];
}

@end
