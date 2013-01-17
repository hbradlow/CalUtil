//
//  BababViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/16/13.
//
//

#import "BababViewController.h"

@interface BababViewController ()

@end

@implementation BababViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IPHONE5)
    {
        NSLog(@"%@", [UIImage imageNamed:@"babab-h568@2x.gif"]);
        [self.imageView setImage:[UIImage imageNamed:@"babab-h568@2x.gif"]];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 126; i ++)
        {
            NSString *name = [NSString stringWithFormat:@"bababgif-h%03d.png", i];
            [arr addObject:[UIImage imageNamed:name]];
        }
        self.animatedView.animationImages = arr;
        self.animatedView.animationDuration = 4.1f;
        self.animatedView.animationRepeatCount = 0;
    }
    else
    {
        [self.imageView setImage:[UIImage imageNamed:@"babab.gif"]];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
    
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int i = 0; i < 126; i ++)
            {
                NSString *name = [NSString stringWithFormat:@"bababgif-4%03d.png", i];
                [arr addObject:[UIImage imageNamed:name]];
            }
            self.animatedView.animationImages = arr;
            self.animatedView.animationDuration = 4.1f;
            self.animatedView.animationRepeatCount = 0;
        } else {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int i = 0; i < 126; i ++)
            {
                NSString *name = [NSString stringWithFormat:@"bababgif%03d.png", i];
                [arr addObject:[UIImage imageNamed:name]];
            }
            self.animatedView.animationImages = arr;
            self.animatedView.animationDuration = 4.1f;
            self.animatedView.animationRepeatCount = 0;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animate:(id)sender {
    self.animatedView.animationRepeatCount = 1;
    self.animatedView.hidden = NO;
    [self.animatedView startAnimating];
}
@end
