//
//  QWZCreateViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZCreateViewController.h"

@interface QWZCreateViewController ()

@end

@implementation QWZCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Every viewcontroller has this navigationItem property
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Create Qwizzle"];
        
        // Create a new bar button item that will send addNewItem: to QWZViewController
        // UIBarButtonSystemItemSave is the default save button
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(createNewQuiz:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    return self;
}

// Krissada: createNewQuiz will create a new quiz, shoule check & validate every question here.
- (IBAction)createNewQuiz:(id)sender
{
    NSLog(@"Create New Quiz!!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
