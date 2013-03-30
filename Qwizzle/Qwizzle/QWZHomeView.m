//
//  QWZStoreView.m
//  QWZ-App
//
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZHomeView.h"
#import "CoreData/CoreData.h"
#import "Quiz.h"
#import "Question.h"

@interface QWZHomeView ()

@end

@implementation QWZHomeView

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
    
    /*NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    //if ([delegate performSelector:@selector(managedObjectContext)])
    //{
        context = [delegate managedObjectContext];
    //}
    
    Quiz *newQuiz = (Quiz *) [NSEntityDescription insertNewObjectForEntityForName:@"Quiz" inManagedObjectContext:context];
    [newQuiz setCreator:@"John Doe"];
    [newQuiz setQwz_id:@1];
    
    Question *question1 = (Question *) [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
    [question1 setQwz_id:@1];
    [question1 setQuestion:@"What is your favorite color?"];
    [question1 setQ_id:@100];
    
    Question *question2 = (Question *) [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
    [question2 setQwz_id:@1];
    [question2 setQuestion:@"What are your favorite foods?"];
    [question2 setQ_id:@200];
    
    // Commit to core data
    NSError *error;*/
    //if (![context save:&error])
    //    NSLog(@"Failed to write to core data with error: %@", [error domain]);
    //else
    //    NSLog(@"Wrote sample quiz to core data!");
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
