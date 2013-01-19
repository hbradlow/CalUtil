//
//  DataLoader.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/10/13.
//
//

#import "DataLoader.h"

@implementation DataLoader

static BOOL Debugging = 0;

- (id)initWithUrlString:(NSString*)urlString andFilePath:(NSString *)filePath andDataArray:(NSMutableArray *)array
{
    if ((self = [super init])) {
        self.urlString = urlString;
        self.filePath = filePath;
        self.shouldSave = YES;
        self.dataArray = array;
    }
    return self;
}

- (void)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block
{
    if (Debugging)
        NSLog(@"loadDataWithCompletionBlock");
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:self.filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *loaded_set = [unarchiver decodeObjectForKey:@"filedata"];
        for (NSObject* object in loaded_set)
        {
            [self.dataArray addObject:object];
        }
    }
    else
    {
        [self loadBlock:block withExtension:self.urlString andData:nil];
    }
}
- (void)forceLoadWithCompletionBlock:(void (^) (NSMutableArray*))block withData:(NSData*)data
{
    if (Debugging)
        NSLog(@"forceLoadWithCompletionBlock");
    [self loadBlock:block withExtension:self.urlString andData:data];
}
- (void)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block withData:(NSData*)data
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:self.filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *loaded_set = [unarchiver decodeObjectForKey:@"filedata"];
        for (NSObject* object in loaded_set)
        {
            [array addObject:object];
        }
        if (Debugging)
            NSLog(@"loadDataWithCompletionBlock:withData loaded from file");
    }
    else
    {
        [self loadBlock:block withExtension:self.urlString andData:data];
        if (Debugging)
            NSLog(@"loadDataWithCompletionBlock:withData loaded from url");
    }
}

- (void)loadBlock:(void (^) (NSMutableArray*))block withExtension:(NSString*)extension andData:(NSData*)data
{
    if (Debugging)
        NSLog(@"loadBlock:WithExtension:andData");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *queryString = [NSString stringWithFormat:@"%@%@", ServerURL, extension];
        NSURL *requestURL = [NSURL URLWithString:queryString];
        NSURLResponse *response = nil;
        if (Debugging)
            NSLog(@"loadDataWithCompletionBlock:withData using url %@", queryString);
        NSMutableURLRequest *jsonRequest = [NSMutableURLRequest requestWithURL:requestURL];
        if (data != nil)
        {
            [jsonRequest setHTTPMethod:@"POST"];
            [jsonRequest setHTTPBody:data];
        }
        
        NSData *receivedData;
        NSError *error = nil;
        receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                             returningResponse:&response
                                                         error:&error];
        if (error)
        {
            return;
        }
        NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
        if (error)
        {
            return;
        }
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[receivedDict objectForKey:@"objects"]];
        
        block(arr);
        
        if (!([[receivedDict objectForKey:@"meta"] objectForKey:@"next"] == [NSNull null]))
        {
            [self loadBlock:block withExtension:[[receivedDict objectForKey:@"meta"] objectForKey:@"next"] andData:nil];
        }
        else
        {
            self.lastUpdate = [NSDate date];
        }
    });
}

- (void)save{
    if (self.shouldSave)
    {
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:self.dataArray forKey:@"filedata"];
        [archiver encodeObject:self.lastUpdate forKey:@"lastupdate"];
        [archiver finishEncoding];
        [data writeToFile:self.filePath atomically:YES];
    }
}

@end
