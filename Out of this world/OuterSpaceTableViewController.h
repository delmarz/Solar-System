//
//  OuterSpaceTableViewController.h
//  Out of this world
//
//  Created by delmarz on 1/22/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSpaceViewController.h"

@interface OuterSpaceTableViewController : UITableViewController <AddSpaceViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *planets;
@property (strong, nonatomic) NSMutableArray *addedSpace;
- (IBAction)addBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
