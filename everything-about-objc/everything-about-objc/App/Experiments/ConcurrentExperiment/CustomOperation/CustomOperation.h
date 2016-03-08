//
//  CustomOperation.h
//  everything-about-objc
//
//  Created by Bin Yu on 08/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomOperation : NSOperation

@property(nonatomic, strong) UIImage *image;

- (instancetype)initWithImageURL:(NSURL *)imageURL;

@end
