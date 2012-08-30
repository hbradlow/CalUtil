//
//  MapControllerViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 8/29/12.
//
//

#import "MapControllerViewController.h"

@interface MapControllerViewController ()
{
    NSMutableDictionary *stops;
    NSMutableDictionary *offCampusC1CLocations;
    NSMutableDictionary *libraries;
    NSMutableDictionary *onCampusC1CLocations;
    
    NSMutableSet *stopViews;
    NSMutableSet *offCampusC1CViews;
    NSMutableSet *onCampusC1CViews;
    NSMutableSet *libraryViews; 
}
@end

@implementation MapControllerViewController

- (void)viewDidLoad
{
    // SEND REQUEST TO GET STOPS
    // SEND REQUEST TO GET ON CAMPUS
    // SEND REQUEST TO GET OFF CAMPUS
    // SEND REQUEST TO GET LIBRARIES
}
 
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Handle the selection
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{}

@end
