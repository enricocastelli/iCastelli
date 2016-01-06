//
//  PeopleAnnotation.m
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "PeopleAnnotation.h"

@implementation PeopleAnnotation


- (id)initWithObject:(PFObject*)object
{
    self = [super init];
    if (self) {
        PFGeoPoint *point = object[@"annotation"];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        self.coordinate = loc;
        [self setTitle:object[@"username"]];

        NSString *string = [self returningTheDate:object[@"annotationDate"]];
        [self setSubtitle:string];
        self.object = object;
    }
    
    return self;
}

- (NSString*)returningTheDate:(NSDate*)date

{
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:date];
    
    float hoursSinceDate = (float)(timeSinceDate / (60.0 * 60.0));
    NSInteger hourse = (NSInteger)hoursSinceDate;
    
    int minute = (int)(hoursSinceDate *60);
    
    if(hoursSinceDate < 0.1){
        
        NSString *formattedDateString = [NSString stringWithFormat:@"adesso"];
        
        return formattedDateString;
    }
    if(hoursSinceDate < 1){
        
        NSString *formattedDateString = [NSString stringWithFormat:@"%i minuti fa", minute];
        
        return formattedDateString;
    }
    if(hoursSinceDate < 2)
    {
        NSString *formattedDateString = [NSString stringWithFormat:@"%i ora fa" , hourse];
        
        return formattedDateString;    }
    
    if(hoursSinceDate < 8)
    {
        NSString *formattedDateString = [NSString stringWithFormat:@"%i ore fa" , hourse];
        
        return formattedDateString;    }
    
    
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM 'alle' HH"];
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        
        return formattedDateString;
    }
}

@end
