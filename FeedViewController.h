//
//  FeedViewController.h
//  iCastelli
//
//  Created by Eyolph on 19/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface FeedViewController : PFQueryTableViewController
- (PFQuery *)queryForTable;

@property (nonatomic, strong) NSString *created;

@end
