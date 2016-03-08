//
//  CustomOperation.m
//  everything-about-objc
//
//  Created by Bin Yu on 08/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CustomOperation.h"
#import "MLog.h"

/**
 https://developer.apple.com/library/mac/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html#//apple_ref/doc/uid/TP40008091-CH101-SW16
 - Operation objects execute in a synchronous manner by default—that is,
 they perform their task in the thread that calls their start method. 
 Because operation queues provide threads for nonconcurrent operations, 
 though, most operations still run asynchronously
 - If you override the start method or do any significant customization of an NSOperation 
 object other than override main, you must ensure that your custom object remains KVO compliant 
 for these key paths. When overriding the start method, the key paths you should be 
 most concerned with are isExecuting and isFinished. These are the key paths most commonly 
 affected by reimplementing that method
 */

@interface CustomOperation ()

@property(nonatomic, strong) NSURL *imageURL;

@end

@implementation CustomOperation

- (instancetype)initWithImageURL:(NSURL *)imageURL {
    self = [super init];
    if (self) {
        _imageURL = imageURL;
    }
    return self;
}

- (void)main {
    if (![self isCancelled]) {
        MLog(@"Custom image download started");
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        self.image = image;
    }
}

@end
