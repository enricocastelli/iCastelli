//
//  HomeViewController.m
//  iCastelli
//
//  Created by Eyolph on 19/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedViewController.h"

@interface HomeViewController () <UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *laura;
@property (weak, nonatomic) IBOutlet UIButton *enrico;
@property (weak, nonatomic) IBOutlet UIButton *anna;
@property (weak, nonatomic) IBOutlet UIButton *giusy;
@property (weak, nonatomic) IBOutlet UIButton *claudio;
@property (weak, nonatomic) IBOutlet UIButton *iker;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIButton *backButton;






@property (weak, nonatomic) NSString *username;


@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.enterButton.layer.cornerRadius = self.enterButton.bounds.size.width/2;
    self.passwordField.delegate = self;

}
- (IBAction)buttonPressed:(UIButton *)button
{
    self.username = button.titleLabel.text;
    [self animateToolbar];
    button.alpha = 1;
    self.backButton.enabled = YES;
    
}



- (IBAction)undo:(id)sender
{
    self.enterButton.hidden = YES;
    self.passwordField.hidden = YES;
    [self.passwordField resignFirstResponder];
    [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        for (UILabel*label in self.labels) {
            label.alpha = 1;
        }
        for (UIButton*button in self.buttons) {
            button.alpha = 1;
        }
        
    } completion:nil];

    self.backButton.enabled = NO;

}

- (IBAction)entra:(id)sender
{
    [self.passwordField resignFirstResponder];
    [PFUser logInWithUsernameInBackground:self.username password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            for (UIButton*button in self.buttons) {
                                                button.alpha = 0;
                                            }

                                            [self.enterButton becomeFirstResponder];
                                            self.enterButton.titleLabel.alpha = 0;

                                            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                                self.enterButton.bounds = CGRectMake(0, 0, 700, 700);
                                                
                                                
                                                
                                            } completion:^(BOOL finished) {
                                                self.view.backgroundColor = self.enterButton.backgroundColor;
                                                self.backButton.hidden = YES;
                                                self.passwordField.hidden = YES;
                                                FeedViewController *feed = [[FeedViewController alloc] init];
                                                [self.navigationController pushViewController:feed animated:YES];
                                            }];

                                            
                                        } else {
                                            [self.passwordField becomeFirstResponder];
                                            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:300 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                                
                                                self.enterButton.frame = CGRectMake(126, 249, 70, 70);
                                                
                                            } completion:nil];
                                        }
                                    }];
}



- (void)animateToolbar
{
    self.enterButton.alpha = 0;
    self.passwordField.hidden = NO;
    self.enterButton.hidden = NO;
    self.passwordField.alpha = 0;

    [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.passwordField.alpha = 1;
        self.enterButton.alpha = 1;

    } completion:nil];
    
    [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        for (UILabel*label in self.labels) {
            label.alpha = 0.1;
        }
        for (UIButton*button in self.buttons) {
            button.alpha = 0.1;
        }
        
    } completion:nil];
    [self.passwordField becomeFirstResponder];
}








@end
