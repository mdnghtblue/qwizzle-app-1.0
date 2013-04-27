//
//  QWZShareQwizzleViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZShareQwizzleViewController.h"

@interface QWZShareQwizzleViewController ()

@end

@implementation QWZShareQwizzleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for (int row = 0; row < [[self tableView] numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:cellPath];
        //do stuff with 'cell'
        
        [cell setAccessibilityElementsHidden:YES];
    }
    
    [[self tableView] cellForRowAtIndexPath:0];
}

// Implement this method to respond when the user is tapping any row
// Basically it should switch to another view and load all the corresponding information
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath at %@", indexPath);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *name = cell.textLabel.text;
    
    if ([cell accessibilityElementsHidden]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell setAccessibilityElementsHidden:NO];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setAccessibilityElementsHidden:YES];
    }
    
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"The user is selecting %@", name);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
