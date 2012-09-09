//
//  Dish.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import <Foundation/Foundation.h>

@interface Dish : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nutritionURL;
@property (nonatomic, copy) NSString *type;

@end
