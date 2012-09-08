//
//  ClassListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import "ClassListViewController.h"
#import "CalClass.h"

#define kClassesPath self.departmentURL
#define kClassesData @"classdata"
#define kClassesKey @"classkey"

@interface ClassListViewController ()

@end

@implementation ClassListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.classes = [[NSMutableArray alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kClassesKey];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kClassesKey])
    {
        dispatch_async(queue, ^{
            [self loadCourses];
        });
    }
    else
    {
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:kClassesPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.classes = [unarchiver decodeObjectForKey:kClassesData];
        [unarchiver finishDecoding];
    }
}

- (void)loadCourses
{
    NSString *queryString = [NSString stringWithFormat:@"%@/api/course/?format=json&department=%@", ServerURL, self.departmentURL];
    NSLog(@"%@", queryString);
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
    NSData *receivedData;
    receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                         returningResponse:&response
                                                     error:&error];
    
    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSArray *arr = [receivedDict objectForKey:@"objects"];
    for (NSDictionary *currentClass in arr)
    {
        CalClass *newClass = [[CalClass alloc] init];
        newClass.title = [currentClass objectForKey:@"abbreviation"];
        [self.classes addObject:newClass];
    }
    [self.classes sortUsingComparator:(NSComparator)^(CalClass *obj1, CalClass *obj2){
        return [obj1.title caseInsensitiveCompare:obj2.title];
    }];
    [self saveCourses];
    
    dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
    dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
}

- (void)saveCourses
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.classes forKey:kClassesData];
    [archiver finishEncoding];
    [data writeToFile:kClassesPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kClassesKey];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.classes objectAtIndex:indexPath.row] title];
    
    return cell;
}

@end
