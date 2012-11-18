//
//  ListItemsTableViewController.h
//  CZShopper
//
//  Created by Brian McManus on 11/16/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import <RestKit/UI.h>
#import "ItemDetailsViewController.h"

@interface ListItemsTableViewController : UITableViewController <RKFetchedResultsTableControllerDelegate, ItemDetailsControllerDelegate>

@end
