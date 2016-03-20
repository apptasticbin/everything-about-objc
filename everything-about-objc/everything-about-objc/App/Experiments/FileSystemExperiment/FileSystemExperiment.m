//
//  FileSystemExperiment.m
//  everything-about-objc
//
//  Created by Bin Yu on 20/03/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "FileSystemExperiment.h"

@implementation FileSystemExperiment

+ (NSString *)displayName {
    return @"File System";
}

+ (NSString *)displayDesc {
    return @"Try out sandbox file system and file operation in iOS";
}

#pragma mark - Experiment Cases

- (void)BasicFileSystemExperimentCase {
    /**
     Common-used directory
     - AppName.app: This is the app’s bundle. This directory contains the app and all of its resources.
     You cannot write to this directory.
     - Documents/: Use this directory to store user-generated content. The contents of this directory can 
     be made available to the user through file sharing; therefore, his directory should only contain 
     files that you may wish to expose to the user. The contents of this directory are backed up by iTunes.
     - Documents/Inbox: Use this directory to access files that your app was asked to open by outside entities.
     Specifically, the Mail program places email attachments associated with your app in this directory.
     - Library/: This is the top-level directory for any files that are not user data files. You typically 
     put files in one of several standard subdirectories. iOS apps commonly use the Application Support and 
     Caches subdirectories; however, you can create custom subdirectories.
     - tmp/: Use this directory to write temporary files that do not need to persist between launches of your app. 
     Your app should remove files from this directory when they are no longer needed; however, the system may 
     purge this directory when your app is not running.
     
     - Remember that files in Documents/ and Application Support/ are backed up by default.
     - Put data cache files in the Library/Caches/ directory. Cache data can be used for any data that needs 
     to persist longer than temporary data, but not as long as a support file (performance improvement)
     */
    
    /**
      NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde)
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *applicationSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *cacheURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    
    MLog(@"Document URL: %@", documentsURL);
    MLog(@"Application support URL: %@", applicationSupportURL);
    MLog(@"Cache URL: %@", cacheURL);
    MLog(@"Temp directory path: %@", NSTemporaryDirectory());
    
    NSDirectoryEnumerator *documentDirectoryEnumerator =
    [fileManager enumeratorAtURL:documentsURL includingPropertiesForKeys:@[NSURLIsRegularFileKey]
                         options:NSDirectoryEnumerationSkipsSubdirectoryDescendants |
                                 NSDirectoryEnumerationSkipsHiddenFiles
                    errorHandler:^BOOL(NSURL *url, NSError *error) {
                        MLog(@"Error happens at URL %@: %@", url, error.localizedDescription);
                        return YES;
                    }];
    // enumerate files in Document directory
    for (NSURL *url in documentDirectoryEnumerator) {
        NSNumber *isRegularFile = nil;
        [url getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:NULL];
        if ([isRegularFile boolValue]) {
            // display file names
            NSString *localizedName = nil;
            [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
            MLog(@"Found file '%@' at URL %@", localizedName, url);
            // display last modified date
            /**
             [documentDirectoryEnumerator fileAttributes] returns nil
             - Probably because that the URL is not 'Directory' URL
             */
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:url.path error:NULL];
            // [fileAttributes fileModificationDate];
            NSDate * modifiedDate = [fileAttributes objectForKey:NSFileModificationDate];
            MLog(@"Modified date: %@", modifiedDate);
            
            NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*2];
            if ([yesterday earlierDate:modifiedDate] == yesterday) {
                MLog(@"file %@ is modified in 48 hours", localizedName);
            }
        }
    }
    
    NSArray *contents =
    [fileManager contentsOfDirectoryAtURL:documentsURL
               includingPropertiesForKeys:@[NSURLLocalizedNameKey, NSURLContentModificationDateKey]
                                  options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:NULL];
    MLog(@"Single Batch Operation: %@", contents);
    
    /** The File System Resource Keys
     - [NSURL getResourceValue:forKey] to get resource values
     */
}

- (void)ManagingFilesAndDirectoriesExperimentCase {
    
}

- (void)ReadWriteFileWithoutCoordinatorExperimentCase {
    
}

- (void)UsingFileWrapperAsContainerExperimentCase {
    
}

@end
