//
//  QWZViewController.m
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

@interface QWZQwizzleViewController ()

@end

@implementation QWZQwizzleViewController

#pragma mark - Default App's Behavior
// Implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Loading sample data
    // Initialize the 2 quiz sets here
    allQuizSets = [[NSMutableArray alloc] init];
    allAnsweredQuizSets = [[NSMutableArray alloc] init];
    
    // Add hard-coded question set here
    QWZQuiz *q1 = [[QWZQuiz alloc] initWithQuestion:@"What is your name?"];
    QWZQuiz *q2 = [[QWZQuiz alloc] initWithQuestion:@"What is your lastname?"];
    
    QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set"];
    [qs1 addQuiz:q1];
    [qs1 addQuiz:q2];
    
    QWZQuizSet *qs2 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set 2"];
    [qs2 addQuiz:q1];
    
    QWZQuiz *q3 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite color?" answer:@"Green"];
    QWZQuiz *q4 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite food?" answer:@"Fried Rice"];
    QWZQuiz *q5 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite sport?" answer:@"Table Tennis"];
    QWZAnsweredQuizSet *aqs1 = [[QWZAnsweredQuizSet alloc] initWithTitle:@"Favourite Quiz Set"];
    [aqs1 addQuiz:q3];
    [aqs1 addQuiz:q5];
    [aqs1 addQuiz:q4];
    
    
    [allQuizSets addObject:qs1];
    [allQuizSets addObject:qs2];
    [allAnsweredQuizSets addObject:aqs1];
}

// Implement this method if there is anything needed to be configure before the view appear on-screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)submitAQwizzle:(QWZQuizSet *)qz
{
    NSLog(@"a qwizzle has been submitted!! %@", qz);
    NSLog(@"There are %d questions for %@", [[qz allQuizzes] count], [qz title]);
    [allQuizSets addObject:qz];
    
    // Adding new Qwizzle (unanswer qwizzle) into the table, this set reside in the section 0
    NSInteger lastRow = [allQuizSets indexOfObject:qz];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert this Qwizzle into the table
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers
{
    NSLog(@"submitting qwizzle answers!");
    [allAnsweredQuizSets addObject:qzAnswers];
    
    NSInteger lastRow = [allAnsweredQuizSets indexOfObject:qzAnswers];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:1];
    
    // Insert the new Qwizzle answers into the table
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationTop];
    
    // We might even be able to edit your Qwizzle: so we should not remove the Qwizzle?
    // Remove the quizset from the your Qwizzle section
    //NSInteger selectedRow = [allQuizSets indexOfObject:selectedQuiz];
    //NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:selectedRow inSection:0];
    //[allQuizSets removeObjectIdenticalTo:selectedQuiz];
    
    // Remove the cell from the table
    //[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndex]
    //                        withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Handle table view datasource
// One of the required method needed to be implemented to use UITableViewController
// - return a cell at the given index
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
    
    
    // Set the text on the cell with the desciption of the item
    // We need to get the cell from the correct section here
    NSInteger section = [indexPath section];
    if (section == 0) { 
        QWZQuizSet *qs = [allQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
    }
    else {
        QWZAnsweredQuizSet *qs = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
    }
    
    return cell;
}

// Krissada: One of the required method needed to be implemented to use UITableViewController
// return the number rows given a section number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Krissada: we need to get the correct number associated with the given section here
    NSInteger row = 0;
    if (section == 0) {
        row = [allQuizSets count];
    }
    else {
        row = [allAnsweredQuizSets count];
    }

    // Return the number of rows in the section.
    return row;
}

#pragma mark handling multiple section
// The table view needs to know how many sections it should expect.
// Krissada: we have exactly 2 sections here - an unanswer set and an answered quiz set
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// We have to get the correct title for each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Your Qwizzles";
    }
    else {
        return @"Qwizzles You've Taken";
    }
}

#pragma mark - Table view delegate
// Implement this method to response when the user is tapping any row
// Basically it should switch to another view and load all the corresponding information
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here.
    NSInteger section = [indexPath section];
    if (section == 0) {
        selectedQuiz = [allQuizSets objectAtIndex:[indexPath row]];
        
        // Perform a segue (a view's transition) given a storyboard segue's ID that we specified in storyboard
        // We need to do it this way because our data cells are dynamically generated, so we can't pre-wire them.
        // Note: (A segue is a path between each screen, we can click at the path to see its ID)
        [self performSegueWithIdentifier:@"SEGUETakeQwizzle" sender:self];
    }
    else if (section == 1) {
        selectedQuiz = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        
        [self performSegueWithIdentifier:@"SEGUEViewQwizzle" sender:self];
    }
    else {
        
    }
}

// This method get called automatically when we're moving to the other view in the storyboard
// All we have to do is the implement it.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"SEGUETakeQwizzle"])
    {
        // Get the destination's view controller (User is taking a Qwizzle)
        QWZTakeQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:selectedQuiz];
        [destinationViewController setOrigin:self];
    }
    else if ([segue.identifier isEqualToString:@"SEGUEViewQwizzle"]){
        // Get the destination's view controller (User is viewing a Qwizzle)
        QWZViewQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:selectedQuiz];
    }
    else if ([segue.identifier isEqualToString:@"SEGUECreateQwizzle"]) {
        QWZCreateQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setOrigin:self];
    }
    else {
        NSLog(@"Unidentifiable Segue");
    }
}

// Krissada: implement this method if there is anything needed to be done if receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
