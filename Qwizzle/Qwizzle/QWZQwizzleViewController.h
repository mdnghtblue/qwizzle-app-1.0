//
//  QWZQwizzleViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//
#import <UIKit/UIKit.h>

@class QWZQuizSet;
@class QWZAnsweredQuizSet;

#define NUMBER_OF_SECTION 2

// QWZQwizzleViewController can fill all 3 roles: view controller, data source, and delegate
// by implementing the following protocol: UITableViewDataSource and UITableViewDelegate.

// Implement UITableViewDelegate to set the label of the delete button
// Optional methods of the protocol allow the delegate to manage selections,
// configure section headings and footers, help to delete and reorder cells, and perform other actions...
@interface QWZQwizzleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    // This array stores all quiz sets
    NSMutableArray *allQuizSets;
    
    // This array stores all answered quiz sets
    NSMutableArray *allAnsweredQuizSets;
    
    // Handle the selected quiz tapped by the user
    QWZQuizSet *selectedQuiz;
}

// This method receives a newly created Qwizzle from the QWZCreateQwizzleController and updates the mainview
- (void)submitAQwizzle:(QWZQuizSet *)qz; 

// This method receives a newly created Qwizzle from the QWZTakeQwizzleController and updates the mainview
- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

@end
