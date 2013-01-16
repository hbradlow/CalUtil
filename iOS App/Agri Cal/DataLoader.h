#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic) BOOL shouldSave;

- (id)initWithUrlString:(NSString*)urlString
            andFilePath:(NSString*)filePath
           andDataArray:(NSMutableArray*)array;
- (void)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block;
- (void)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block;
- (void)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block
                           withData:(NSData*)data;
- (void)forceLoadWithCompletionBlock:(void (^) (NSMutableArray*))block
                            withData:(NSData*)data;
- (void)save;


@end
