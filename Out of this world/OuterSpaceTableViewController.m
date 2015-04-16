//
//  OuterSpaceTableViewController.m
//  Out of this world
//
//  Created by delmarz on 1/22/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "OuterSpaceTableViewController.h"
#import "AstronomicalData.h"
#import "SpaceObject.h"
#import "ImageSpaceViewController.h"
#import "DataSpaceViewController.h"
#import "AddSpaceViewController.h"

@interface OuterSpaceTableViewController ()

@end

@implementation OuterSpaceTableViewController
#define ADDED_SPACE_OBJECT_KEY @"added space object array"

#pragma mark - Lazy Instantiation of properties

-(NSMutableArray *)planets
{
    if (!_planets) {
        _planets = [[NSMutableArray alloc] init];
    }
    return _planets;
}

-(NSMutableArray *)addedSpace
{
    if (!_addedSpace) {
        _addedSpace = [[NSMutableArray alloc] init];
    }
    return _addedSpace;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    for (NSDictionary *planetData in [AstronomicalData allKnownPlanets]) {
        NSString *planetImage = [NSString stringWithFormat:@"%@.jpg", planetData [PLANET_NAME]];
        SpaceObject *spaceObject = [[SpaceObject alloc]initWithData:planetData andImage:[UIImage imageNamed:planetImage]];
        [self.planets addObject:spaceObject];
    }
    
    NSArray *myPlanetAsPropertyList = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SPACE_OBJECT_KEY];
    for (NSDictionary *dictionary in myPlanetAsPropertyList ) {
        SpaceObject *spaceObject = [self spaceObjectForDictionary:dictionary];
        [self.addedSpace addObject:spaceObject];
    }
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showAddTask" sender:sender];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass: [ImageSpaceViewController class]]) {
        
        ImageSpaceViewController *imageSpaceVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        SpaceObject *selectedObject;
        
        if (indexPath.section == 0) {
            selectedObject =   self.planets[indexPath.row];
        }
        else {
            selectedObject =   self.addedSpace[indexPath.row];
        }
      
        imageSpaceVC.spaceObject = selectedObject;
    }
    else if ([segue.destinationViewController isKindOfClass:[DataSpaceViewController class]]){
        DataSpaceViewController *dataSpaceVC = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        SpaceObject *selectedObject;
        
        if (indexPath.section == 0) {
            selectedObject = self.planets[indexPath.row];
        }
        else {
            selectedObject = self.addedSpace[indexPath.row];
        }
        
        dataSpaceVC.spaceObject = selectedObject;
    }
    else if ([segue.destinationViewController isKindOfClass:[AddSpaceViewController class]]) {
        AddSpaceViewController *addSpaceVC = segue.destinationViewController;
        addSpaceVC.delegate = self;
    }
    
}


#pragma mark - AddSpaceViewController Delegate

-(void)addSpace:(SpaceObject *)spaceObject
{
    

    [self.addedSpace addObject:spaceObject];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:true completion:nil];
    
    NSMutableArray *spaceObjectAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SPACE_OBJECT_KEY] mutableCopy];
    if (!spaceObjectAsPropertyList) {
        spaceObjectAsPropertyList = [[NSMutableArray alloc] init];
    }
    [spaceObjectAsPropertyList addObject:[self spaceObjectAsPropertyList:spaceObject]];
    [[NSUserDefaults standardUserDefaults] setObject:spaceObjectAsPropertyList forKey:ADDED_SPACE_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)didCancel
{
    [self dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark - Helper Methods

-(NSDictionary *)spaceObjectAsPropertyList:(SpaceObject *)spaceObject
{
    NSData *imageData = UIImagePNGRepresentation(spaceObject.planetImage);
    NSDictionary *dictionary = @{PLANET_NAME: spaceObject.name,
                                 PLANET_GRAVITY: @(spaceObject.gravitationalForce),
                                 PLANET_DIAMETER: @(spaceObject.diameter),
                                 PLANET_YEAR_LENGTH: @(spaceObject.yearLength),
                                 PLANET_DAY_LENGTH: @(spaceObject.dayLength),
                                 PLANET_TEMPERATURE: @(spaceObject.temperature),
                                 PLANET_NUMBER_OF_MOONS: @(spaceObject.numberOfMoons),
                                 PLANET_NICKNAME: spaceObject.nickname,
                                 PLANET_INTERESTING_FACT: spaceObject.interestingFacts,
                                 PLANET_IMAGE: imageData
                                 
                                 };
    return dictionary;
}

-(SpaceObject *)spaceObjectForDictionary:(NSDictionary *)dictionary
{
    
    NSData *image = dictionary[PLANET_IMAGE];
    UIImage *spaceObjectImage = [UIImage imageWithData:image];
    SpaceObject *spaceObject = [[SpaceObject alloc] initWithData:dictionary andImage:spaceObjectImage];
    
    return spaceObject;
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    
    if (self.addedSpace.count) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    if (section == 1) {
        return self.addedSpace.count;
    }
    else {
        return self.planets.count;
    }
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.section == 1) {
        
        SpaceObject *planets = [self.addedSpace objectAtIndex:indexPath.row];
        
        cell.textLabel.text = planets.name;
        cell.detailTextLabel.text = planets.nickname;
        cell.imageView.image = planets.planetImage;
        
        
    }
    else
    {
        SpaceObject *planets = [self.planets objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text = planets.name;
        cell.detailTextLabel.text = planets.nickname;
        cell.imageView.image = planets.planetImage;
        
        
    }
    
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    return cell;
    
    
  
    
}




#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDataSpace" sender:indexPath];
    NSLog(@"this is index %li", indexPath.row);
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    if (indexPath.section == 1) {
        return YES;
    }
    else{
        return NO;
    }
    
    
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
       
        [self.addedSpace removeObjectAtIndex:indexPath.row];
        
    
        NSMutableArray *newSaveSpaceObjectData = [[NSMutableArray alloc] init];
        for (SpaceObject *spaceObject in self.addedSpace) {
            [newSaveSpaceObjectData addObject:[self spaceObjectAsPropertyList:spaceObject]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:newSaveSpaceObjectData forKey:ADDED_SPACE_OBJECT_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
      
        
        
        
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}






/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
