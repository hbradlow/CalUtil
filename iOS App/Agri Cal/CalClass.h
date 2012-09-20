//
//  CalClass.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import <Foundation/Foundation.h>

@interface CalClass : NSObject <NSCoding>

@property (nonatomic, copy) NSString *ccn;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *enrolled;
@property (nonatomic, copy) NSString *enrolledLimit;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *instructor;
@property (nonatomic, copy) NSString *availableSeats;
@property (nonatomic, copy) NSString *units;
@property (nonatomic, copy) NSString *waitlist;
@property (nonatomic, copy) NSString *uniqueID;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *finalExamGroup;
@property BOOL hasWebcast;

@end
