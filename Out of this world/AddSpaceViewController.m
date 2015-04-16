//
//  AddSpaceViewController.m
//  Out of this world
//
//  Created by delmarz on 1/23/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "AddSpaceViewController.h"

@interface AddSpaceViewController ()

@end

@implementation AddSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"Orion.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addButtonPressed:(UIButton *)sender {
    
    [self.delegate addSpace:[self returnNewSpaceObject]];
    
    
  
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.delegate didCancel];
    
}


-(SpaceObject *)returnNewSpaceObject
{
    SpaceObject *addSpaceObject = [[SpaceObject alloc] init];
    
    addSpaceObject.name = self.nameTextField.text;
    addSpaceObject.nickname = self.nicknameTextField.text;
    addSpaceObject.diameter = [self.diameterTextField.text floatValue];
    addSpaceObject.temperature = [self.temperatureTextField.text floatValue];
    addSpaceObject.numberOfMoons = [self.numberOfMoonsTextField.text intValue];
    addSpaceObject.interestingFacts = self.interestingFactsTextField.text;
    
    addSpaceObject.planetImage = [UIImage imageNamed:@"EinsteinRing.jpg"];
    return addSpaceObject;
    
    
}



@end
