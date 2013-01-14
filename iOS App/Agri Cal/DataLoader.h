#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic) BOOL shouldSave;

- (id)initWithUrlString:(NSString*)urlString andFilePath:(NSString*)filePath;
- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block setToSave:(NSSet*)array;

@end
