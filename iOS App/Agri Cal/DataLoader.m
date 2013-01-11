//
//  DataLoader.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/10/13.
//
//

#import "DataLoader.h"

@implementation DataLoader

- (id)initWithUrlString:(NSString*)urlString
{
    if ((self = [super init])) {
        self.urlString = urlString;
    }
    return self;
}

- (NSArray*)loadDataWithCompletionBlock:(NSArray* (^) (NSArray*))block error:(NSError*)error
{
    NSString *queryString = [NSString stringWithFormat:@"%@/app_data/cal_one_card/?format=json", ServerURL];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLResponse *response = nil;
    
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
    NSData *receivedData;
    receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                         returningResponse:&response
                                                     error:&error];
    
    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error)
    {
        return nil;
    }
    
    NSArray *arr = [receivedDict objectForKey:@"objects"];
    
    NSArray *result = block(arr);
    
    return result;
}

@end
