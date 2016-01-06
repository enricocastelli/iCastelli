//
//  UserViewController.h
//  iCastelli
//
//  Created by Eyolph on 20/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface UserViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end
