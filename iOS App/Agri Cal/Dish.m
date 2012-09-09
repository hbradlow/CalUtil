//
//  Dish.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import "Dish.h"

#define kNameKey @"name" 
#define kNutInfo @"nutinfo" 
#define kTypeKey @"type"

@implementation Dish

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.name = [aDecoder decodeObjectForKey:kNameKey];
        self.nutritionURL = [aDecoder decodeObjectForKey:kNutInfo];
        self.type = [aDecoder decodeObjectForKey:kTypeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeObject:self.nutritionURL forKey:kNutInfo];
    [aCoder encodeObject:self.type forKey:kTypeKey];
}

@end
