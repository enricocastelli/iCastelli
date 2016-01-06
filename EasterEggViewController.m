//
//  EasterEggViewController.m
//  iCastelli
//
//  Created by Eyolph on 13/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "EasterEggViewController.h"

@interface EasterEggViewController ()

@property (nonatomic) CGFloat floatY;

@end

@implementation EasterEggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.floatY = 10;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(doIt)
                                   userInfo:nil
                                    repeats:YES];
    [timer fire];
}


- (void)doIt
{
    self.floatY += 20;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.floatY, 300, 20)];
    label.text = @"FATAL ERROR. OBVIOUS STATEMENT";
    label.textColor = [UIColor greenColor];
    [self.view addSubview:label];
}

- (IBAction)tap:(UITapGestureRecognizer*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
