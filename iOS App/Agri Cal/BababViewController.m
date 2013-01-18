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
    self.products = [[NSMutableDictionary alloc] init];
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
    
    NSSet *potentialProds = [NSSet setWithObjects:@"CheapBeer", @"PriceyBeer",nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:potentialProds];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"received products %@", response.products);
    for (SKProduct *product in response.products)
    {
        [self.products setObject:product forKey:product.productIdentifier];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)purchase:(id)sender {
    if ([SKPaymentQueue canMakePayments])
    {
        if (sender == self.cheapBeer)
        {
            SKPayment *myPayment = [SKPayment paymentWithProduct:[self.products objectForKey:@"CheapBeer"]];
            [[SKPaymentQueue defaultQueue] addPayment:myPayment];
        }
        else
        {
            SKPayment *myPayment = [SKPayment paymentWithProduct:[self.products objectForKey:@"PriceyBeer"]];
            [[SKPaymentQueue defaultQueue] addPayment:myPayment];        
        }
    }
}
- (void)viewDidUnload {
    [self setCheapBeerLabel:nil];
    [self setPriceyBeerLabel:nil];
    [self setCheapBeerTapLabel:nil];
    [self setPriceyBeerTapLabel:nil];
    [super viewDidUnload];
}
@end
