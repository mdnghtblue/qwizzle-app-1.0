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
    
    BOOL requestedQwizzle;
}

// This method receives a newly created Qwizzle from the QWZCreateQwizzleController
- (void)submitAQwizzle:(QWZQuizSet *)qz; 

// This method receives a filled out Qwizzle from the QWZTakeQwizzleController 
- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

// This method receives a filled out the requested Qwizzle from the QWZTakeQwizzleController 
- (void)fillOutARequestedQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

// This method deletes the taken requested Qwizzle
- (void)deleteARequestedQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

// This method is called when users tap the refresh button
- (IBAction)reloadQwizzle:(id)sender;

// This method reloads everything
- (void)reloadAllQwizzles;

// This method lets the user log out
- (IBAction)logout:(id)sender;

// This method redirects the user into the login page
- (void)redirectToLoginPage;

// This method fetches all YourQwizzles from the server
- (void)fetchYourQwizzles;

// This method fetches all Qwizzles that users have taken from the server
- (void)fetchAnsweredQwizzles;

// This method fetches all Requested Qwizzles 
- (void)fetchRequestedQwizzles;

@property (nonatomic) BOOL reloadFlag; // Reload Flag, set to YES when redirected to the login view

@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet

@end
