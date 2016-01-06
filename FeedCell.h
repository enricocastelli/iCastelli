//
//  FeedCell.h
//  iCastelli
//
//  Created by Eyolph on 19/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface FeedCell : PFTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet PFImageView *iconView;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *endColor;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (weak, nonatomic) IBOutlet UIImageView *playOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *miniPlay;



@end
