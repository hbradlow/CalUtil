//
//  NewsStory.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/12/12.
//
//

#import <Foundation/Foundation.h>

@interface NewsStory : NSObject <NSCoding>

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *published;

@end
