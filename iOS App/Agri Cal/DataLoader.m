//
//  DataLoader.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/10/13.
//
//

#import "DataLoader.h"

@implementation DataLoader

- (id)initWithUrlString:(NSString*)urlString andFilePath:(NSString *)filePath
{
    if ((self = [super init])) {
        self.urlString = urlString;
        self.filePath = filePath;
        self.shouldSave = YES;
    }
    return self;
}

- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block setToSave:(NSMutableSet*)set
{

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:self.filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSSet *loaded_set = [unarchiver decodeObjectForKey:@"filedata"];
        for (NSObject* object in loaded_set)
        {
            [set addObject:object];
        }
        return YES;
    }
    else
    {
        return [self loadBlock:block withExtension:self.urlString andCollection:set];
    }
}
- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block arrayToSave:(NSMutableArray*)array
{
    return [self loadDataWithCompletionBlock:block arrayToSave:array withData:nil];
}
- (BOOL)loadDataWithCompletionBlock:(void (^) (NSMutableArray*))block arrayToSave:(NSMutableArray*)array withData:(NSData*)data
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:self.filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *loaded_set = [unarchiver decodeObjectForKey:@"filedata"];
        for (NSObject* object in loaded_set)
        {
            [array addObject:object];
        }
        return YES;
    }
    else
    {
        return [self loadBlock:block withExtension:self.urlString andCollection:array andData:data];
    }
}

- (BOOL)loadBlock:(void (^) (NSMutableArray*))block withExtension:(NSString*)extension andCollection:(NSObject*)set andData:(NSData*)data
{
    NSString *queryString = [NSString stringWithFormat:@"%@%@", ServerURL, extension];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLResponse *response = nil;
    
    NSMutableURLRequest *jsonRequest = [NSMutableURLRequest requestWithURL:requestURL];
    if (data != nil)
    {
        [jsonRequest setHTTPMethod:@"POST"];
        NSData *requestBody = [[NSString stringWithFormat:@"username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]] dataUsingEncoding:NSUTF8StringEncoding];
        [jsonRequest setHTTPBody:requestBody];
    }
    
    NSData *receivedData;
    NSError *error = nil;
    receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                         returningResponse:&response
                                                     error:&error];
    
    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
    if (error)
    {
        return NO;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[receivedDict objectForKey:@"objects"]];
    
    block(arr);
    
    if (!([[receivedDict objectForKey:@"meta"] objectForKey:@"next"] == [NSNull null]))
    {
        return [self loadBlock:block withExtension:[[receivedDict objectForKey:@"meta"] objectForKey:@"next"] andCollection:set];
    }
    else
    {
        [self saveData:set];
        self.lastUpdate = [NSDate date];
        return YES;
    }
}

- (void)saveData:(NSObject*)dataArray{
    if (self.shouldSave)
    {
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:dataArray forKey:@"filedata"];
        [archiver encodeObject:self.lastUpdate forKey:@"lastupdate"];
        [archiver finishEncoding];
        [data writeToFile:self.filePath atomically:YES];
    }
}

@end
