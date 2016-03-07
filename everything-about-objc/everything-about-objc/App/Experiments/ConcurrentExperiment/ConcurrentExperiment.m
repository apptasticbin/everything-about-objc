//
//  ConcurrentExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 06/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ConcurrentExperiment.h"

@implementation ConcurrentExperiment

+ (NSString *)displayName {
    return @"Concurrent Programming";
}

+ (NSString *)displayDesc {
    return @"Try out Grand Central Dispatch, NSOperation, and Runloop";
}

- (void)GCDBasicExperimentCase {
    /**
     - GCD provides dispatch queues to handle blocks of code;
     these queues manage the tasks you provide to GCD and execute those tasks in FIFO order
     - Tasks in serial queues execute one at a time, each task starting only after the preceding task has finished. 
     - Since no two tasks in a serial queue can ever run concurrently, 
     there is no risk they might access the same critical section concurrently; 
     that protects the critical section from race conditions with respect to those tasks only
     - Tasks in concurrent queues are guaranteed to start in the order they were added…and that’s about all you’re guaranteed
     - you have at least five queues at your disposal: the main queue, 
     four global dispatch queues, plus any custom queues that you add
     - The system also provides you with several concurrent queues. 
     These are known as the Global Dispatch Queues. 
     There are currently four global queues of different priority: background, low, default, and high
     */
    UIView *rootView = [self rootView];
    UIView *imageView = [self dummyViewAtPosition:CGPointMake(CGRectGetMidX(rootView.frame),
                                                              CGRectGetMidY(rootView.frame))
                                            inView:rootView withColor:[UIColor redColor]];
    /**
     - main queue: serial queue
     - global queues: concurrent queues
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        MLog(@"Fetching image from remote server");
        UIImage *image = [self dummyImage];
        MLog(@"Image downloaded");
        /**
         [NSThread sleepForTimeInterval:1]
         */
        dispatch_time_t oneSecondDelay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        /**
         dispatch_async
         */
        dispatch_after(oneSecondDelay, dispatch_get_main_queue(), ^{
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"opacity";
            animation.fromValue = @(0);
            animation.toValue = @(1);
            animation.duration = 1.0f;
            [imageView.layer addAnimation:animation forKey:@"opacity"];
            imageView.layer.contents = (id)[image CGImage];
        });
        MLog(@"Waiting for animation");
    });
    [self showResultView:rootView];
}

- (void)GCDBarrierExperimentCase {
    /**
     - the classic software development Readers-Writers Problem.
     GCD provides an elegant solution of creating a Readers-writer lock using dispatch barriers
     - Dispatch barriers are a group of functions acting as a serial-style bottleneck when working with concurrent queues. 
     - Using GCD’s barrier API ensures that the submitted block is the only item executed on the specified queue for that particular time.
     - barriers won’t do anything helpful since a serial queue
     */
    static dispatch_queue_t dummyConcurrentQueue;
    dummyConcurrentQueue = dispatch_queue_create("com.queue.dummy", DISPATCH_QUEUE_CONCURRENT);
    
    NSMutableArray *dummyArray = [NSMutableArray arrayWithArray:@[@"adb", @"efg", @"123"]];
    dispatch_async(dummyConcurrentQueue, ^{
        MLog(@"Pending for changing dummy array");
        [NSThread sleepForTimeInterval:2];
        [dummyArray addObject:@"new object"];
        MLog(@"new object added");
    });
    dispatch_barrier_async(dummyConcurrentQueue, ^{
        MLog(@"Barrier for adding one more item to dummy array");
        [dummyArray addObject:@"one more object"];
        MLog(@"one more object added");
    });
    MLog(@"Stop here");
    dispatch_sync(dummyConcurrentQueue, ^{
        MLog(@"Dummy array: %@", dummyArray);
    });
}

- (void)GCDCustomQueueExperimentCase {
    /**
     - 'dispatch_sync' with Custom Serial Queue: Be VERY careful in this situation;
     if you’re running in a queue and call dispatch_sync targeting the same queue, 
     you will definitely create a deadlock
     */
    
}

- (void)GCDGroupExperimentCase {
    MLog(@"Create dispatch group");
    dispatch_group_t dummyGroup = dispatch_group_create();
    /**
     dispatch_apply
     - synchronous function
     - it NOT a good idea to use serial queue with dispatch_apply. use for loop instead
     - concurrent queue works well with dispatch_apply
     - You should use dispatch_apply for iterating over very LARGE sets along with the appropriate stride length
     */
    dispatch_apply(3, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t idx) {
        MLog(@"Task %zu started", idx);
        dispatch_group_enter(dummyGroup);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // random sleep time between 1 and 3-1+1
            [NSThread sleepForTimeInterval:arc4random_uniform(3)+1];
            MLog(@"Task %zu finished", idx);
            dispatch_group_leave(dummyGroup);
        });
    });
    dispatch_group_wait(dummyGroup, DISPATCH_TIME_FOREVER);
    MLog(@"All tasks done");
}

- (void)GCDSemaphoreExperimentCase {
    /**
     https://www.raywenderlich.com/63338/grand-central-dispatch-in-depth-part-2
     */
    dispatch_semaphore_t dummySemaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MLog(@"start some tasks");
        [NSThread sleepForTimeInterval:2.0];
        MLog(@"tasks done, give semaphore access capacity");
        // This increments the semaphore count and signals that the semaphore is available to other resources that want it
        dispatch_semaphore_signal(dummySemaphore);
    });
    // A non-zero return code from this function means that the timeout was reached
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
    if (dispatch_semaphore_wait(dummySemaphore, timeout)) {
        MLog(@"time out");
        return;
    }
    MLog(@"Here we go!");
}

- (void)GCDDispatchSourceExperimentCase {
    
}

@end
