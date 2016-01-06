//
//  MapViewController.h
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PeopleAnnotation.h"

@interface MapViewController : UIViewController

@property (nonatomic, strong) PFObject *castelli;

@end
