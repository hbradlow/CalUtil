//
//  BasicMapAnnotation.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation, NSCoding> {
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude; 
    NSString *_title; 
    NSString *_subtitle;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
