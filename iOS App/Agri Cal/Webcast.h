//
//  Webcast.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import <Foundation/Foundation.h>

@interface Webcast : NSObject <NSCoding> 

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *number;

@end
