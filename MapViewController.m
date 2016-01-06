//
//  MapViewController.m
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "MapViewController.h"
#import "ReadViewController.h"
#import "UserViewController.h"




@interface MapViewController () <CLLocationManagerDelegate,MKMapViewDelegate, MKAnnotation>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *location;
@property (nonatomic, strong) NSString *user;


@property (weak, nonatomic) IBOutlet UIButton *giusi;
@property (weak, nonatomic) IBOutlet UIButton *laura;
@property (weak, nonatomic) IBOutlet UIButton *enrico;
@property (weak, nonatomic) IBOutlet UIButton *anna;
@property (weak, nonatomic) IBOutlet UIButton *claudio;


@end

@implementation MapViewController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.location = [[CLLocationManager alloc] init];
        self.location.delegate = self;
        [self.location setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView setUserInteractionEnabled:YES];

    PFQuery *query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *ob in objects) {
            
            PeopleAnnotation *annotation = [[PeopleAnnotation alloc] initWithObject:ob];
            [self.mapView addAnnotation:annotation];
            
        }
    }];
}

- (void)viewDidLoad
{
    [self.location startUpdatingLocation];
    
//    [self.location requestWhenInUseAuthorization];
    [self.location requestAlwaysAuthorization];
    
    [self.mapView setShowsUserLocation:YES];
    CLLocationCoordinate2D loc = self.location.location.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 999*2300, 999*2300);
    [self.mapView setRegion:region animated:YES];
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.castelli) {
        
        PeopleAnnotation *ann = [[PeopleAnnotation alloc] initWithObject:self.castelli];
        CLLocationCoordinate2D loc = ann.coordinate;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
        
        [self.mapView setRegion:region animated:YES];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
                      viewForAnnotation:(id<MKAnnotation>)annotation
{

    if (annotation == self.mapView.userLocation){
        return nil;
    } else {

        MKAnnotationView *pin = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"mapAnnotation"];
    
    pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapAnnotation"];
        
        
    UIImage *logoPin = [UIImage imageNamed:annotation.title];
        
    [pin setImage:logoPin];
    
    pin.canShowCallout = YES;
        
        pin.frame = CGRectMake(0, 0, 50, 50);

        return pin;
        }
}

- (void)mapView:(MKMapView * _Nonnull)mapView
didSelectAnnotationView:(MKAnnotationView * _Nonnull)view
{
    PeopleAnnotation *people = (PeopleAnnotation *)view.annotation;

    if (view.annotation == self.mapView.userLocation){
        
        [UIView animateWithDuration:1.4 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGPoint point = CGPointMake(view.center.x+1, view.center.y+1);
            view.center = point;
            view.transform = CGAffineTransformMakeRotation(6.15);
        } completion:nil];
        
        
    } else {
        
        CGPoint original = CGPointMake(view.center.x, view.center.y);
        
        [UIView animateWithDuration:1.4 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGPoint point = CGPointMake(view.center.x+1, view.center.y+1);
            view.center = point;
            view.transform = CGAffineTransformMakeRotation(6.15);
        } completion:nil];

        
        PFFile *image = people.object[@"image"];
        
        
        CGRect rect = CGRectMake(0, 0, 30, 30);
        
        PFImageView *imageView = [[PFImageView alloc] initWithFrame:rect];
        
        imageView.file = image;
        
        [imageView loadInBackground];
        
        view.leftCalloutAccessoryView = imageView;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [button addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
        view.rightCalloutAccessoryView = button;

        view.transform = CGAffineTransformMakeRotation(0);
        view.center = original;
        self.user = view.annotation.title;
    }
}


- (void)press
{
    [self.mapView setUserInteractionEnabled:NO];
    PFUser *user = [PFUser currentUser];
    
    if ([user.username isEqualToString: self.user]) {
        UserViewController *u = [[UserViewController alloc] init];
        u.user = user;
        [self.navigationController pushViewController:u animated:YES];
    } else {
        
        ReadViewController *r = [[ReadViewController alloc] init];
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:self.user];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            r.user = object;
            [self.navigationController pushViewController:r animated:YES];
        }];
        
    }
}

-(IBAction)selectCastelli:(UIButton*)sender
{
    self.castelli = nil;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:sender.titleLabel.text];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PeopleAnnotation *ann = [[PeopleAnnotation alloc] initWithObject:object];
        CLLocationCoordinate2D loc = ann.coordinate;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 2000, 500);
        
        [self.mapView setRegion:region animated:YES];

    }];
    

}




@end
