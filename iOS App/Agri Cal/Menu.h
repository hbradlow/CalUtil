//
//  Menu.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import <Foundation/Foundation.h>
#import "Dish.h"

@interface Menu : NSObject <NSCoding>

@property (nonatomic, retain) NSMutableArray *breakfast;
@property (nonatomic, retain) NSMutableArray *lunch;
@property (nonatomic, retain) NSMutableArray *dinner;
@property (nonatomic, retain) NSMutableArray *lateNight;

@end
