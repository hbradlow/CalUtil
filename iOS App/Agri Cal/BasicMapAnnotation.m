//
//  BasicMapAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicMapAnnotation.h"
#define kLongKey @"longitude"
#define kLatKey @"latitude"
#define kTitleKey @"title" 
#define kSubKey @"sub" 

@interface BasicMapAnnotation()

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end 

@implementation BasicMapAnnotation

@synthesize title = _title;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:_latitude forKey:kLatKey];
    [aCoder encodeFloat:_longitude forKey:kLongKey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.subtitle forKey:kSubKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.longitude = [aDecoder decodeFloatForKey:kLongKey];
        self.latitude = [aDecoder decodeFloatForKey:kLatKey];
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.subtitle = [aDecoder decodeObjectForKey:kSubKey];
    }
    return self;
}

@end
