//
//  NewsStoryViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/13/12.
//
//

#import <UIKit/UIKit.h>
#import "NewsStory.h"

@interface NewsStoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NewsStory *story;

@end
