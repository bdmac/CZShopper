//
//  ShoppingListItem.h
//  CZShopper
//
//  Created by Brian McManus on 11/16/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListItem : NSManagedObject

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *category;

@end
