//
//  WebcastViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebcastViewController.h"

@interface WebcastViewController ()

@end

@implementation WebcastViewController
@synthesize webView;
@synthesize url = _url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self embedYouTube:self.url];
}
- (void)embedYouTube:(NSString*)urlString {
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head>\
    <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = %f\"/></head>\
    <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
    <div><object width=\"%f\" height=\"%f\">\
    <param name=\"movie\" value=\"%@&autoplay=1\"></param>\
    <param name=\"wmode\" value=\"transparent\"></param>\
    <embed src=\"%@&autoplay=1\" id=\"video\"\
    type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%f\" height=\"%f\"></embed>\
    </object></div></body></html>", self.view.frame.size.width,self.view.frame.size.width, self.view.frame.size.height, self.url, self.url, self.view.frame.size.width, self.view.frame.size.height];

    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *html = [NSString stringWithFormat:embedHTML, urlString,urlString];
    NSLog(@"%@ \n %@", html, baseURL);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [self.webView loadHTMLString:html baseURL:nil];
    });
}

/*
    A little hack to make the video start with no user interaction required. 
 */
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [self.webView stringByEvaluatingJavaScriptFromString:@"doc.getElementByID(video).click();"];
}
- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
