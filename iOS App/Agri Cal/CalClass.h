//
//  CalClass.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import <Foundation/Foundation.h>

@interface CalClass : NSObject <NSCoding>

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, copy) NSString *ccn;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *enrolled;
@property (nonatomic, copy) NSString *enrolledLimit;
@property BOOL hasWebcast;

@end
