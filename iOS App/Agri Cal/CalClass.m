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
#define kEnrolledLimit @"enrolledlimit" 
#define kWebcastKey @"web" 
#define kSectionsKey @"sections" 
#define kLocationKey @"location"
#define kInstructorKey @"instructor"
#define kAvailableSeats @"avs"
#define kUnits @"units" 
#define kWaitlist @"wait"
#define kKey @"key"
#define kNumber @"number"
#define kFinalExam @"finalexam"

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
        self.location = [aDecoder decodeObjectForKey:kLocationKey];
        self.instructor = [aDecoder decodeObjectForKey:kInstructorKey];
        self.waitlist = [aDecoder decodeObjectForKey:kWaitlist];
        self.units = [aDecoder decodeObjectForKey:kUnits];
        self.availableSeats = [aDecoder decodeObjectForKey:kAvailableSeats];
        self.uniqueID = [aDecoder decodeObjectForKey:kKey];
        self.number = [aDecoder decodeObjectForKey:kNumber];
        self.finalExamGroup = [aDecoder decodeObjectForKey:kFinalExam];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.hasWebcast forKey:kWebcastKey];
    [aCoder encodeObject:self.times forKey:kTimesKey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.ccn forKey:kCCNKey];
    [aCoder encodeObject:self.enrolled forKey:kEnrolledKey];
    [aCoder encodeObject:self.enrolledLimit forKey:kEnrolledLimit];
    [aCoder encodeObject:self.sections forKey:kSectionsKey];
    [aCoder encodeObject:self.location forKey:kLocationKey];
    [aCoder encodeObject:self.instructor forKey:kInstructorKey];
    [aCoder encodeObject:self.waitlist forKey:kWaitlist];
    [aCoder encodeObject:self.units forKey:kUnits];
    [aCoder encodeObject:self.availableSeats forKey:kAvailableSeats];
    [aCoder encodeObject:self.uniqueID forKey:kKey];
    [aCoder encodeObject:self.number forKey:kNumber];
    [aCoder encodeObject:self.finalExamGroup forKey:kFinalExam];
}

@end
