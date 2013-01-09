@interface LaunchImageTransitionController : UIViewController {}
@end
@implementation LaunchImageTransitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(imageDidFadeOut:finished:context:)];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
    
}
- (void)imageDidFadeOut:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self.view removeFromSuperview];
}
@end
