//
//  CalClass.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import "CalClass.h"

#define kTitleKey @"title" 
#define kCCNKey @"ccn" 
#define kTimesKey @"times" 
#define kEnrolledKey @"enrolled" 
#define kEnrolledLimit @"limit" 
#define kWebcastKey @"web" 
#define kSectionsKey @"sections" 

@implementation CalClass

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.times = [aDecoder decodeObjectForKey:kTimesKey];
        self.ccn = [aDecoder decodeObjectForKey:kCCNKey];
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.enrolled = [aDecoder decodeObjectForKey:kEnrolledKey];
        self.enrolledLimit = [aDecoder decodeObjectForKey:kEnrolledLimit];
        self.sections = [aDecoder decodeObjectForKey:kSectionsKey];
        self.hasWebcast = [aDecoder decodeBoolForKey:kWebcastKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.hasWebcast forKey:kWebcastKey];
    [aCoder encodeObject:self.times forKey:kTimesKey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.ccn forKey:kCCNKey];
    [aCoder encodeObject:self.enrolled forKey:kEnrolledLimit];
    [aCoder encodeObject:self.enrolledLimit forKey:kEnrolledLimit];
    [aCoder encodeObject:self.sections forKey:kSectionsKey];
}

@end
