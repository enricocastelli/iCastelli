//
//  DetailViewController.h
//  iCastelli
//
//  Created by Eyolph on 23/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface DetailViewController : UIViewController

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFObject *user;
@property (strong, nonatomic) PFQuery* query;
@property (strong, nonatomic) NSNumber* count;


@end
