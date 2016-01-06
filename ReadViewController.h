//
//  ReadViewController.h
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "MapViewController.h"

@interface ReadViewController : UIViewController

@property (nonatomic, strong) PFObject *user;

@end
