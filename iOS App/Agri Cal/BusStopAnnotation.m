//
//  BusStopAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusStopAnnotation.h"

#define kIDKey @"sid" 
#define kRoutesKey @"routes"

@implementation BusStopAnnotation

- (id)initWithID:(NSInteger)sID latitude:(float)lat longitude:(float)lng routes:(NSArray*)rts
{
    if ((self = [super init]))
    {
        _longitude = lng;
        _latitude = lat;
        self.stopID = sID;
        self.routes = rts;
        return self;
    }
    
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.stopID forKey:kIDKey];
    [aCoder encodeObject:self.routes forKey:kRoutesKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.stopID = [aDecoder decodeIntegerForKey:kIDKey];
        self.routes = [aDecoder decodeObjectForKey:kRoutesKey];
    }
    return self;
}

@end
