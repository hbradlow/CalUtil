//
//  Webcast.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import "Webcast.h"

#define kURLkey @"url" 
#define kTitleKey @"title" 
#define kNumberKey @"number"

@implementation Webcast
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self=[super init]))
    {
        self.url = [aDecoder decodeObjectForKey:kURLkey];
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.number = [aDecoder decodeObjectForKey:kNumberKey];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:kURLkey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.number forKey:kNumberKey];
}
@end
