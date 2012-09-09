//
//  Menu.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import "Menu.h"

#define kBreakfast @"breakfast" 
#define kLunch @"lunch" 
#define kDinner @"dinner" 
#define kLateNight @"latenight" 

@implementation Menu

- (id)init
{
    if ((self = [super init]))
    {
        self.breakfast = [[NSMutableArray alloc] init];
        self.lunch = [[NSMutableArray alloc] init];
        self.dinner = [[NSMutableArray alloc] init];
        self.lateNight = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.breakfast = [aDecoder decodeObjectForKey:kBreakfast];
        self.lunch = [aDecoder decodeObjectForKey:kLunch];
        self.dinner = [aDecoder decodeObjectForKey:kDinner];
        self.lateNight = [aDecoder decodeObjectForKey:kLateNight];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.breakfast forKey:kBreakfast];
    [aCoder encodeObject:self.lunch forKey:kLunch];
    [aCoder encodeObject:self.dinner forKey:kDinner];
    [aCoder encodeObject:self.lateNight forKey:kLateNight];
}

@end
