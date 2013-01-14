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
        return [self loadBlock:block withExtension:self.urlString andSet:set];
    }
}

- (BOOL)loadBlock:(void (^) (NSMutableArray*))block withExtension:(NSString*)extension andSet:(NSSet*)set
{
    NSString *queryString = [NSString stringWithFormat:@"%@%@", ServerURL, extension];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLResponse *response = nil;
    
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
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
        return [self loadBlock:block withExtension:[[receivedDict objectForKey:@"meta"] objectForKey:@"next"] andSet:set];
    }
    else
    {
        [self saveData:set];
        self.lastUpdate = [NSDate date];
        return YES;
    }
}

- (void)saveData:(NSSet*)dataArray{
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
