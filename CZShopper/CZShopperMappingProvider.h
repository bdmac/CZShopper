//
//  CZShopperMappingProvider.h
//  CZShopper
//
//  Created by Brian McManus on 11/17/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import "RKObjectMappingProvider.h"

@interface CZShopperMappingProvider : RKObjectMappingProvider

@property (nonatomic, strong) RKManagedObjectStore *objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore;

- (id)initWithObjectStore:(RKManagedObjectStore *)objectStore;

/**
 Create and return a RestKit object mapping suitable for mapping a CZ Shopping List Item
 resource.
 
 @return A RKObjectMapping suitable for mapping a CZ Shopping List Item issue.
 */
- (RKManagedObjectMapping *)shoppingListItemObjectMapping;

@end
