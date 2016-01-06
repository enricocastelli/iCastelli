//
//  SettingsViewController.m
//  iCastelli
//
//  Created by Eyolph on 05/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "SettingsViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "ReadViewController.h"
@import SpriteKit;

@interface SettingsViewController () <UICollisionBehaviorDelegate>

@property (strong, nonatomic) NSArray *objects;
@property (weak, nonatomic) IBOutlet UIButton *up;
@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UIButton *right;
@property (weak, nonatomic) IBOutlet UIButton *down;
@property (weak, nonatomic) IBOutlet UILabel *rect;
@property (strong, nonatomic) UIDynamicAnimator*animator;
@property (weak, nonatomic) IBOutlet UILabel *Rect2;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) PFQuery *que;

@property (nonatomic) CGRect upFrame;
@property (nonatomic) CGRect downFrame;
@property (nonatomic) CGRect leftFrame;
@property (nonatomic) CGRect rightFrame;
@property (nonatomic) BOOL animating;





@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animating = NO;
    [self setNav];
    self.rect.layer.cornerRadius = self.rect.frame.size.width/89;
    PFQuery *que = [PFUser query];
    [que whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [que findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.objects = objects;
        [self setButtons];
    }];
    self.up.layer.cornerRadius = self.up.frame.size.width/2;
    self.left.layer.cornerRadius = self.left.frame.size.width/2;
    self.down.layer.cornerRadius = self.down.frame.size.width/2;
    self.right.layer.cornerRadius = self.right.frame.size.width/2;
}

- (void)buttonsInFrame
{
    self.up.frame  = self.upFrame;
    self.down.frame  = self.downFrame;
    self.left.frame  = self.leftFrame;
    self.right.frame  = self.rightFrame;

}

- (void)setNav
{
    UIBarButtonItem *animate = [[UIBarButtonItem alloc] initWithTitle:@"Anima!" style:UIBarButtonItemStylePlain target:self action:@selector(anima)];
    self.navigationItem.rightBarButtonItem = animate;
    
}

- (void)viewWillAppear:(BOOL)animated
{
UIDevice* device = [UIDevice currentDevice];
[device beginGeneratingDeviceOrientationNotifications];
[[NSNotificationCenter defaultCenter]
 addObserver:self selector:@selector(orientationChanged:)
 name:UIDeviceOrientationDidChangeNotification
 object:[UIDevice currentDevice]];
}

- (void)setButtons
{
    [self.up setImage:[UIImage imageNamed:self.objects[1][@"username"]] forState:UIControlStateNormal];
    self.up.titleLabel.text = self.objects[1][@"username"];
    self.up.titleLabel.hidden = YES;
    [self.down setImage:[UIImage imageNamed:self.objects[0][@"username"]] forState:UIControlStateNormal];
    self.down.titleLabel.text = self.objects[0][@"username"];
    self.down.titleLabel.hidden = YES;
    [self.right setImage:[UIImage imageNamed:self.objects[2][@"username"]] forState:UIControlStateNormal];
    self.right.titleLabel.text = self.objects[2][@"username"];
    self.right.titleLabel.hidden = YES;
    [self.left setImage:[UIImage imageNamed:self.objects[3][@"username"]] forState:UIControlStateNormal];
    self.left.titleLabel.text = self.objects[3][@"username"];
    self.left.titleLabel.hidden = YES;
}

- (void)animate:(CGVector)vec
{
    

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
 
    
    UIGravityBehavior* gravityBehavior =
    [[UIGravityBehavior alloc] initWithItems:@[self.up, self.down, self.left, self.right]];
    gravityBehavior.gravityDirection = vec;
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior* collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[self.up, self.down, self.left, self.right]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    [collisionBehavior addBoundaryWithIdentifier:@"rect1" fromPoint:self.rect.center toPoint:self.rect.center];
    [collisionBehavior addBoundaryWithIdentifier:@"rect2" fromPoint:self.Rect2.center toPoint:self.Rect2.center];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.topLabel.frame];
    [collisionBehavior addBoundaryWithIdentifier:@"top" forPath:path];
    
    collisionBehavior.collisionDelegate = self;
    
    
    [self.animator addBehavior:collisionBehavior];
    

    
    UIDynamicItemBehavior *elasticityBehavior =
    [[UIDynamicItemBehavior alloc] initWithItems:@[self.up, self.down, self.left, self.right]];
    elasticityBehavior.elasticity = 1.01;
    elasticityBehavior.allowsRotation = YES;
    [self.animator addBehavior:elasticityBehavior];
    
    UIBarButtonItem *stop = [[UIBarButtonItem alloc] initWithTitle:@"Stop!" style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
    self.navigationItem.rightBarButtonItem = stop;
    
}


- (void) orientationChanged:(NSNotification *)note
{
    
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self animate:CGVectorMake(0, 1)];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
             [self animate:CGVectorMake(0, -1)];
            break;
        case UIDeviceOrientationLandscapeLeft:
             [self animate:CGVectorMake(-1, 0)];
            break;
        case UIDeviceOrientationLandscapeRight:
             [self animate:CGVectorMake(1, 0)];
            break;
        default:
            [self animate:CGVectorMake(0, 0)];

            break;
    }
}



- (IBAction)panning:(UIPanGestureRecognizer *)sender {
    [sender delaysTouchesBegan];
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                     sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];

    [self animate:CGVectorMake(0, 1)];
    
}

- (IBAction)buttonTouch:(UIButton*)sender
{
    ReadViewController *read = [[ReadViewController alloc]init];
    for (PFObject *people in self.objects){
        if ([people[@"username"] isEqualToString:sender.titleLabel.text]) {
            read.user = people;
            [self.navigationController pushViewController:read animated:YES];
        }
    }
}



- (void)anima {
    [self animate:CGVectorMake(0, 1)];
}


- (void)stop
{
    self.animator = nil;
    [self.view.layer removeAllAnimations];
    [self setNav];
    
}



@end
