//
//  Cal1CardAnnotation.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicMapAnnotation.h"

@interface Cal1CardAnnotation : BasicMapAnnotation <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *times;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSNumber *identifier;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
              andTitle:(NSString*)title
                andURL:(NSString*)url
              andTimes:(NSArray*)times
               andInfo:(NSString*)info;
    

@end
