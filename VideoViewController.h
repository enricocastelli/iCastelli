//
//  VideoViewController.h
//  iCastelli
//
//  Created by Eyolph on 12/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface VideoViewController : UIViewController

@property (strong, nonatomic) PFFile *videoFile;
@end
