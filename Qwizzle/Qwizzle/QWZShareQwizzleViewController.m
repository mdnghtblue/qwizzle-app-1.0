//
//  QWZShareQwizzleViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZShareQwizzleViewController.h"
#import "QWZQuizSet.h"
#import "QWZQwizzleStore.h"
#import "JSONContainer.h"

@interface QWZShareQwizzleViewController ()

@end

@implementation QWZShareQwizzleViewController

@synthesize quizSet;
@synthesize adView; // handle iAd


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
    
    // setting the iAd
    adView.delegate=self;
    [adView setHidden:YES]; // setting the defualt behvior for iAd
    

    
    // Hard-coded cellcount (we have fix number of friends)
    cellCount = 3;
    for (int row = 0; row < [[self tableView] numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:cellPath];
        [cell setAccessibilityElementsHidden:YES];
    }

    NSLog(@"Receiving a Qwizzle to share: %@ with ID:%d", [[self quizSet] title], [[self quizSet] quizSetID]);
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

- (IBAction)shareAQwizzle:(id)sender
{
    NSLog(@"shareAQwizzle");
    
    NSInteger count = 0;
    NSMutableArray *user_id = [[NSMutableArray alloc] init];
    for (int row = 0; row < [[self tableView] numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:cellPath];
        NSString *name = cell.textLabel.text;
        
        if (![cell accessibilityElementsHidden]) {
            NSLog(@"Sharing to %@ who has the user id of %d", name, cell.tag);
            count++;
            
            [user_id addObject:[[NSString alloc] initWithFormat:@"%d", cell.tag]];
        }
    }
    
    if (count == 0) {
        // If things went bad, show an alert view to users
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You should select some of your friends." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else {
        // Prepare to connect to the web service
        // Get ahold of the segmented control that is currently in the title view
        UIView *currentTitleView = [[self navigationItem] titleView];
        
        // Create an activity indicator while loading
        UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [[self navigationItem] setTitleView:aiView];
        [aiView startAnimating];
        
        // The codeblock to run after the connection finish loading
        void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
            
            // Replaces the activity indicator with the previous title
            [[self navigationItem] setTitleView:currentTitleView];
            
            if (!err) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"Your Qwizzle has been sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
                
                // Dismiss this view
                [self.navigationController popViewControllerAnimated:YES];

            } else {
                // If things went bad, show an alert view to users
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        }; // Finish declaring a code block to run after finish running the connection
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [defaults objectForKey:@"user_id"];
        [[QWZQwizzleStore sharedStore] shareAQwizzle:[quizSet quizSetID] WithUserID:user_id AndSenderID:userID WithCompletion:completionBlock];
    }
}

#pragma mark - Handle table view datasource
// One of the required methods needed to be implemented to use UITableViewController
// - Return a cell at the given index
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We can ignore this stuff, it's just that everybody is doing this when they use UITableView
    static NSString *QWizzleCellIdentifier = @"QWizzleCell";
    
    // Check for a reusable cell first, use that if it exists
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QWizzleCellIdentifier];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:QWizzleCellIdentifier];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    if ([indexPath row] == 0 && ![userID isEqualToString:@"1"]) {
        [[cell textLabel] setText:@"Stephanie Day"];
        cell.tag = 1;
        return cell;
    }
    else if ([indexPath row] == 1 && ![userID isEqualToString:@"2"]) {
        [[cell textLabel] setText:@"Krissada Dechokul"];
        cell.tag = 2;
        return cell;
    }
    else if ([indexPath row] == 2 && ![userID isEqualToString:@"3"]) {
        [[cell textLabel] setText:@"Baneen Al Mubarak"];
        cell.tag = 3;
        return cell;
    }
    else{
        return cell;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Remove empty cell
    NSString *cellText = nil;
    for (int row = 0; row < [[self tableView] numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:cellPath];
        [cell setAccessibilityElementsHidden:YES];
        
        cellText = cell.textLabel.text;
        if ([cellText isEqualToString:@""] || cellText == nil) {
            cellCount--;
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

// One of the required methods needed to be implemented to use UITableViewController
// - Return the number of rows given a section number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellCount;
}

// Return the number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark iAd view
// Implement this method if iAd is load to be set only if it has adv
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [adView setHidden:NO]; // show iAd view when avialble
    NSLog(@"iAd showing");
    
    
}
// Implement this method if there is an error for governer Ad
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [adView setHidden:YES]; // hide iAd when there is an error
    NSLog(@"iAd is hidden");
}
@end
