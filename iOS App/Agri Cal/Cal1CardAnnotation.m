//
//  Cal1CardAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cal1CardAnnotation.h"

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

@end
