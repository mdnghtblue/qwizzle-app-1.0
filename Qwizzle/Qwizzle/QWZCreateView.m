//
//  QWZCreateView.m
//  QWZ-App
//
//  Created by Oun AL Sayed on 3/25/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZCreateView.h"

#import <CoreData/CoreData.h>
#import "Quiz.h"
#import "Question.h"

@interface QWZCreateView ()

@end

@implementation QWZCreateView

@synthesize managedObjectContext;

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createQuiz:(id)sender
{
    NSLog(@"Attempting to create test quiz...");
    
    Quiz *newQuiz = (Quiz *) [NSEntityDescription insertNewObjectForEntityForName:@"Quiz" inManagedObjectContext:managedObjectContext];
    [newQuiz setCreator:@"John Doe"];
    [newQuiz setQwz_id:@1];
    
    Question *question1 = (Question *) [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:managedObjectContext];
    [question1 setQwz_id:@1];
    [question1 setQuestion:@"What is your favorite color?"];
    [question1 setQ_id:@100];
    
    Question *question2 = (Question *) [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:managedObjectContext];
    [question2 setQwz_id:@1];
    [question2 setQuestion:@"What are your favorite foods?"];
    [question2 setQ_id:@200];
    
    // Commit to core data
    NSError *error;
    if (![managedObjectContext save:&error])
        NSLog(@"Failed to write to core data with error: %@", [error domain]);
    else
        NSLog(@"Wrote sample quiz to core data!");
    
    NSLog(@"created quiz!");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
