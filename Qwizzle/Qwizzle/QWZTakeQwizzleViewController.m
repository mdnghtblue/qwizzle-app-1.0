//
//  QWZAnswerViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZAnswerViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"

@interface QWZAnswerViewController ()

@end

@implementation QWZAnswerViewController

@synthesize quizSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Every viewcontroller has this navigationItem property
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Answer Qwizzle"];
    }
    return self;
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
