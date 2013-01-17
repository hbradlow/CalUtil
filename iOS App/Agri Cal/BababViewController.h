//
//  BababViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/16/13.
//
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface BababViewController : FrontViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *animatedView;
- (IBAction)animate:(id)sender;

@end
