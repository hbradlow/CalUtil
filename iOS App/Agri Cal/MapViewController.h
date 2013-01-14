#import <UIKit/UIKit.h>
#import "BasicMapAnnotation.h"
#import "BusStopAnnotation.h"
#import "BasicMapAnnotationView.h"
#import "Cal1CardAnnotation.h"
#import "DisclosureAnnotationView.h"
#import "InfoView.h"
#import "FrontViewController.h"
#import "DataLoader.h"

@interface MapViewController : FrontViewController  <MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

// The main map view
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Different annotations for the mapview
@property (strong, nonatomic) BasicMapAnnotation *selectedAnnotation;
@property (strong, nonatomic) BasicMapAnnotation *buildingAnnotation;
@property (strong, nonatomic) MKPinAnnotationView *selectedAnnotationView;
@property (strong, nonatomic) DisclosureAnnotationView *disclosureAnnotationView;

@property (strong, nonatomic) NSMutableSet *busStopAnnotations;
@property (strong, nonatomic) NSMutableSet *calCardAnnotations;
@property (strong, nonatomic) NSMutableSet *buildingAnnotations;
@property (strong, nonatomic) NSMutableSet *libraryAnnotations;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *mapKeyImageView;
@property (strong, nonatomic) IBOutlet InfoView *infoView;

@property CLLocationCoordinate2D previousUserLocation;

// The different loaders for the data
@property (nonatomic, strong) DataLoader *cal1Loader;
@property (nonatomic, strong) DataLoader *busLoader;
@property (nonatomic, strong) DataLoader *buildingLoader;
@property (nonatomic, strong) DataLoader *libraryLoader;
@property (nonatomic, strong) DataLoader *libraryTimeLoader;

- (IBAction)switchAnnotations:(id)sender;
- (void)displayInfo:(id)sender;
@end
