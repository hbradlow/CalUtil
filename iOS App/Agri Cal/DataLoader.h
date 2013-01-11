//
//  DataLoader.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/10/13.
//
//

#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

@property (nonatomic, copy) NSString *urlString;

- (id)initWithUrlString:(NSString*)urlString;
- (NSArray*)loadDataWithCompletionBlock:(NSArray* (^) (NSArray*))block error:(NSError*)error;

@end
