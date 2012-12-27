#import <UIKit/UIKit.h>
#import "BasicMapAnnotation.h"
#import "BusStopAnnotation.h"
#import "BasicMapAnnotationView.h"
#import "Cal1CardAnnotation.h"
#import "DisclosureAnnotationView.h"
#import "InfoView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

// The main map view
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Different annotations for the mapview
@property (strong, nonatomic) BasicMapAnnotation *selectedAnnotation;
@property (strong, nonatomic) BasicMapAnnotation *buildingAnnotation;
@property (strong, nonatomic) MKPinAnnotationView *selectedAnnotationView;
@property (strong, nonatomic) DisclosureAnnotationView *disclosureAnnotationView;

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *busStopAnnotations;
@property (strong, nonatomic) NSMutableArray *calCardAnnotations;

@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *mapKeyImageView;
@property (strong, nonatomic) IBOutlet InfoView *infoView;

@property CLLocationCoordinate2D previousUserLocation;

- (IBAction)switchAnnotations:(id)sender;
- (IBAction)displayMapKey:(id)sender;
- (void)displayInfo:(id)sender;
@end
