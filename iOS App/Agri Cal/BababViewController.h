//
//  BababViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/16/13.
//
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"
#import <StoreKit/StoreKit.h>

@interface BababViewController : FrontViewController <SKProductsRequestDelegate>

@property (nonatomic, strong) NSMutableDictionary *products;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *animatedView;

@property (nonatomic, weak) IBOutlet UIButton *cheapBeer;
@property (nonatomic, weak) IBOutlet UIButton *priceyBeer;
@property (weak, nonatomic) IBOutlet UILabel *cheapBeerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceyBeerLabel;
@property (weak, nonatomic) IBOutlet UILabel *cheapBeerTapLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceyBeerTapLabel;
- (IBAction)purchase:(id)sender;

@end
