#import <UIKit/UIKit.h>
#import "BasicMapAnnotation.h"
#import "BusStopAnnotation.h"
#import "BasicMapAnnotationView.h"
#import "Cal1CardAnnotation.h"
#import "DisclosureAnnotationView.h"
#import "InfoView.h"
#import "FrontViewController.h"
#import "DataLoader.h"

@interface MapViewController : FrontViewController  <MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

// The main map view
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Different annotations for the mapview
@property (strong, nonatomic) BasicMapAnnotation *selectedAnnotation;
@property (strong, nonatomic) BasicMapAnnotation *buildingAnnotation;
@property (strong, nonatomic) MKPinAnnotationView *selectedAnnotationView;
@property (strong, nonatomic) DisclosureAnnotationView *disclosureAnnotationView;

@property (strong, nonatomic) NSMutableArray *busStopAnnotations;
@property (strong, nonatomic) NSMutableArray *calCardAnnotations;
@property (strong, nonatomic) NSMutableArray *buildingAnnotations;
@property (strong, nonatomic) NSMutableArray *libraryAnnotations;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *mapKeyButton;
@property (strong, nonatomic) IBOutlet UIView *annotationSelectionView;
@property (weak, nonatomic) IBOutlet UIButton *busButton;
@property (weak, nonatomic) IBOutlet UIButton *calButton;
@property (weak, nonatomic) IBOutlet UIButton *libButton;

@property (strong, nonatomic) UIPanGestureRecognizer *dragRecognizer;

@property CLLocationCoordinate2D previousUserLocation;

// The different loaders for the data
@property (nonatomic, strong) DataLoader *cal1Loader;
@property (nonatomic, strong) DataLoader *busLoader;
@property (nonatomic, strong) DataLoader *buildingLoader;
@property (nonatomic, strong) DataLoader *libraryLoader;
@property (nonatomic, strong) DataLoader *libraryTimeLoader;
@property (nonatomic, strong) DataLoader *calTimeLoader;

- (IBAction)switchAnnotations:(id)sender;
- (IBAction)displayAnnotationSelector:(id)sender;
- (void)displayInfo:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)centerOnUser;
@end
