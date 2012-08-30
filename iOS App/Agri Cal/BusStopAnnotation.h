//
//  BusStopAnnotation.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicMapAnnotation.h"

@interface BusStopAnnotation : BasicMapAnnotation

@property (nonatomic) NSInteger stopID;
@property (nonatomic, strong) NSArray *routes;

- (id)initWithID:(NSInteger)sID latitude:(float)lat longitude:(float)lng routes:(NSArray*)rts;

@end
