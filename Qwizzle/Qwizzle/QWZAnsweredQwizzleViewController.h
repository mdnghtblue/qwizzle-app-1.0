//
//  QWZAnsweredQwizzleViewController.h
//  Qwizzle
//
//  Created by Baneeen AL Mubarak on 4/3/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "Question.h"
#import "Answers.h"

@interface QWZAnsweredQwizzleViewController : UIViewController

// the following property will handle object from view controller

@property (nonatomic,strong) NSManagedObjectContext *mangedObjectContext;
@property (nonatomic,strong) Quiz *currentQuiz;
@property (nonatomic,strong) Question *currentqQuestions;
@property (nonatomic,strong) Answers *currentAnswers;

@end
