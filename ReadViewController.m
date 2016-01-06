//
//  ReadViewController.m
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "ReadViewController.h"
#import "FullImageViewController.h"


@interface ReadViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UIButton *interactButton;
@property (weak, nonatomic) IBOutlet UIButton *interactButton2;
@property (weak, nonatomic) IBOutlet UIButton *interactButton3;
@property (weak, nonatomic) IBOutlet UIButton *openImage;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.interactButton.layer.cornerRadius = self.interactButton.frame.size.width/2;
    self.interactButton2.layer.cornerRadius = self.interactButton2.frame.size.width/2;
    self.interactButton3.layer.cornerRadius = self.interactButton3.frame.size.width/2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userLabel.text = self.user[@"username"];
    self.statusLabel.text = self.user[@"status"];
    self.userImage.file = self.user[@"image"];
    [self.userImage loadInBackground];
    
    
    PFQuery*query = [PFQuery queryWithClassName:@"Feeds"];
    
    
    [query whereKey:@"user" equalTo:self.user[@"username"]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.activeLabel.text = [NSString stringWithFormat:@"%i post recenti", number];
        
    }];
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.navigationItem.rightBarButtonItem = home;
}


- (IBAction)whatsapp:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", self.user[@"number"]]]];
    

}


- (IBAction)map:(id)sender
{
    MapViewController *m = [[MapViewController alloc] init];
    m.castelli = self.user;
    [self.navigationController pushViewController:m animated:YES];
    
}

- (IBAction)interact:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", self.user[@"number"]]]];
}


- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)openImage:(id)sender {
    FullImageViewController *full = [[FullImageViewController alloc] init];
    full.photo = self.user[@"image"];
    [self.navigationController pushViewController:full animated:YES];
}




@end
