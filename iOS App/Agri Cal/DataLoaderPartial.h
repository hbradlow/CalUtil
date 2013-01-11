//
//  DataLoaderPartial.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/10/13.
//
//

#import <Foundation/Foundation.h>
#import "DataLoader.h"

@interface DataLoaderPartial : DataLoader

@property (nonatomic) NSInteger numberOfObjectsPerSeq;

- (NSArray*)loadDataWithCompletionBlock:(NSArray* (^) (NSArray*))block andExtension:(NSString*)extension error:(NSError*)error;

@end
