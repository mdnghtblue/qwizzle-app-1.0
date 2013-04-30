//
//  QWZQwizzleViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <iAd/iAd.h>

@class QWZQuizSet;
@class QWZAnsweredQuizSet;

#define NUMBER_OF_SECTION 3

// QWZQwizzleViewController can fill all 3 roles: view controller, data source, and delegate
// by implementing the following protocol: UITableViewDataSource and UITableViewDelegate.

// Implement UITableViewDelegate to set the label of the delete button
// Optional methods of the protocol allow the delegate to manage selections,
// configure section headings and footers, help to delete and reorder cells, and perform other actions...
// Implement ADBannerViewDelegate to view iAd
@interface QWZQwizzleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate>
{
    // This array stores all quiz sets
    NSMutableArray *allQuizSets;
    
    // This array stores all answered quiz sets
    NSMutableArray *allAnsweredQuizSets;
    
    // This array would store all requested quiz sets
    NSMutableArray *allRequestedQuizSet;
    
    // Handle the selected quiz tapped by the user
    QWZQuizSet *selectedQuiz;
    
    // Handle iAd view
    ADBannerView *adView;
}

// This method receives a newly created Qwizzle from the QWZCreateQwizzleController and updates the mainview
- (void)submitAQwizzle:(QWZQuizSet *)qz; 

// This method receives a newly created Qwizzle from the QWZTakeQwizzleController and updates the mainview
- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

// This method is called when users tap the refresh button - Will be removed soon
- (IBAction)reloadQwizzle:(id)sender;

- (IBAction)logout:(id)sender;

// This method redirects the user into the login page
- (void)redirectToLoginPage;

// This method fetches all YourQwizzles from the server
- (void)fetchYourQwizzles;

// This method fetches all Qwizzles that users have taken from the server
- (void)fetchAnsweredQwizzles;

// This method reloads everything
- (void)reloadAllQwizzles;

@property (nonatomic) BOOL reloadFlag; // Reload Flag, set to YES when redirected to the login view

@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet

@end
