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
    [self updateLabels];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:kPurchaseNotification object:nil];
}

- (void)updateLabels
{
    BOOL hasCheap = [[NSUserDefaults standardUserDefaults] boolForKey:@"CheapBeer"];
    BOOL hasPricey = [[NSUserDefaults standardUserDefaults] boolForKey:@"PriceyBeer"];
    NSLog(@"has cheap %i pricey %i", hasCheap, hasPricey);
    if (hasCheap)
    {
        self.cheapBeerLabel.text = @"Tap to Drink!";
        self.cheapBeerTapLabel.hidden = YES;
        [self.cheapBeer removeTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        [self.cheapBeer addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
        [self.cheapBeer setEnabled:YES];
    }
    else
    {
        self.cheapBeerLabel.text = @"$0.99";
        self.cheapBeerTapLabel.text = @"Tap to buy!";
        self.cheapBeerTapLabel.hidden = NO;
        [self.cheapBeer removeTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
        [self.cheapBeer addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        [self.cheapBeer setEnabled:YES];        
    }
    if (hasPricey)
    {
        self.priceyBeerLabel.text = @"Tap to Drink!";
        self.priceyBeerTapLabel.hidden = YES;
        [self.priceyBeer removeTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceyBeer addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceyBeer setEnabled:YES];
    }
    else
    {
        self.priceyBeerLabel.text = @"$4.99";
        self.priceyBeerTapLabel.text = @"Tap to buy!";
        self.priceyBeerTapLabel.hidden = NO;
        [self.priceyBeer removeTarget:self action:@selector(animate:) forControlEvents:UIControlEventAllEditingEvents];
        [self.priceyBeer addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceyBeer setEnabled:YES];        
    }
}

- (void)animate:(id)sender
{
    if (sender == self.cheapBeer)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CheapBeer"];        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PriceyBeer"];
    }
    [self.animatedView setHidden:NO];
    self.animatedView.animationRepeatCount = 1;
    [self.animatedView startAnimating];
    [self updateLabels];
}

- (IBAction)purchase:(id)sender {
    if ([SKPaymentQueue canMakePayments])
    {
        if (sender == self.cheapBeer)
        {
            SKPayment *myPayment = [SKPayment paymentWithProduct:[self.products objectForKey:@"CheapBeer"]];
            [[SKPaymentQueue defaultQueue] addPayment:myPayment];
            [self.cheapBeer setEnabled:NO];
            [self.cheapBeerTapLabel setText:@"Purchasing..."];
        }
        else
        {
            SKPayment *myPayment = [SKPayment paymentWithProduct:[self.products objectForKey:@"PriceyBeer"]];
            [[SKPaymentQueue defaultQueue] addPayment:myPayment];
            [self.priceyBeer setEnabled:NO];
            [self.priceyBeerTapLabel setText:@"Purchasing..."];
        }
    }
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
- (void)viewDidUnload {
    [self setCheapBeerLabel:nil];
    [self setPriceyBeerLabel:nil];
    [self setCheapBeerTapLabel:nil];
    [self setPriceyBeerTapLabel:nil];
    [super viewDidUnload];
}
@end
