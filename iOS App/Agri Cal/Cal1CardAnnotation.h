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

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *imageURL;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
              andTitle:(NSString*)title
                andURL:(NSString*)url
              andTimes:(NSString*)times
               andInfo:(NSString*)info;
    

@end
