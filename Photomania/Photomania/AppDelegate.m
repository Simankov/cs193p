//
//  AppDelegate.m
//  Photomania
//
//  Created by admin on 24/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "AppDelegate+MOC.h"
#import "PhotoDatabaseAvailability.h"

@interface AppDelegate () <NSURLSessionDownloadDelegate>
@property (copy,nonatomic) void (^flickrDownloadBackgroudURLSessionCompletionHandler)();
@property (strong,nonatomic) NSURLSession *flickrDownloadSession;
@property (strong,nonatomic) NSTimer *flickrForegroundFetchTimer;
@property (strong,nonatomic) NSManagedObjectContext *photoDatabaseContext;
@end

#define FLICKR_FETCH @"Flickr Just Uploaded Fetch"

//how often we fetch photos if we in background
#define FOREGROUND_FLICKR_FETCH_INTERVAL (20*60)

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.photoDatabaseContext = [self createMainQueueManagedObjectContext];
    [self startFlickrFetch];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)setPhotoDatabaseContext:(NSManagedObjectContext *)photoDatabaseContext{
    _photoDatabaseContext  = photoDatabaseContext;
    
    NSDictionary *userInfo = photoDatabaseContext?@{PhotoDatabaseAvailabilityNotificationContext:photoDatabaseContext}:nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification object:self userInfo:userInfo];
}

-(void)startFlickrFetch{
    [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (![downloadTasks count]){
            NSURLSessionDownloadTask *task = [self.flickrDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = FLICKR_FETCH;
            [task resume];
        } else {
            for (NSURLSessionDownloadTask *task in downloadTasks) [task resume];
        }
    }];
}
-(NSArray *)flickrPhotosFromURL: (NSURL *) photoURL{
    NSData * photoJSONData = [[NSData alloc]initWithContentsOfURL:photoURL];
    NSDictionary * photoPropertyList = [NSJSONSerialization JSONObjectWithData:photoJSONData options:0 error:nil];
    return [photoPropertyList valueForKeyPath: FLICKR_RESULTS_PHOTOS];
}

- (NSURLSession *)flickrDownloadSession{
    if (!_flickrDownloadSession){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:FLICKR_FETCH];
            urlSessionConfig.allowsCellularAccess = NO;
            _flickrDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:self delegateQueue:nil];
        });
    }
 return _flickrDownloadSession;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    if ([[downloadTask taskDescription] isEqualToString:FLICKR_FETCH]){
        NSManagedObjectContext *context = self.photoDatabaseContext;
        if (context){
            NSArray *photos = [self flickrPhotosFromURL:location];
            [context performBlock:^{
                [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
                [context save: NULL];
            }];
        }
    }
}

@end
