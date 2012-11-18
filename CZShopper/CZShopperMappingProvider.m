//
//  RKGHMappingProvider.m
//  RKGithub
//
//  Created by Blake Watters on 2/16/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "CZShopperMappingProvider.h"
#import "ShoppingListItem.h"

@implementation CZShopperMappingProvider

@synthesize objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];
}

// Sets up various aspects of RestKit's object manager and mappings.
- (id)initWithObjectStore:(RKManagedObjectStore *)theObjectStore {
    self = [super init];
    if (self) {
        self.objectStore = theObjectStore;
        
        [[RKObjectManager sharedManager].router routeClass:[ShoppingListItem class] toResourcePath:@"/items/:identifier"];
        [[RKObjectManager sharedManager].router routeClass:[ShoppingListItem class] toResourcePath:@"/items.json" forMethod:RKRequestMethodPOST];
        [self addObjectMapping:[self shoppingListItemObjectMapping]];
        [self setObjectMapping:[self shoppingListItemObjectMapping] forResourcePathPattern:@"/items.json" withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            NSFetchRequest *fetchRequest = [ShoppingListItem fetchRequest];
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
            return fetchRequest;
        }];
        [self setSerializationMapping:[[self shoppingListItemObjectMapping] inverseMapping] forClass:[ShoppingListItem class]];
    }
    
    return self;
}

// Not strictly necessary in this implementation but would conceivably have
// similar methods for other data models.
- (RKManagedObjectMapping *)shoppingListItemObjectMapping {
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForClass:[ShoppingListItem class] inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapKeyPathsToAttributes:
         @"id", @"identifier",
         @"name", @"name",
         @"category", @"category",
         nil];
    
    return mapping;
}

@end
