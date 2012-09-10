//
//  Cal1CardAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cal1CardAnnotation.h"

#define kImageUrl @"imageurl"
#define kInfo @"info"
#define kTimes @"times"

@implementation Cal1CardAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
              andTitle:(NSString *)title 
                andURL:(NSString *)url
              andTimes:(NSString *)times
               andInfo:(NSString*)info{
	if (self = [super init]) {
		_latitude = latitude;
		_longitude = longitude;
        self.title = title;
        self.times = times;
        self.imageURL = url;
        self.info = info;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.imageURL = [aDecoder decodeObjectForKey:kImageUrl];
        self.info = [aDecoder decodeObjectForKey:kInfo];
        self.times = [aDecoder decodeObjectForKey:kTimes];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.imageURL forKey:kImageUrl];
    [aCoder encodeObject:self.times forKey:kTimes];
    [aCoder encodeObject:self.info forKey:kInfo];
}

@end
