//
//  ConcurrentExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 06/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ConcurrentExperiment.h"
#import "CustomOperation.h"

/**
 https://www.objc.io/issues/2-concurrency/common-background-practices/
 Operation Queues vs. Grand Central Dispatch
 - operation queues offers 'cancel'
 - operation queues easily handle dependancy
 */

@interface ConcurrentExperiment ()<NSPortDelegate>

@end

@implementation ConcurrentExperiment

+ (NSString *)displayName {
    return @"Concurrent Programming";
}

+ (NSString *)displayDesc {
    return @"Try out Grand Central Dispatch, NSOperation, and Runloop";
}

#pragma mark - Grand Central Dispatch

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

#pragma mark - NSOperation

- (void)NSOperationBasicExperimentCase {
    /**
     http://nshipster.com/nsoperation/
     - An operation queue is the Cocoa equivalent of a concurrent dispatch queue 
     and is implemented by the NSOperationQueue class
     - 'mainQueue' => 'main dispatch queue': The returned queue executes one operation at a time on the app’s main thread
     */
    
    // NSBlockOperation
    static NSBlockOperation *dummyBlockOperation;
    dummyBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block operation started");
        [NSThread sleepForTimeInterval:2];
    }];
    dummyBlockOperation.queuePriority = NSOperationQueuePriorityNormal;
    dummyBlockOperation.completionBlock = ^(void) {
        NSLog(@"block operation ended");
    };
    
    /**
     NOTICE: 
     - Whether the change dictionaries sent in notifications should contain NSKeyValueChangeNewKey and NSKeyValueChangeOldKey entries, respectively
     - Key path name is 'isReady', not 'ready'
     */
    [dummyBlockOperation addObserver:self forKeyPath:@"isReady"
                             options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                             context:NULL];
    
    // NSInvocationOperation
    NSInvocationOperation *dummyInvocationOperation =
    [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationHandler) object:nil];
    dummyInvocationOperation.queuePriority = NSOperationQueuePriorityHigh;
    
    // Custom Operation
    NSString *urlString = @"http://www.facequebeauty.com.au/images/beauty-salon.jpg";
    CustomOperation *dummyCustomOperation =
        [[CustomOperation alloc] initWithImageURL:[NSURL URLWithString:urlString]];
    // prevent cycling reference
    __weak CustomOperation *weakOperation = dummyCustomOperation;
    // cache result image from operation
    __block UIImage *resultImage;
    dummyCustomOperation.completionBlock = ^(void) {
        MLog(@"Custom image downloaded");
        resultImage = weakOperation.image;
    };
    /**
     - By default, operation queue is CONCURRENT queue.
     - main queue is SERIAL queue.
     - An NSOperationQueue does not dequeue an operation until finished changes to true, 
     so it is critical to implement this correctly in subclasses to avoid deadlock
     */
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    // Create dependency for controlling the order of operations
    [dummyBlockOperation addDependency:dummyInvocationOperation];
    [operationQueue addOperation:dummyBlockOperation];
    [operationQueue addOperation:dummyInvocationOperation];
    [operationQueue addOperation:dummyCustomOperation];
    
    // NOTICE: doesn't work on main queue
    [operationQueue waitUntilAllOperationsAreFinished];
    MLog(@"All operations finished");
    [self showResultView:[[UIImageView alloc] initWithImage:resultImage]];
}

#pragma mark - NSRunLoop

/**
 https://www.objc.io/issues/2-concurrency/concurrency-apis-and-pitfalls/
 - A run loop is an event processing loop that you use to schedule
 work and coordinate the receipt of incoming events.
 - The purpose of a run loop is to keep your thread busy when there
 is work to do and put your thread to sleep when there is none
 - A run loop is always bound to one particular thread.
 The main run loop associated with the main thread has a central role
 in each Cocoa and CocoaTouch application, because it handles UI events, timers,
 and other kernel events.
 - Whenever you 'schedule a timer', use a 'NSURLConnection'. or call
 'performSelector:withObject:afterDelay:', the run loop is used behind
 the scenes in order to perform these asynchronous tasks
 - add at least one input source to it. If a run loop has no input sources configured,
 every attempt to run it will exit immediately
 */

/**
 - your code provides the while or for loop that drives the run loop.
 - Within your loop, you use a run loop object to "run” the event-processing
 code that receives events and calls the installed handlers
 - input source & time source
 - A run loop mode is a collection of input sources and timers to be monitored
 and a collection of run loop observers to be notified
 - a default mode and several commonly used modes
 - must be sure to add one or more input sources, timers,
 or run-loop observers to any modes you create for them to be useful
 - Perform Selector Sources: 'performSelector:withObject:afterDelay:'
 - The run loop processes ALL queued perform selector calls each time through the loop,
 rather than processing one during each loop iteration
 - The run method of UIApplication in iOS starts an application’s main loop as part of the normal startup sequence
 */

- (void)NSRunLoopPortBasedInputSourceExperimentCase {
    // port-based input source
    // NOTICE: http://stackoverflow.com/questions/12384210/is-nsportmessage-in-the-ios-api
    NSPort *dummyMasterPort = [NSMachPort port];
    dummyMasterPort.delegate = self;
    if (dummyMasterPort) {
        NSRunLoop *dummyRunLoop = [NSRunLoop currentRunLoop];
        [dummyRunLoop addPort:dummyMasterPort forMode:NSDefaultRunLoopMode];
    }
}

- (void)NSRunLoopTimerInputSourceExperimentCase {
    // Manually add timer to run loop
    NSRunLoop *dummyRunLoop = [NSRunLoop currentRunLoop];
    NSDate *afterOneSecond = [NSDate dateWithTimeIntervalSinceNow:1.0f];
    NSTimer *dummyTimer =
        [[NSTimer alloc] initWithFireDate:afterOneSecond
                                 interval:0.5f
                                   target:self
                                 selector:@selector(timerHandler)
                                 userInfo:nil
                                  repeats:YES];
    MLog(@"Added timer to current run loop");
    [dummyRunLoop addTimer:dummyTimer forMode:NSDefaultRunLoopMode];
    
    // use NSTimer class method
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(timerHandler)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    id newValue = change[NSKeyValueChangeNewKey];
    MLog(@"Value of key path '%@' of object '%@': %@", keyPath, NSStringFromClass([object class]), newValue);
}

#pragma mark - Private

- (void)timerHandler {
    static NSInteger counter = 0;
    MLog(@"tic toc %ld", ++counter);
}

- (void)invocationOperationHandler {
    NSLog(@"invocation operation started");
    [NSThread sleepForTimeInterval:4];
    NSLog(@"invocation operation ended");
}

@end
