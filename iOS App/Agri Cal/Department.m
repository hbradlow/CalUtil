//
//  Department.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import "Department.h"

#define kTitleKey @"title"
#define kExtensionKey @"abbreviation"

@implementation Department

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.departmentID = [aDecoder decodeObjectForKey:kExtensionKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.departmentID forKey:kExtensionKey];
}

@end
