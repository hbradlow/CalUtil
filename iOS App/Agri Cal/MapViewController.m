#import "MapViewController.h"

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
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoadedStops"];
    // Loading the stops
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"LoadedStops"])
    {
        NSString *queryString = [NSString stringWithFormat:@"%@/api/bus_stop/?format=json",ServerURL];
        queryString = [queryString lowercaseString];
        
        NSURL *requestURL = [NSURL URLWithString:queryString];
        NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
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
                NSArray *currentRoutes = nil;
                float currentLat = [[currentStop objectForKey:@"latitude"] floatValue];
                float currentLong = [[currentStop objectForKey:@"longitude"] floatValue];
                NSString *title = [currentStop objectForKey:@"title"];
                
                BusStopAnnotation *currentAnnotation = [[BusStopAnnotation alloc] initWithID:currentID latitude:currentLat longitude:currentLong routes:currentRoutes];
                currentAnnotation.title = title;
                [self.busStopAnnotations addObject:currentAnnotation];
            }
            
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            
            dispatch_async(updateUIQueue, ^{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadedStops"];
                if ([self.annotationSelector selectedSegmentIndex] == 0)
                    [self.mapView addAnnotations:self.busStopAnnotations];
            });
        });
    }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Cal1CardLocations"];
    // Loading the cal1card locations
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Cal1CardLocations"])
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            NSString *queryString = [NSString stringWithFormat:@"https://calutil.herokuapp.com/api/locations/"];
            NSURL *requestURL = [NSURL URLWithString:queryString];
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
            
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                         returningResponse:&response
                                                                     error:&error];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
            NSLog(@"cal1card: %@%@", arr, queryString);
            for (NSDictionary *currentLocation in arr)
            {
                NSNumber *latitude = [currentLocation objectForKey:@"latitude"];
                NSNumber *longitude = [currentLocation objectForKey:@"longitude"];
                NSString *info = [currentLocation objectForKey:@"description"];
                NSString *title = [currentLocation objectForKey:@"name"];
                NSString *times = [currentLocation objectForKey:@"times"];
                NSString *imageURL = [currentLocation objectForKey:@"image_url"];
                NSString *type = [currentLocation objectForKey:@"kind"];
                if (latitude != nil)
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Cal1CardLocations"];
                    Cal1CardAnnotation *annotation = [[Cal1CardAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andTitle:title andURL:imageURL andTimes:times andInfo:info];
                    annotation.type = type;
                    [self.calCardAnnotations addObject:annotation];
                }
            }
        });
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    /*
     MKCoordinateRegion region;
     MKCoordinateSpan span;
     span.latitudeDelta = 0.01;
     span.longitudeDelta = 0.01;
     CLLocationCoordinate2D location;
     location.latitude = aUserLocation.coordinate.latitude;
     location.longitude = aUserLocation.coordinate.longitude;
     region.span = span;
     region.center = location;
     [aMapView setRegion:region animated:YES];*/
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (([self.busStopAnnotations containsObject:view.annotation] || [self.calCardAnnotations containsObject:view.annotation])
        && self.selectedAnnotation == nil)
    {
        if (!self.selectedAnnotation)
        {
            self.selectedAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                      andLongitude:view.annotation.coordinate.longitude];
            self.selectedAnnotation.title = view.annotation.title;
        }
        else
        {
            self.selectedAnnotation.coordinate = view.annotation.coordinate;
            self.selectedAnnotation.title = view.annotation.title;
        }
        [self.mapView addAnnotation:self.selectedAnnotation];
        self.selectedAnnotationView = (MKPinAnnotationView*)view;
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
    if (annotation == self.selectedAnnotation)
    {
        DisclosureAnnotationView *callout = (DisclosureAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"callout"];
        if (!callout)
        {
            callout = [[DisclosureAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"callout"];
            callout.contentHeight = 39.0f;
        }
        callout.parentAnnotationView = self.selectedAnnotationView;
        callout.textLabel.text = self.selectedAnnotation.title;
        callout.mapView = self.mapView;
        return callout;
    }
    else if ([self.busStopAnnotations containsObject:annotation])
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BusPin"];
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        return annotationView;
    }
    else if ([self.calCardAnnotations containsObject:annotation])
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalPin"];
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

- (IBAction)displayMapKey:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    CGRect frame = self.mapKeyImageView.frame;
    if (frame.origin.x == 320)
        frame.origin.x -= frame.size.width;
    else {
        frame.origin.x += frame.size.width;
    }
    self.mapKeyImageView.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)switchAnnotations:(id)sender
{
    [self.mapView removeAnnotations:self.calCardAnnotations];
    [self.mapView removeAnnotations:self.busStopAnnotations];
    if (self.buildingAnnotation)
        [self.mapView removeAnnotation:self.buildingAnnotation];
    [self.searchBar setHidden:YES];
    
    switch ([self.annotationSelector selectedSegmentIndex]) {
        case 0:
            [self.mapView addAnnotations:self.busStopAnnotations];
            break;
        case 1:
            [self.mapView addAnnotations:self.calCardAnnotations];
            break;
        case 2:
            [self.searchBar setHidden:NO];
            break;
        default:
            break;
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
