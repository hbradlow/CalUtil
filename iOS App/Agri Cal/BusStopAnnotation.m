//
//  BusStopAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusStopAnnotation.h"

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

@end
