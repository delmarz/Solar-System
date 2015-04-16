//
//  AddSpaceViewController.h
//  Out of this world
//
//  Created by delmarz on 1/23/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpaceObject.h"


@protocol AddSpaceViewControllerDelegate <NSObject>

@required
-(void)addSpace:(SpaceObject *)spaceObject;
-(void)didCancel;

@end


@interface AddSpaceViewController : UIViewController
@property (weak, nonatomic) id <AddSpaceViewControllerDelegate> delegate;


@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (strong, nonatomic) IBOutlet UITextField *diameterTextField;
@property (strong, nonatomic) IBOutlet UITextField *temperatureTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberOfMoonsTextField;
@property (strong, nonatomic) IBOutlet UITextField *interestingFactsTextField;



- (IBAction)addButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;




@end
