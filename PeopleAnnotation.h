//
//  PeopleAnnotation.h
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface PeopleAnnotation : NSObject <MKAnnotation>

- (id)initWithObject:(PFObject*)object;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *subtitle;
@property (strong, nonatomic) PFObject *object;



@end
