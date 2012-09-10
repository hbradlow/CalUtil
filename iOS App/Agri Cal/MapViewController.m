#import "MapViewController.h"
#import "NextBusViewController.h"
#import "Cal1CardViewController.h"

#warning Deals for cal1card?

@implementation MapViewController

static NSString *OffCampus = @"Off-Campus";
static NSString *OnCampus = @"On-campus by Cal Dining";
static float CenterOfCampusLat = 37.870218;
static float CenterOfCampusLong = -122.259481;
static float LatitudeDelta = 0.015;
static float LongitudeDelta = 0.015;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.busStopAnnotations = [[NSMutableArray alloc] init];
    self.calCardAnnotations = [[NSMutableArray alloc] init];
    
    // Setting up the map
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coord = {.latitude =  CenterOfCampusLat, .longitude =  CenterOfCampusLong};
    MKCoordinateSpan span = {.latitudeDelta = LatitudeDelta, .longitudeDelta = LongitudeDelta};
    
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    
    // Loading the stops
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSData *data;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kBusesLoaded])
        {
            data = [[NSMutableData alloc]initWithContentsOfFile:kBusFilePath];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            self.busStopAnnotations = [unarchiver decodeObjectForKey:kBusDataKey];
            [unarchiver finishDecoding];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^{
                [self.mapView addAnnotations:self.busStopAnnotations];
            });
        }
        if (!data)
        {
            [self loadBusStopsWithExtension:@"/api/bus_stop/?format=json"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBusesLoaded];
        }
        
        // Loading the cal1card locations
        NSData *calData;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kCalCardLoaded])
        {
            calData = [[NSMutableData alloc]initWithContentsOfFile:kCalFilePath];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:calData];
            self.calCardAnnotations = [unarchiver decodeObjectForKey:kCalDataKey];
            [unarchiver finishDecoding];
        }
        if (!calData)
        {
            NSLog(@"loading caldata");
            [self loadCal1CardLocations];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCalCardLoaded];
        }
    });
}

- (void)loadCal1CardLocations
{
    NSString *queryString = [NSString stringWithFormat:@"%@/api/cal_one_card/?format=json", ServerURL];
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
    
    for (NSDictionary *currentLocation in arr)
    {
        NSNumber *latitude = [currentLocation objectForKey:@"latitude"];
        NSNumber *longitude = [currentLocation objectForKey:@"longitude"];
        NSString *info = [currentLocation objectForKey:@"info"];
        NSString *title = [currentLocation objectForKey:@"name"];
        NSString *times = [currentLocation objectForKey:@"times"];
        NSString *imageURL = [currentLocation objectForKey:@"image_url"];
        NSString *type = [currentLocation objectForKey:@"type"];
        if (latitude != nil)
        {
            Cal1CardAnnotation *annotation = [[Cal1CardAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andTitle:title andURL:imageURL andTimes:times andInfo:info];
            annotation.type = type;
            annotation.subtitle = type;
            [self.calCardAnnotations addObject:annotation];
        }
    }
    if ([self.annotationSelector selectedSegmentIndex] == 1)
    {
        [self.mapView removeAnnotations:self.busStopAnnotations];
        [self.mapView addAnnotations:self.calCardAnnotations];
    }
    [self saveCalCardLocationsToFile];
}

- (void)saveCalCardLocationsToFile
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.calCardAnnotations forKey:kCalDataKey];
    [archiver finishEncoding];
    [data writeToFile:kCalFilePath atomically:YES];
}

- (void)saveBusesToFile
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.busStopAnnotations forKey:kBusDataKey];
    [archiver finishEncoding];
    [data writeToFile:kBusFilePath atomically:YES];
}

- (void)loadBusStopsWithExtension:(NSString*)urlExtension
{
    NSString *queryString = [NSString stringWithFormat:@"%@%@",ServerURL, urlExtension];
    queryString = [queryString lowercaseString];
    NSLog(@"loading buses %@", queryString);
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                 returningResponse:&response
                                                             error:&error];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSArray *stops = [dict objectForKey:@"objects"];
    
    for (NSDictionary *currentStop in stops)
    {
        NSInteger currentID = [[currentStop objectForKey:@"stop_id"] integerValue];
        NSArray *currentRoutes = [currentStop objectForKey:@"lines"];
        float currentLat = [[currentStop objectForKey:@"latitude"] floatValue];
        float currentLong = [[currentStop objectForKey:@"longitude"] floatValue];
        NSString *title = [currentStop objectForKey:@"title"];
        
        BusStopAnnotation *currentAnnotation = [[BusStopAnnotation alloc] initWithID:currentID latitude:currentLat longitude:currentLong routes:currentRoutes];
        currentAnnotation.title = title;
        NSString *subtitle = @"";
        for (NSDictionary *currentLine in currentRoutes)
        {
            subtitle = [subtitle stringByAppendingFormat:@"%@ ",[currentLine objectForKey:@"title"]];
        }
        currentAnnotation.subtitle = subtitle;
        [self.busStopAnnotations addObject:currentAnnotation];
    }
    
    if (!([[dict objectForKey:@"meta"] objectForKey:@"next"] == [NSNull null]))
    {
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            if ([self.annotationSelector selectedSegmentIndex] == 0)
            {
                [self.mapView removeAnnotations:self.busStopAnnotations];
                [self.mapView addAnnotations:self.busStopAnnotations];
            }
        });
        [self loadBusStopsWithExtension:[[dict objectForKey:@"meta"] objectForKey:@"next"]];
    }
    else
    {
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            if ([self.annotationSelector selectedSegmentIndex] == 0)
            {
                [self.mapView removeAnnotations:self.busStopAnnotations];
                [self.mapView addAnnotations:self.busStopAnnotations];
            }
        });
        [self saveBusesToFile];
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    if (!self.previousUserLocation.latitude
        || abs(self.previousUserLocation.latitude - aUserLocation.location.coordinate.latitude) > 0.005/2
        || abs(self.previousUserLocation.longitude - aUserLocation.location.coordinate.longitude) > 0.005/2)
    {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
        self.previousUserLocation = location;
}
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (([self.busStopAnnotations containsObject:view.annotation] || [self.calCardAnnotations containsObject:view.annotation])
        && self.selectedAnnotation == nil)
    {
        self.selectedAnnotation = (BasicMapAnnotation*)view.annotation;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (self.selectedAnnotation && !((BasicMapAnnotationView*)view).preventSelectionChange)
    {
        [self.mapView removeAnnotation:self.selectedAnnotation];
        self.selectedAnnotation = nil;
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([self.busStopAnnotations containsObject:annotation])
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BusPin"];
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(displayInfo:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;
        return annotationView;
    }
    else if ([self.calCardAnnotations containsObject:annotation])
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalPin"];
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(displayInfo:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;
        return annotationView;
    }
    return nil;
}

- (IBAction)displayMapKey:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    CGRect frame = self.mapKeyImageView.frame;
    if (frame.origin.x == 320)
    {
        frame.origin.x -= frame.size.width;
        [self.mapKeyImageView setHidden:YES];
    }
    else {
        frame.origin.x += frame.size.width;
        [self.mapKeyImageView setHidden:NO];
    }
    self.mapKeyImageView.frame = frame;
    [UIView commitAnimations];
}

- (void)displayInfo:(id)sender
{
    NSLog(@"display info %@", self.selectedAnnotation);
    if ([self.busStopAnnotations containsObject:self.selectedAnnotation])
    {
        [self performSegueWithIdentifier:@"bus" sender:self.selectedAnnotation];
    }
    else if ([self.calCardAnnotations containsObject:self.selectedAnnotation])
    {
        [self performSegueWithIdentifier:@"calcard" sender:self.selectedAnnotation];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"bus"])
    {
        NextBusViewController *nextController = (NextBusViewController*)[segue destinationViewController];
        nextController.annotation = (BusStopAnnotation*)sender;
        nextController.lines = [[NSMutableArray alloc] init];
        for (NSDictionary *currentLine in nextController.annotation.routes)
        {
            [nextController.lines addObject:currentLine];
        }
    }
    else if ([[segue identifier] isEqualToString:@"calcard"])
    {
        Cal1CardViewController *nextController = (Cal1CardViewController*)[segue destinationViewController];
        nextController.annotation = (Cal1CardAnnotation*)sender;
        nextController.navigationItem.title = ((Cal1CardAnnotation*)sender).title;
    }
}

- (IBAction)switchAnnotations:(id)sender
{
    NSInteger selectedIndex = [self.annotationSelector selectedSegmentIndex];
    if (selectedIndex == 0)
    {
        [self.mapView removeAnnotations:self.calCardAnnotations];
        if (self.buildingAnnotation)
            [self.mapView removeAnnotation:self.buildingAnnotation];
        if (self.selectedAnnotation)
            [self.mapView removeAnnotation:self.selectedAnnotation];
    }
    else if (selectedIndex == 1)
    {
        [self.mapView removeAnnotations:self.busStopAnnotations];
        if (self.buildingAnnotation)
            [self.mapView removeAnnotation:self.buildingAnnotation];
        if (self.selectedAnnotation)
            [self.mapView removeAnnotation:self.selectedAnnotation];
    }
    else if (selectedIndex == 2)
    {
        [self.mapView removeAnnotations:self.busStopAnnotations];
        [self.mapView removeAnnotations:self.calCardAnnotations];
        if (self.selectedAnnotation)
            [self.mapView removeAnnotation:self.selectedAnnotation];
    }
    [self.annotationSelector setTitle:@"Cal1Card" forSegmentAtIndex:1];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^(){
        
        
        [self.searchBar setHidden:YES];
        switch ([self.annotationSelector selectedSegmentIndex]) {
            case 0:
            {
                dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
                dispatch_async(updateUIQueue, ^{
                    [self.mapView addAnnotations:self.busStopAnnotations];
                });
                break;
            }
            case 1:
            {
                dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
                dispatch_async(updateUIQueue, ^{
                    [self.mapView addAnnotations:self.calCardAnnotations];
                });
                [self updateCal1Balance];
                break;
            }
            case 2:
            {
                [self.searchBar setHidden:NO];
                break;
            }
            default:
                break;
        }
    });
}

- (void)updateCal1Balance
{
    NSString *queryString = [NSString stringWithFormat:@"%@/balance/?username=%@&password=%@", ServerURL, [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSError *error = nil;
    
    NSString *result = [NSString stringWithContentsOfURL:requestURL encoding:NSUTF8StringEncoding error:&error];
    if (!error)
    {
        if ([self.annotationSelector selectedSegmentIndex] == 1)
        {
            if ([result isEqualToString:@""] || [result isEqual:[NSNull null]] || !result)
            {
                [self.annotationSelector setTitle:@"Loading..." forSegmentAtIndex:1];
                [self updateCal1Balance];
            }
            else
                [self.annotationSelector setTitle:[NSString stringWithFormat:@"$%@",result] forSegmentAtIndex:1];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding)];
}

/*
 Uses the google maps api to search for buldings in Berkeley.
 */
-(void)searchForBuilding
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    searchString = [NSString stringWithFormat:@"%@ %@", searchString, @"berkeley"];
    searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([searchString isEqualToString:@"berkeley"])
        return;
    searchString = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url= [[NSURL alloc] initWithString:searchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    @try {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (receivedData)
                self.searchResults = [[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil] objectForKey:@"results"];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        });
    }
    @catch (NSException *exception) {
        NSLog(@"error");
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding) withObject:nil afterDelay:1.0];
}

/*
 Everything below here is related to the table view, and just handles
 the customization of the cells etc.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    if (![self.searchResults count])
        cell.textLabel.text = @"Searching...";
    else {
        NSLog(@"%@", [self.searchResults objectAtIndex:indexPath.row]);
        NSArray *partsOfName = [[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"] componentsSeparatedByString:@","];
        NSString *shortName = [partsOfName objectAtIndex:0];
        NSString *detailText = @"";
        if ([partsOfName count] > 3)
            detailText = [NSString stringWithFormat:@"%@,%@,%@", [partsOfName objectAtIndex:1], [partsOfName objectAtIndex:2], [partsOfName objectAtIndex:3]];
        else if([partsOfName count]>2)
            detailText = [NSString stringWithFormat:@"%@,%@", [partsOfName objectAtIndex:1], [partsOfName objectAtIndex:2]];
        else if([partsOfName count]>1)
            detailText = [NSString stringWithFormat:@"%@", [partsOfName objectAtIndex:1]];
        else
            detailText = @"";
        cell.textLabel.text = shortName;
        cell.detailTextLabel.text = detailText;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.buildingAnnotation)
    {
        [self.mapView deselectAnnotation:self.buildingAnnotation animated:NO];
        [self.mapView removeAnnotation:self.buildingAnnotation];
    }
    self.searchDisplayController.searchBar.text = @"";
    NSString *lat =  [[[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    NSString *lng =  [[[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    self.buildingAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:[lat doubleValue] andLongitude:[lng doubleValue]];
    self.buildingAnnotation.title = [[[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"] componentsSeparatedByString:@","] objectAtIndex:0];
    [self.mapView addAnnotation:self.buildingAnnotation];
    [self.mapView setCenterCoordinate:self.buildingAnnotation.coordinate];
    [self.searchDisplayController setActive:NO animated:YES];
    self.searchResults = [[NSMutableArray alloc] init];
    [self performSelector:@selector(selectBuilding) withObject:nil afterDelay:0.7];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Map Key";
}

-(void)selectBuilding
{
    [self.mapView selectAnnotation:self.buildingAnnotation animated:YES];
}

- (void)viewDidUnload {
    [self setAnnotationSelector:nil];
    [self setWebView:nil];
    [self setNavigationBar:nil];
    [self setSearchBar:nil];
    [self setMapKeyImageView:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
}

@end
