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
#define kBrunch @"brunch"
#define kTimeSpan @"timespan"
#define kBreakTime @"breaktime" 
#define kBrunchTime @"brunchtime" 
#define kLunchTime @"lunchtime" 
#define kDinnerTime @"dinnertime" 
#define kLateTiem @"latetime"

@implementation Menu

- (id)init
{
    if ((self = [super init]))
    {
        self.breakfast = [[NSMutableArray alloc] init];
        self.lunch = [[NSMutableArray alloc] init];
        self.dinner = [[NSMutableArray alloc] init];
        self.lateNight = [[NSMutableArray alloc] init];
        self.brunch = [[NSMutableArray alloc] init];
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
        self.timeSpan = [aDecoder decodeObjectForKey:kTimeSpan];
        self.brunch = [aDecoder decodeObjectForKey:kBrunch];
        self.breakfastTime = [aDecoder decodeObjectForKey:kBreakTime];
        self.brunchTime = [aDecoder decodeObjectForKey:kBrunchTime];
        self.lunchTime = [aDecoder decodeObjectForKey:kLunchTime];
        self.dinnerTime = [aDecoder decodeObjectForKey:kDinnerTime];
        self.lateNightTime = [aDecoder decodeObjectForKey:kLateTiem];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.breakfast forKey:kBreakfast];
    [aCoder encodeObject:self.lunch forKey:kLunch];
    [aCoder encodeObject:self.dinner forKey:kDinner];
    [aCoder encodeObject:self.brunch forKey:kBrunch];
    [aCoder encodeObject:self.lateNight forKey:kLateNight];
    [aCoder encodeObject:self.timeSpan forKey:kTimeSpan];
    [aCoder encodeObject:self.breakfastTime forKey:kBreakTime];
    [aCoder encodeObject:self.brunchTime forKey:kBrunchTime];
    [aCoder encodeObject:self.lunchTime forKey:kLunchTime];
    [aCoder encodeObject:self.dinnerTime forKey:kDinnerTime];
    [aCoder encodeObject:self.lateNightTime forKey:kLateTiem];
}

@end
