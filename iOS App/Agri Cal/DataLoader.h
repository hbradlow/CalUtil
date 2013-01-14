#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic) BOOL shouldSave;

- (id)initWithUrlString:(NSString*)urlString andFilePath:(NSString*)filePath;
- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block setToSave:(NSSet*)set;
- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block arrayToSave:(NSArray*)array;
- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block arrayToSave:(NSArray*)array withData:(NSData*)data;
- (BOOL)forceLoadWithCompletionBlock:(void (^) (NSMutableArray*))block arrayToSave:(NSArray*)array withData:(NSData*)data;


@end
