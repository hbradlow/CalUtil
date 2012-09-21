//
//  NewsStory.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/12/12.
//
//

#import "NewsStory.h"
#define kTitleKey @"title" 
#define kSummaryKey @"summary" 
#define kContentKey @"content" 
#define kPublishedKey @"published"
@implementation NewsStory
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.summary = [aDecoder decodeObjectForKey:kSummaryKey];
        self.published = [aDecoder decodeObjectForKey:kPublishedKey];
        self.content = [aDecoder decodeObjectForKey:kContentKey];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.summary forKey:kSummaryKey];
    [aCoder encodeObject:self.published forKey:kPublishedKey];
    [aCoder encodeObject:self.content forKey:kContentKey];
}
@end
