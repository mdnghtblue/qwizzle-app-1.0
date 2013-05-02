//
//  QWZQwizzleViewController.m
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZQwizzleViewController.h"

#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAnsweredQuizSet.h"
#import "QWZCreateQwizzleViewController.h"
#import "QWZTakeQwizzleViewController.h"
#import "QWZViewQwizzleViewController.h"

#import "QWZQwizzleStore.h"
#import "JSONContainer.h"

@interface QWZQwizzleViewController ()

@end

@implementation QWZQwizzleViewController

@synthesize reloadFlag;
@synthesize adView;


#pragma mark - Default App's Behavior
// Implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting the iAd
    adView.delegate=self;
    [adView setHidden:YES]; // setting the defualt behvior for iAd
    
    
    // Loading sample data
    // Initialize the 2 quiz sets here
    allQuizSets = [[NSMutableArray alloc] init];
    allAnsweredQuizSets = [[NSMutableArray alloc] init];
    allRequestedQuizSet = [[NSMutableArray alloc] init];
    
//    // Add hard-coded question set here
//    QWZQuiz *q1 = [[QWZQuiz alloc] initWithQuestion:@"What is your name?"];
//    QWZQuiz *q2 = [[QWZQuiz alloc] initWithQuestion:@"What is your last name?"];
//    
//    QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"Sample Qwizzle"];
//    [qs1 addQuiz:q1];
//    [qs1 addQuiz:q2];
//    
//    QWZQuizSet *qs2 = [[QWZQuizSet alloc] initWithTitle:@"Sample Qwizzle Pack 2"];
//    [qs2 addQuiz:q1];
    
    QWZQuiz *q3 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite color?" answer:@"Green"];
    QWZQuiz *q4 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite food?" answer:@"Fried Rice"];
    QWZQuiz *q5 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite sport?" answer:@"Table Tennis"];
    QWZAnsweredQuizSet *aqs1 = [[QWZAnsweredQuizSet alloc] initWithTitle:@"My favorite things"];
    [aqs1 setCreatorID:2];
    [aqs1 addQuiz:q3];
    [aqs1 addQuiz:q5];
    [aqs1 addQuiz:q4];
    
    // Add hard-coded question set here
    //QWZQuiz *nq1 = [[QWZQuiz alloc] initWithID:13 question:@"Why are you so awesome?" andAnswer:@""];
    //QWZQuiz *nq2 = [[QWZQuiz alloc] initWithID:14 question:@"How do you feel being so awesome?" andAnswer:@""];
    //QWZQuiz *nq3 = [[QWZQuiz alloc] initWithID:15 question:@"What would you do next?" andAnswer:@""];
    
    QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"How to be awesome"];
    //[qs1 addQuiz:nq1];
    //[qs1 addQuiz:nq2];
    //[qs1 addQuiz:nq3];
    [qs1 setQuizSetID:19];
    
    QWZQuiz *nq4 = [[QWZQuiz alloc] initWithID:7 question:@"What do you think about apples?" andAnswer:@""];
    QWZQuiz *nq5 = [[QWZQuiz alloc] initWithID:8 question:@"What do you think about bananas?" andAnswer:@""];
    
    QWZQuizSet *qs2 = [[QWZQuizSet alloc] initWithTitle:@"Favorite Foods 2"];
    [qs2 addQuiz:nq4];
    [qs2 addQuiz:nq5];
    [qs2 setQuizSetID:16];
    
    [allQuizSets addObject:qs1];
    [allQuizSets addObject:qs2];
    [allAnsweredQuizSets addObject:aqs1];
    
    // Get the stored data before the view appear
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    NSLog(@"viewDidLoad QwizzleView - user info:%@",[defaults objectForKey:@"user_id"]);
    
    if (userID == nil) {
        // There is no user information stored on the device yet, redirect to the login page
        [self redirectToLoginPage];
        reloadFlag = YES;
    }
    else {
        // Otherwise, Load all the data associated with this user
        NSLog(@"Loading user's data... ");
        [self reloadAllQwizzles];
        reloadFlag = NO;
    }
}

// Implement this method if there is anything needed to be configure before the view appear on-screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // No toolbar in this view
    self.navigationController.toolbarHidden = NO;
    
    // Get the stored data before the view appear
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    if (userID == nil) {
        // There is no user information stored on the device yet, redirect to the login page
        [self redirectToLoginPage];
        reloadFlag = YES;
    }
    else {
        NSLog(@"The user has already been logined, do nothing");
        if (reloadFlag) {
            [self reloadAllQwizzles];
            reloadFlag = NO;
        }
    }
    
    [[self tableView] reloadData];
}

// This method receives a newly created Qwizzle from the QWZCreateQwizzleController and updates the mainview
- (void)submitAQwizzle:(QWZQuizSet *)quizSet
{
    NSLog(@"A qwizzle has been submitted!! %@", quizSet);
    NSLog(@"There are %d questions for %@", [[quizSet allQuizzes] count], [quizSet title]);
    
    // Prepare to connect to the web service
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // The codeblock to run after the connection finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            // If everything went ok (with no error), grab the object, and reload the table
            NSLog(@"Receiving the Qwizzle ID: %@", [[obj JSON] objectForKey:@"qwizzle_id"]);
            
            // Set the qwizzle_id received from the server into the quizset
            [quizSet setQuizSetID:[[[obj JSON] objectForKey:@"qwizzle_id"] intValue]];

            [allQuizSets addObject:quizSet];
            
            // Adding new Qwizzle (unanswer qwizzle) into the table, this set reside in the section 0
            NSInteger lastRow = [allQuizSets indexOfObject:quizSet];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
            
            // Insert this Qwizzle into the table
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] createAQwizzle:quizSet WithCompletion:completionBlock];
}

// This method receives a newly created Qwizzle from the QWZTakeQwizzleController and updates the mainview
- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers
{
    NSLog(@"Submitting qwizzle answers for qwizzle_id: %d", [qzAnswers quizSetID]);
    
    for (int i = 0; i < [[qzAnswers allQuizzes] count]; i++) {
        NSLog(@"%d) [id=%d] %@/%@", i+1, [[[qzAnswers allQuizzes] objectAtIndex:i] questionID], [[[qzAnswers allQuizzes] objectAtIndex:i] question], [[[qzAnswers allQuizzes] objectAtIndex:i] answer]);
    }
    
    // Prepare to connect to the web service
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // The codeblock to run after the connection finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            
            [allAnsweredQuizSets addObject:qzAnswers];
            
            NSInteger lastRow = [allAnsweredQuizSets indexOfObject:qzAnswers];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:1];
            
            // Insert the new Qwizzle answers into the table
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                                    withRowAnimation:UITableViewRowAnimationTop];
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] takeAQwizzle:qzAnswers WithCompletion:completionBlock];
}

// This method receives a newly created Qwizzle from the QWZTakeQwizzleController and updates the mainview
- (void)fillOutARequestedQwizzle:(QWZAnsweredQuizSet *)qzAnswers
{
    NSLog(@"Submitting requested qwizzle answers for qwizzle_id: %d and requested_id: %d", [qzAnswers quizSetID], [qzAnswers requestID]);
    
    for (int i = 0; i < [[qzAnswers allQuizzes] count]; i++) {
        NSLog(@"%d) [id=%d] %@/%@", i+1, [[[qzAnswers allQuizzes] objectAtIndex:i] questionID], [[[qzAnswers allQuizzes] objectAtIndex:i] question], [[[qzAnswers allQuizzes] objectAtIndex:i] answer]);
    }
    
    // Prepare to connect to the web service
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // The codeblock to run after the connection finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            
            [allAnsweredQuizSets addObject:qzAnswers];
            
            NSInteger lastRow = [allAnsweredQuizSets indexOfObject:qzAnswers];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:1];
            
            // Insert the new Qwizzle answers into the table
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                                    withRowAnimation:UITableViewRowAnimationTop];
            
            [self deleteARequestedQwizzle:qzAnswers];
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] takeAQwizzle:qzAnswers WithCompletion:completionBlock];
}

- (void)deleteARequestedQwizzle:(QWZAnsweredQuizSet *)qzAnswers
{
    // Prepare to connect to the web service
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // The codeblock to run after the connection finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            
            for (int i = 0; i < [allRequestedQuizSet count]; i++) {
                if ([qzAnswers requestID] == [[allRequestedQuizSet objectAtIndex:i] requestID]) {
                    [allRequestedQuizSet removeObjectAtIndex:i];
                    break;
                }
            }
            
            [[self tableView] reloadData];
            
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] deleteARequestedQwizzle:qzAnswers WithCompletion:completionBlock];
}

#pragma mark - Handle table view datasource
// One of the required methods needed to be implemented to use UITableViewController
// - Return a cell at the given index
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the text on the cell with the desciption of the item
    // We need to get the cell from the correct section here
    NSInteger section = [indexPath section];
    if (section == 0) {
        // We can ignore this stuff, it's just that everybody is doing this when they use UITableView
        static NSString *QWizzleCellIdentifier = @"QWizzleCell";
        
        // Check for a reusable cell first, use that if it exists
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QWizzleCellIdentifier];
        
        // If there is no reusable cell of this type, create a new one
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:QWizzleCellIdentifier];
        }
        
        QWZQuizSet *qs = [allQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
        
        return cell;
    }
    else if (section == 1){
        // We can ignore this stuff, it's just that everybody is doing this when they use UITableView
        static NSString *AnsweredQWizzleCellIdentifier = @"AnsweredQWizzleCell";
        
        // Check for a reusable cell first, use that if it exists
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AnsweredQWizzleCellIdentifier];
        
        // If there is no reusable cell of this type, create a new one
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:AnsweredQWizzleCellIdentifier];
        }
        
        QWZAnsweredQuizSet *qs = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
        
        // Get the stored data before the view appear
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [defaults objectForKey:@"user_name"];

        NSString *creator = [qs creator];
        if (![creator isEqualToString:userName]) {
            [[cell detailTextLabel] setText:[creator copy]];
        }
        else {
            [[cell detailTextLabel] setText:@""];
        }
        return cell;
    }
    else if (section == 2){
        // We can ignore this stuff, it's just that everybody is doing this when they use UITableView
        static NSString *RequestedQWizzleCellIdentifier = @"RequestedQWizzleCell";
        
        // Check for a reusable cell first, use that if it exists
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RequestedQWizzleCellIdentifier];
        
        // If there is no reusable cell of this type, create a new one
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:RequestedQWizzleCellIdentifier];
        }
        
        QWZQuizSet *qs = [allRequestedQuizSet objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
        
        // Get the stored data before the view appear
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [defaults objectForKey:@"user_name"];
        
        NSString *creator = [qs creator];
        if (![creator isEqualToString:userName]) {
            [[cell detailTextLabel] setText:[creator copy]];
        }
        else {
            [[cell detailTextLabel] setText:@""];
        }
        return cell;
    }
}

// One of the required methods needed to be implemented to use UITableViewController
// - Return the number of rows given a section number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // We need to get the correct number associated with the given section here
    NSInteger row = 0;
    if (section == 0) {
        row = [allQuizSets count];
    }
    else if (section == 1){
        row = [allAnsweredQuizSets count];
    }
    else {
        row = [allRequestedQuizSet count];
    }

    // Return the number of rows in the section.
    return row;
}

#pragma mark Handle multiple section
// The table view needs to know how many sections it should expect.
// We have exactly 2 sections here - a quizset and an answered quizset
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTION;
}

// We have to get the correct title for each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Your Qwizzles";
    }
    else if (section == 1){
        return @"Qwizzles You've Taken";
    }
    else {
        return @"Requested Qwizzles";
    }
}

// Display an appropriate message to users and encourage them to create a new Qwizzle
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if ([allQuizSets count] == 0) {
            return @"None yet! Tap + button to create one";
        }
        else {
            return nil;
        }
    }
    else if (section == 1){
        if ([allAnsweredQuizSets count] == 0) {
            return @"None taken yet";
        }
        else {
            return nil;
        }
    }
    else {
        if ([allRequestedQuizSet count] == 0) {
            return @"No requested yet";
        }
        else {
            return nil;
        }
    }
}

#pragma mark - Table view delegate
// Implement this method to respond when the user is tapping any row
// Basically it should switch to another view and load all the corresponding information
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here.
    NSInteger section = [indexPath section];
    if (section == 0) {
        selectedQuiz = [allQuizSets objectAtIndex:[indexPath row]];
        requestedQwizzle = NO;
        
        // Perform a segue (a view's transition) given a storyboard segue's ID that we specified in storyboard
        // We need to do it this way because our data cells are dynamically generated, so we can't pre-wire them.
        // Note: (A segue is a path between each screen, we can click at the path to see its ID)
        [self performSegueWithIdentifier:@"SEGUETakeQwizzle" sender:self];
    }
    else if (section == 1) {
        selectedQuiz = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        
        [self performSegueWithIdentifier:@"SEGUEViewQwizzle" sender:self];
    }
    else if (section == 2) {
        selectedQuiz = [allRequestedQuizSet objectAtIndex:[indexPath row]];
        requestedQwizzle = YES;
        
        // This cell is sharing the same view as taking your own qwizzle
        [self performSegueWithIdentifier:@"SEGUETakeQwizzle" sender:self];
    }
    else {
        
    }
}

// This method get called automatically when we're moving to the other view in the storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"SEGUETakeQwizzle"])
    {
        // Get the destination's view controller (User is taking a Qwizzle)
        QWZTakeQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:selectedQuiz];
        [destinationViewController setOrigin:self];
        [destinationViewController setIsRequestedQwizzle:requestedQwizzle];
    }
    else if ([segue.identifier isEqualToString:@"SEGUEViewQwizzle"]){
        // Get the destination's view controller (User is viewing a Qwizzle)
        QWZViewQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:selectedQuiz];
    }
    else if ([segue.identifier isEqualToString:@"SEGUECreateQwizzle"]) {
        // Get the destination's view controller (User is creating a Qwizzle)
        QWZCreateQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setOrigin:self];
    }
    else if ([segue.identifier isEqualToString:@"SEGUELogin"]) {

    }
    else {
        NSLog(@"Unidentifiable Segue");
    }
}


// Change the label of the delete button
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

// This method is sent to ItemsViewController with committing edit with 2 extra arguments
// 1. UITableViewCellEditingStyle - Delete, Edit, or etc...
// 2. NSIndexPath - index of the row
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger section = [indexPath section];
        if (section == 0) {
            NSLog(@"Deleting the row %d from %@", [indexPath row], indexPath);
            [allQuizSets removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (section == 1) {
            [allAnsweredQuizSets removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (section == 2) {
            [allRequestedQuizSet removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            NSLog(@"Unidentified section");
        }
    }
}

#pragma mark store object & connection
- (IBAction)logout:(id)sender
{
    NSLog(@"Log Out");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"user_id"];
    
    NSLog(@"logging out - user info:%@",[defaults objectForKey:@"user_id"]);
    
    [self redirectToLoginPage];
    
    reloadFlag = YES;
}

- (IBAction)reloadQwizzle:(id)sender
{
    NSLog(@"reloadQwizzle");

    [self reloadAllQwizzles];
    //[[QWZQwizzleStore sharedStore] fetchAnsweredQwizzleWithCompletion:completionBlock];
}

- (void)reloadAllQwizzles
{
    NSLog(@"reloadQwizzle");
    [self fetchYourQwizzles];
    [self fetchAnsweredQwizzles];
    [self fetchRequestedQwizzles];
}

- (void)fetchYourQwizzles
{
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Create a codeblock to run when finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        // When the request completes 
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            NSLog(@"Information sent with no error: %@", obj);
            
            [allQuizSets removeAllObjects];
            [[self tableView] reloadData];
            
            NSArray *receivedQuizSets = [[obj JSON] objectForKey:@"qwizzles"];
            
            QWZQuizSet *newQuizSet = nil;
            NSString *title = nil;
            NSInteger ID = -1;
            NSDictionary *quizSet = nil;
            for (int i = 0; i < [receivedQuizSets count]; i++) {
                quizSet = [[receivedQuizSets objectAtIndex:i] objectForKey:@"qwizzle"];
                
                title = [quizSet objectForKey:@"title"];
                ID = [[quizSet objectForKey:@"id"] intValue];
                
                newQuizSet = [[QWZQuizSet alloc] initWithTitle:title andID:ID];
                
                [allQuizSets addObject:newQuizSet];
                
                // Adding new Qwizzle (unanswer qwizzle) into the table, this set reside in the section 0
                NSInteger lastRow = [allQuizSets indexOfObject:newQuizSet];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
                
                // Insert this Qwizzle into the table
                [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    };
    
    // Initiate the request, send the code block to the Store object to run after the connection is completed.
    [[QWZQwizzleStore sharedStore] fetchQwizzleWithCompletion:completionBlock];
}

- (void)fetchAnsweredQwizzles
{
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Create a codeblock to run when finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        // When the request completes - success or failure, replaces the activity indicator with the previous title
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            NSLog(@"Information sent with no error: %@", obj);
            
            [allAnsweredQuizSets removeAllObjects];
            [[self tableView] reloadData];
            
            NSArray *receivedQuizSets = [[obj JSON] objectForKey:@"qwizzles"];
            QWZAnsweredQuizSet *newQuizSet = nil;
            NSString *title = nil;
            NSInteger ID = -1;
            NSDictionary *quizSet = nil;
            NSInteger creatorID = -1;
            NSString *creatorName = nil;
            for (int i = 0; i < [receivedQuizSets count]; i++) {
                quizSet = [[receivedQuizSets objectAtIndex:i] objectForKey:@"qwizzle"];
                
                title = [quizSet objectForKey:@"title"];
                ID = [[quizSet objectForKey:@"id"] intValue];
                creatorID = [[quizSet objectForKey:@"creator"] intValue];
                creatorName = [quizSet objectForKey:@"creator_name"];
                
                newQuizSet = [[QWZAnsweredQuizSet alloc] initWithTitle:title andID:ID];
                [newQuizSet setCreator:[creatorName copy]];
                [newQuizSet setCreatorID:creatorID];
                
                [allAnsweredQuizSets addObject:newQuizSet];
                
                // Adding new Qwizzle (answered qwizzle) into the table, this set reside in the section 1
                NSInteger lastRow = [allAnsweredQuizSets indexOfObject:newQuizSet];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:1];
                
                // Insert this Qwizzle into the table
                [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    };
    
    // Initiate the request, send the code block to the Store object to run after the connection is completed.
    [[QWZQwizzleStore sharedStore] fetchAnsweredQwizzleWithCompletion:completionBlock];
}

- (void)fetchRequestedQwizzles
{
    // Create an activity indicator while loading
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Create a codeblock to run when finish loading
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        // When the request completes - success or failure, replaces the activity indicator with the previous title
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            NSLog(@"Information sent with no error: %@", obj);
            
            [allRequestedQuizSet removeAllObjects];
            [[self tableView] reloadData];
            
            NSArray *receivedQuizSets = [[obj JSON] objectForKey:@"requests"];
            QWZAnsweredQuizSet *newQuizSet = nil;
            NSString *title = nil;
            NSInteger ID = -1;
            NSDictionary *quizSet = nil;
            NSInteger creatorID = -1;
            NSString *creatorName = nil;
            NSInteger requestID = -1;
            for (int i = 0; i < [receivedQuizSets count]; i++) {
                quizSet = [[receivedQuizSets objectAtIndex:i] objectForKey:@"request"];
                
                title = [quizSet objectForKey:@"title"];
                ID = [[quizSet objectForKey:@"id"] intValue];
                creatorID = [[quizSet objectForKey:@"sender_id"] intValue];
                creatorName = [quizSet objectForKey:@"sender_name"];
                requestID = [[quizSet objectForKey:@"request_id"] intValue];
                
                newQuizSet = [[QWZAnsweredQuizSet alloc] initWithTitle:title andID:ID];
                [newQuizSet setCreator:[creatorName copy]];
                [newQuizSet setCreatorID:creatorID];
                [newQuizSet setRequestID:requestID];
                
                [allRequestedQuizSet addObject:newQuizSet];
                
                // Adding new Qwizzle (answered qwizzle) into the table, this set reside in the section 1
                NSInteger lastRow = [allRequestedQuizSet indexOfObject:newQuizSet];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:2];
                
                // Insert this Qwizzle into the table
                [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    };
    
    // Initiate the request, send the code block to the Store object to run after the connection is completed.
    [[QWZQwizzleStore sharedStore] fetchRequestedQwizzleWithCompletion:completionBlock];
}

#pragma mark login and logout
- (void)redirectToLoginPage
{
    [self performSegueWithIdentifier:@"SEGUELogin" sender:self];
}

// Implement this method if there is anything needed to be done if we receive a memory warning
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
