#import "MapViewController.h"
#import "NextBusViewController.h"
#import "Cal1CardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CURefreshButton.h"

@implementation MapViewController

static NSString *OffCampus = @"Off-Campus";
static NSString *OnCampus = @"On-campus by Cal Dining";
static float CenterOfCampusLat = 37.870218;
static float CenterOfCampusLong = -122.259481;
static float LatitudeDelta = 0.015;
static float LongitudeDelta = 0.015;

- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"]
                                                 bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"maps"];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.busStopAnnotations = [[NSMutableArray alloc] init];
    self.calCardAnnotations = [[NSMutableArray alloc] init];
    self.libraryAnnotations = [[NSMutableArray alloc] init];
    self.buildingAnnotations = [[NSMutableArray alloc] init];
    
/** Setting up the map */
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coord = {.latitude =  CenterOfCampusLat, .longitude =  CenterOfCampusLong};
    MKCoordinateSpan span = {.latitudeDelta = LatitudeDelta, .longitudeDelta = LongitudeDelta};
    
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    
    [[self.mapView layer] setMasksToBounds:NO];
    [[self.mapView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.mapView layer] setShadowOpacity:1.0f];
    [[self.mapView layer] setShadowRadius:6.0f];
    [[self.mapView layer] setShadowOffset:CGSizeMake(0, 3)];
    [self.mapView setNeedsDisplay];

    [self setRightBarButton];

/** Set up the loaders and do the initial loading */
    self.busLoader = [[DataLoader alloc] initWithUrlString:@"/app_data/bus_stop/?format=json"
                                               andFilePath:kBusFilePath
                                              andDataArray:self.busStopAnnotations];
    [self loadBusStops:NO];
    self.cal1Loader = [[DataLoader alloc] initWithUrlString:@"/app_data/cal_one_card/?format=json"
                                                andFilePath:kCalFilePath
                                               andDataArray:self.calCardAnnotations];
    [self loadCal1CardLocations:NO];
    self.libraryLoader = [[DataLoader alloc] initWithUrlString:@"/app_data/library/?format=json"
                                                   andFilePath:kLibraryFilePath
                                                  andDataArray:self.libraryAnnotations];
    [self loadLibraries:NO];
    self.buildingLoader = [[DataLoader alloc] initWithUrlString:@"/app_data/building/?format=json"
                                                    andFilePath:kBuildingFilePath
                                                   andDataArray:self.buildingAnnotations];
    [self loadBuildings:NO];
    self.libraryTimeLoader = [[DataLoader alloc] initWithUrlString:@"/api/library_hours/" andFilePath:nil andDataArray:nil];
    self.libraryTimeLoader.shouldSave = NO;
    [self loadLibraryTimes];
    
    self.calTimeLoader = [[DataLoader alloc] initWithUrlString:@"/api/cal1card_hours/" andFilePath:nil andDataArray:nil];
    self.calTimeLoader.shouldSave = NO;
    [self loadCalTimes];
    
/** Set up the segmented control UI */
    UIImage *segmentUnselected = [UIImage imageNamed:@"segbgwhite"];
    UIImage *segmentSelected = [UIImage imageNamed:@"segbgwhite"];
    
    [self.annotationSelector setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.annotationSelector setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.annotationSelector.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}

- (void)setRightBarButton
{
    CGRect frame = CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
    CURefreshButton *a1 = [[CURefreshButton alloc] initWithFrame:frame];
    [a1 addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"refreshbutton"] forState:UIControlStateNormal];
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
    [self.navigationItem setRightBarButtonItem:random animated:YES];
}

- (void)loadCal1CardLocations:(BOOL)forced{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentLocation in arr)
        {
            NSNumber *latitude = [currentLocation objectForKey:@"latitude"];
            NSNumber *longitude = [currentLocation objectForKey:@"longitude"];
            NSString *info = [currentLocation objectForKey:@"info"];
            NSString *title = [currentLocation objectForKey:@"name"];
            NSArray *times = [currentLocation objectForKey:@"times"];
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", ServerURL,[currentLocation objectForKey:@"image_url"]];
            NSString *type = [currentLocation objectForKey:@"type"];
            NSNumber *identifier = [currentLocation objectForKey:@"id"];
            if (latitude != nil)
            {
                Cal1CardAnnotation *annotation = [[Cal1CardAnnotation alloc] initWithLatitude:[latitude doubleValue]
                                                                                 andLongitude:[longitude doubleValue]
                                                                                     andTitle:title
                                                                                       andURL:imageURL
                                                                                     andTimes:times
                                                                                      andInfo:info];
                annotation.type = type;
                annotation.identifier = identifier;
                [self.calCardAnnotations addObject:annotation];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setRightBarButton];
        });
        [self switchAnnotations:self];
    };
    if (forced)
        [self.cal1Loader forceLoadWithCompletionBlock:block withData:nil];
    else
        [self.cal1Loader loadDataWithCompletionBlock:block];
    [self switchAnnotations:self];
}

- (void)loadBusStops:(BOOL)forced{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentStop in arr)
        {
            NSString *currentID = [currentStop objectForKey:@"stop_id"];
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
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setRightBarButton];
        });
        [self switchAnnotations:self];
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (forced)
            [self.busLoader forceLoadWithCompletionBlock:block withData:nil];
        else
            [self.busLoader loadDataWithCompletionBlock:block];
        [self switchAnnotations:self];
    });
}

- (void)loadBuildings:(BOOL)forced
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentLocation in arr)
        {
            NSNumber *latitude = [currentLocation objectForKey:@"latitude"];
            NSNumber *longitude = [currentLocation objectForKey:@"longitude"];
            NSString *info = [currentLocation objectForKey:@"description"];
            NSString *title = [currentLocation objectForKey:@"name"];
            NSString *imageURL = [currentLocation objectForKey:@"image_url"];
            
            if (latitude != nil && (NSNull*)latitude != [NSNull null])
            {
                Cal1CardAnnotation *annotation = [[Cal1CardAnnotation alloc] initWithLatitude:[latitude doubleValue]
                                                                                 andLongitude:[longitude doubleValue]
                                                                                     andTitle:title
                                                                                       andURL:imageURL
                                                                                     andTimes:nil
                                                                                      andInfo:info];
                [self.buildingAnnotations addObject:annotation];
                NSString *timeString = [[arr objectAtIndex:[annotation.identifier integerValue]] objectForKey:@"built"];
                annotation.times = @[@{@"span" : timeString}];
                annotation.type = kBuildingType;
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setRightBarButton];
        });
        [self switchAnnotations:self];
    };
    if (forced)
        [self.buildingLoader forceLoadWithCompletionBlock:block withData:nil];
    else
        [self.buildingLoader loadDataWithCompletionBlock:block];
    [self switchAnnotations:self];
}

-(void)loadLibraries:(BOOL)forced
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentLocation in arr)
        {
            NSNumber *latitude = [currentLocation objectForKey:@"latitude"];
            NSNumber *longitude = [currentLocation objectForKey:@"longitude"];
            NSString *info = [currentLocation objectForKey:@"description"];
            NSString *title = [currentLocation objectForKey:@"name"];
            NSString *imageURL = [currentLocation objectForKey:@"image_url"];
            NSNumber *identifier = [currentLocation objectForKey:@"id"];
            
            if (latitude != nil && (NSNull*)latitude != [NSNull null])
            {
                Cal1CardAnnotation *annotation = [[Cal1CardAnnotation alloc] initWithLatitude:[latitude doubleValue]
                                                                                 andLongitude:[longitude doubleValue]
                                                                                     andTitle:title
                                                                                       andURL:imageURL
                                                                                     andTimes:nil
                                                                                      andInfo:info];
                annotation.identifier = identifier;
                [self.libraryAnnotations addObject:annotation];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self setRightBarButton];
            });
        }
        [self switchAnnotations:self];
    };
    if (!forced)
        [self.libraryLoader loadDataWithCompletionBlock:block];
    else
        [self.libraryLoader forceLoadWithCompletionBlock:block withData:nil];
    [self switchAnnotations:self];
}

- (void)loadLibraryTimes
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"id >= 0"];
        
        [arr filterUsingPredicate:resultPredicate];
        [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b){
            NSInteger aId = [[a objectForKey:@"id"] integerValue];
            NSInteger bId = [[b objectForKey:@"id"] integerValue];
            if (aId < bId)
                return NSOrderedAscending;
            if (aId > bId)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        for (Cal1CardAnnotation *annotation in self.libraryAnnotations)
        {
            if ([annotation.identifier integerValue] < [arr count])
            {
                NSString *timeString = [[arr objectAtIndex:[annotation.identifier integerValue]] objectForKey:@"times"];
                annotation.times = @[@{@"span" : timeString}];
                annotation.subtitle = [NSString stringWithFormat:@"%@", timeString];
            }
        }
    };
    [self.libraryTimeLoader loadDataWithCompletionBlock:block];
}

- (void)loadCalTimes
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"id >= 0"];
        
        [arr filterUsingPredicate:resultPredicate];
        [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b){
            NSInteger aId = [[a objectForKey:@"id"] integerValue];
            NSInteger bId = [[b objectForKey:@"id"] integerValue];
            if (aId < bId)
                return NSOrderedAscending;
            if (aId > bId)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        for (Cal1CardAnnotation *annotation in self.calCardAnnotations)
        {
            if ([annotation.identifier integerValue] < [arr count])
            {
                NSString *timeString = [[arr objectAtIndex:[annotation.identifier integerValue]] objectForKey:@"times"];
                annotation.times = @[@{@"span" : timeString}];
                annotation.subtitle = [NSString stringWithFormat:@"%@", timeString];
                if ([[self.mapView annotations] containsObject:annotation])
                {
                    [self.mapView removeAnnotation:annotation];
                    [self.mapView addAnnotation:annotation];
                }
            }
        }
    };
    [self.calTimeLoader loadDataWithCompletionBlock:block];
}

- (void)centerOnUser
{
    MKUserLocation *aUserLocation = self.mapView.userLocation;
    if (aUserLocation.location.horizontalAccuracy < 0)
        return;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    if (TARGET_IPHONE_SIMULATOR)
    {
        location.latitude = 37.874908;
        location.longitude = -122.260521;
    }
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
    self.previousUserLocation = location;
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    if (!self.previousUserLocation.latitude
        || abs(self.previousUserLocation.latitude - aUserLocation.location.coordinate.latitude) > 0.005/2
        || abs(self.previousUserLocation.longitude - aUserLocation.location.coordinate.longitude) > 0.005/2)
    {
        [self centerOnUser];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([self.buildingAnnotations containsObject:view.annotation])
        self.buildingAnnotation = (BasicMapAnnotation*)view.annotation;
    self.selectedAnnotation = (BasicMapAnnotation*)view.annotation;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if (self.selectedAnnotation && !((BasicMapAnnotationView*)view).preventSelectionChange)
    {
        self.selectedAnnotation = nil;
    }
    if (view.annotation == self.buildingAnnotation)
    {
        [self.mapView removeAnnotation:view.annotation];
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
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
    else 
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalPin"];
        annotationView.canShowCallout = NO;
        if ([self.libraryAnnotations containsObject:annotation])
        {
            NSString *timeString = [[((Cal1CardAnnotation*)annotation).times objectAtIndex:0] objectForKey:@"span"];
            if ([timeString isEqualToString:@"Closed"])
                annotationView.pinColor = MKPinAnnotationColorRed;
        }
        else
            annotationView.pinColor = MKPinAnnotationColorGreen;
        if ([self.buildingAnnotations containsObject:annotation])
            annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(displayInfo:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;
        return annotationView;
    }
    return nil;
}

- (void)displayInfo:(id)sender{
    if ([self.busStopAnnotations containsObject:self.selectedAnnotation])
    {
        [self performSegueWithIdentifier:@"bus" sender:self.selectedAnnotation];
    }
    else 
    {
        NSLog(@"display info %@", self.selectedAnnotation);
        [self performSegueWithIdentifier:@"calcard" sender:self.selectedAnnotation];
    }
}

- (IBAction)refresh:(id)sender {
    NSInteger index = self.annotationSelector.selectedSegmentIndex;
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 30)];
    iv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.navigationBar setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:iv] animated:YES];
    [iv startAnimating];
    if (index == 0)
        [self loadBusStops:YES];
    else if (index == 1)
    {
        [self loadCal1CardLocations:YES];
        [self loadCalTimes];
    }
    else
    {
        [self loadLibraries:YES];
        [self loadLibraryTimes];
    }
    [self loadBuildings:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
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
        NSLog(@"%@", sender);
        Cal1CardViewController *nextController = (Cal1CardViewController*)[segue destinationViewController];
        nextController.annotation = (Cal1CardAnnotation*)sender;
        nextController.navigationItem.title = ((Cal1CardAnnotation*)sender).title;
        if ([self.buildingAnnotations containsObject:sender])
            nextController.type = kBuildingType;
        else if ([self.libraryAnnotations containsObject:sender])
            nextController.type = kLibType;
        else
            nextController.type = kCalType;
    }
}

- (IBAction)switchAnnotations:(id)sender{
    NSInteger selectedIndex = [self.annotationSelector selectedSegmentIndex];
    if (selectedIndex == 0)
    {
        [self.mapView removeAnnotations:self.calCardAnnotations];
        [self.mapView removeAnnotations:self.libraryAnnotations];
        if (self.buildingAnnotation)
            [self.mapView removeAnnotation:self.buildingAnnotation];
        if (self.selectedAnnotation)
            [self.mapView removeAnnotation:self.selectedAnnotation];
    }
    else if (selectedIndex == 1)
    {
        [self.mapView removeAnnotations:self.busStopAnnotations];
        [self.mapView removeAnnotations:self.libraryAnnotations];
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
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^(){
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
                break;
            }
            case 2:
            {
                dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
                dispatch_async(updateUIQueue, ^{
                    [self.mapView addAnnotations:self.libraryAnnotations];
                });
                break;
            }
            default:
                break;
        }
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding)];
}

/*
 Uses the google maps api to search for buldings in Berkeley.
 */
-(void)searchForBuilding{
    NSString *searchText = self.searchBar.text;
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[cd] %@",
                                    searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.buildingAnnotations filteredArrayUsingPredicate:resultPredicate]];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding) withObject:nil afterDelay:0];
}

/*
 Everything below here is related to the table view, and just handles
 the customization of the cells etc.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResults count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    if (![self.searchResults count])
        cell.textLabel.text = @"Searching...";
    else {
        Cal1CardAnnotation *annotation = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = annotation.title;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchDisplayController.searchBar.text = @"";
    Cal1CardAnnotation *annotation = [self.searchResults objectAtIndex:indexPath.row];
    self.buildingAnnotation = annotation;
    [self.mapView addAnnotation:self.buildingAnnotation];
    [self.mapView setCenterCoordinate:self.buildingAnnotation.coordinate];
    [self.searchDisplayController setActive:NO animated:YES];
    self.searchResults = [[NSMutableArray alloc] init];
    [self performSelector:@selector(selectBuilding) withObject:nil afterDelay:0.7];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Map Key";
}

-(void)selectBuilding{
    [self.mapView selectAnnotation:self.buildingAnnotation animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.busLoader save];
        [self.libraryLoader save];
        [self.cal1Loader save];
        [self.buildingLoader save];
    });
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setAnnotationSelector:nil];
    [self setWebView:nil];
    [self setNavigationBar:nil];
    [self setSearchBar:nil];
    [self setMapKeyImageView:nil];
    [self setInfoButton:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

@end
