//
//  ItemDetailsViewController.h
//  CZShopper
//
//  Created by Brian McManus on 11/17/12.
//  Copyright (c) 2012 Brian McManus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListItem.h"

@protocol ItemDetailsControllerDelegate <NSObject>
@required
- (void)didCancelEdit:(ShoppingListItem *)item;
- (void)didSave:(ShoppingListItem *)item;
- (void)didDelete:(ShoppingListItem *)item;
@end

@interface ItemDetailsViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id<ItemDetailsControllerDelegate> delegate;
@property (strong, nonatomic) ShoppingListItem *item;
@property (strong, nonatomic) IBOutlet UITextField *itemName;
@property (strong, nonatomic) IBOutlet UITextField *itemCategory;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)savePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;
@end
