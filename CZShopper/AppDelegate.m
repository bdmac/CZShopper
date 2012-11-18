//
//  AppDelegate.m
//  CZShopper
//
//  Created by Brian McManus on 11/16/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import "AppDelegate.h"
#import "CZShopperMappingProvider.h"

@interface AppDelegate ()
@property (strong, nonatomic, readwrite) RKObjectManager *objectManager;
@property (strong, nonatomic, readwrite) RKManagedObjectStore *objectStore;
@end


@implementation AppDelegate

@synthesize objectManager, objectStore;

- (void)initializeRestKit {
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://czshopper.herokuapp.com/"];
    self.objectManager.serializationMIMEType = RKMIMETypeJSON;
    [self.objectManager.client setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.objectManager.client setValue:@"ny7XEgvghDuywJzqXBQU" forHTTPHeaderField:@"X-CZ-Authorization"];
    self.objectManager.mappingProvider.errorMapping.rootKeyPath = @"error";
    self.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"CZShopper.sqlite"];
    self.objectManager.objectStore = self.objectStore;
    self.objectManager.mappingProvider = [CZShopperMappingProvider mappingProviderWithObjectStore:self.objectStore];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    RKLogInitialize();
    RKLogConfigureFromEnvironment();
    [self initializeRestKit];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (! [self.objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

@end
