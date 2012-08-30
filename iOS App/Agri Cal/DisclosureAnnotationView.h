//
//  DisclosureAnnotationView.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 8/29/12.
//
//

#import <MapKit/MapKit.h>

@interface DisclosureAnnotationView : MKAnnotationView

@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *imageURL;
- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
- (void) calloutAccessoryTapped;
- (void) preventParentSelectionChange;
- (void) allowParentSelectionChange;
- (void) enableSibling:(UIView *)sibling;

@end
