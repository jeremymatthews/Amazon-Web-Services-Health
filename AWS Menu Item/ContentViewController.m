//
//  ContentViewController.m
//  StatusItemPopup
//
//  Created by Alexander Schuch on 06/03/13.
//  Copyright (c) 2013 Alexander Schuch. All rights reserved.
//

#import "ContentViewController.h"
#import "SSYPieProgressView.h"
#import <QuartzCore/QuartzCore.h>
//#import "SWAWSMIPresfController.h"
#import "SWAWSMIMainPageScrape.h"
#import "AFNetworking.h"
#import "TFHpple.h"

@interface ContentViewController ()
@property (strong) IBOutlet NSImageView *northAmericaStatusImageView;
@property (strong) IBOutlet NSImageView *southAmericaStatusImageView;
@property (strong) IBOutlet NSImageView *europeStatusImageView;
@property (strong) IBOutlet NSImageView *asiaPacStatusImageView;
@property (strong) IBOutlet NSButton *refreshButton;
@property (strong) IBOutlet SSYPieProgressView *pieProgressView;
@property (nonatomic) NSTimer *timer;
@property (strong) IBOutlet NSView *headerView;
@property (strong) IBOutlet NSButton *settingsButton;
//@property (strong) SWAWSMIPresfController *prefsController;
@property (strong) IBOutlet NSPopover *popover;
@property (strong) IBOutlet NSButton *deepSearchCheckbox;
@property (strong) IBOutlet NSTextField *connectionLabel;

- (IBAction)refreshStatus:(id)sender;
- (IBAction)goToAWS:(id)sender;
- (IBAction)openSettings:(id)sender;

//scrape
@property (nonatomic, readwrite) NSString *northAmericaStatus;
@property (nonatomic, readwrite) NSString *southAmericaStatus;
@property (nonatomic, readwrite) NSString *europeStatus;
@property (nonatomic, readwrite) NSString *asiaPacStatusStatus;

@end


@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    _timer = [[NSTimer alloc] init];
    
    NSDate *d = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimer *t = [[NSTimer alloc] initWithFireDate:d
                                          interval:60
                                            target:self
                                          selector:@selector(groupStatus:)
                                          userInfo:nil repeats:YES];
    
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:t forMode:NSDefaultRunLoopMode];
    
    return self;
}

-(void)awakeFromNib
{
    _pieProgressView.progress = 0;
    [_pieProgressView setHidden:YES];
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0, 0, 0, 0.75)];
    //[viewLayer setBackgroundColor:(__bridge CGColorRef)([NSColor blackColor])];
    [_headerView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [_headerView setLayer:viewLayer];
}

- (void)incrementProgress:(NSTimer *)timer
{
	_pieProgressView.progress = _pieProgressView.progress + 0.1;
	if (_pieProgressView.progress == 1.0f)
    {
        NSLog(@"full");
		_pieProgressView.progress = 0.0;
        [_pieProgressView setHidden:YES];
        [_refreshButton setEnabled:YES];
        
        //[_northAmericaStatusImageView setImage:[NSImage imageNamed:@"cloud.png"]];
        //[_southAmericaStatusImageView setImage:[NSImage imageNamed:@"cloudred@2x.png"]];
        //[_southAmericaStatusImageView setToolTip:@"Service disruption."];
        //[_europeStatusImageView setImage:[NSImage imageNamed:@"cloudyellow@2x.png"]];
        //[_europeStatusImageView setToolTip:@"Service performance issues."];
        //[_asiaPacStatusImageView setImage:[NSImage imageNamed:@"cloudgrey.png"]];
        //[_asiaPacStatusImageView setToolTip:@"Service is operating normally."];
        
        
        [_timer invalidate];
        
    }
}

- (IBAction)refreshStatus:(id)sender
{
    [_pieProgressView setHidden:NO];
    [_refreshButton setEnabled:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(incrementProgress:)
                                            userInfo:nil
                                             repeats:YES];
    
    //[_pieProgressView setHidden:NO];
    //[_pieProgressView setNeedsDisplay];
    [self groupStatus:nil];
}

- (IBAction)goToAWS:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://status.aws.amazon.com"]];
}

- (IBAction)openSettings:(id)sender
{
    /*
     if (!_prefsController)
     {
     _prefsController = [[SWAWSMIPresfController alloc] init];
     }
     
     if (![_prefsController.window isVisible])
     {
     [_prefsController.window setIsVisible:YES];
     [_prefsController.window orderFront:nil];
     } else {
     @try {
     [_prefsController.window setIsVisible:NO];
     [_prefsController.window orderOut:self];
     }
     @catch (NSException *exception) {
     NSLog(@"exception e %@", exception);
     }
     @finally {
     
     }
     
     }
     */
    
    [self.popover showRelativeToRect:[_settingsButton bounds]
                              ofView:_settingsButton
                       preferredEdge:NSMaxXEdge];
    
}


- (void)attachPopUpAnimation
{
    [self.view setWantsLayer:YES];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .5;
    
    [_northAmericaStatusImageView.layer addAnimation:animation forKey:@"popup"];
    [_southAmericaStatusImageView.layer addAnimation:animation forKey:@"popup"];
    [_europeStatusImageView.layer addAnimation:animation forKey:@"popup"];
    [_asiaPacStatusImageView.layer addAnimation:animation forKey:@"popup"];
}


-(void)groupStatus:(NSTimer *)timer
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    [_connectionLabel setStringValue:@""];

    NSMutableArray *masterArray = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://status.aws.amazon.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //debug
         //NSLog(@"type is %@", [responseObject class]);
         
         // NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         //NSLog(@"%@", string);
         
         NSData *data = [[NSData alloc] initWithData:responseObject];
         
         // Create parser
         TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
         
         @try
         {
             NSArray *elementNameNorthAmerica = [xpathParser searchWithXPathQuery:@"//table[1]/tbody//tr/td[2]"];
             NSArray *elementStatusNorthAmerica = [xpathParser searchWithXPathQuery:@"//table[1]/tbody//tr/td[3]"];
             int elementNorthAmericaStatusNormal = 0;
             int elementNorthAmericaStatusPerformanceIssues = 0;
             int elementNorthAmericaStatusServiceDisruptions = 0;
             
             NSArray *elementNameSouthAmerica = [xpathParser searchWithXPathQuery:@"//table[2]/tbody//tr/td[2]"];
             NSArray *elementStatusSouthAmerica = [xpathParser searchWithXPathQuery:@"//table[2]/tbody//tr/td[3]"];
             int elementSouthAmericaStatusNormal = 0;
             int elementSouthAmericaStatusPerformanceIssues = 0;
             int elementSouthAmericaStatusServiceDisruptions = 0;
             
             NSArray *elementNameEurope = [xpathParser searchWithXPathQuery:@"//table[3]/tbody//tr/td[2]"];
             NSArray *elementStatusEurope = [xpathParser searchWithXPathQuery:@"//table[3]/tbody//tr/td[3]"];
             int elementEuropeStatusNormal = 0;
             int elementEuropeStatusPerformanceIssues = 0;
             int elementEuropeStatusServiceDisruptions = 0;
             
             NSArray *elementNameAsiaPac = [xpathParser searchWithXPathQuery:@"//table[4]/tbody//tr/td[2]"];
             NSArray *elementStatusAsiaPac = [xpathParser searchWithXPathQuery:@"//table[4]/tbody//tr/td[3]"];
             int elementAsiaPacStatusNormal = 0;
             int elementAsiaPacStatusPerformanceIssues = 0;
             int elementAsiaPacStatusServiceDisruptions = 0;
             
             // Get the text within the cell tag
             //NSString *content = [element tagName];
             
             //North America
             for (int i=0; i<[elementNameNorthAmerica count]; i++)
             {
                 //debug
                 //NSLog(@"status is %@ for %@", [[elementNameNorthAmerica objectAtIndex:i] text], [[elementStatusNorthAmerica objectAtIndex:i] text]);
                 if ([[[elementStatusNorthAmerica objectAtIndex:i] text] rangeOfString:@"disruption" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //disruption
                     elementNorthAmericaStatusServiceDisruptions++;
                 }
                 if ([[[elementStatusNorthAmerica objectAtIndex:i] text] rangeOfString:@"performance" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //performance issues
                     elementNorthAmericaStatusPerformanceIssues++;
                 }
                 if ([[[elementStatusNorthAmerica objectAtIndex:i] text] rangeOfString:@"normally" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //normal
                     elementNorthAmericaStatusNormal++;
                 }
             }
             
             if (elementNorthAmericaStatusServiceDisruptions > 0)
             {
                 [masterArray addObject:@"disrupt"];
             }
             else if (elementNorthAmericaStatusPerformanceIssues > 0)
             {
                 [masterArray addObject:@"perform"];
             }
             else
             {
                 [masterArray addObject:@"normal"];
             }
             
             //South America
             for (int i=0; i<[elementNameSouthAmerica count]; i++)
             {
                 //debug
                 //NSLog(@"status is %@ for %@", [[elementNameSouthAmerica objectAtIndex:i] text], [[elementStatusSouthAmerica objectAtIndex:i] text]);
                 if ([[[elementStatusSouthAmerica objectAtIndex:i] text] rangeOfString:@"disruption" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //disruption
                     elementSouthAmericaStatusServiceDisruptions++;
                 }
                 if ([[[elementStatusSouthAmerica objectAtIndex:i] text] rangeOfString:@"performance" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //performance issues
                     elementSouthAmericaStatusPerformanceIssues++;
                 }
                 if ([[[elementStatusSouthAmerica objectAtIndex:i] text] rangeOfString:@"normally" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //normal
                     elementSouthAmericaStatusNormal++;
                 }
             }
             
             if (elementSouthAmericaStatusServiceDisruptions > 0)
             {
                 [masterArray addObject:@"disrupt"];
             }
             else if (elementSouthAmericaStatusPerformanceIssues > 0)
             {
                 [masterArray addObject:@"perform"];
             }
             else
             {
                 [masterArray addObject:@"normal"];
             }
             
             //Europe
             for (int i=0; i<[elementNameEurope count]; i++)
             {
                 //debug
                 //NSLog(@"status is %@ for %@", [[elementNameEurope objectAtIndex:i] text], [[elementStatusEurope objectAtIndex:i] text]);
                 if ([[[elementStatusEurope objectAtIndex:i] text] rangeOfString:@"disruption" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //disruption
                     elementEuropeStatusServiceDisruptions++;
                 }
                 if ([[[elementStatusEurope objectAtIndex:i] text] rangeOfString:@"performance" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //performance issues
                     elementEuropeStatusPerformanceIssues++;
                 }
                 if ([[[elementStatusEurope objectAtIndex:i] text] rangeOfString:@"normally" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //normal
                     elementEuropeStatusNormal++;
                 }
             }
             
             if (elementEuropeStatusServiceDisruptions > 0)
             {
                 [masterArray addObject:@"disrupt"];
             }
             else if (elementEuropeStatusPerformanceIssues > 0)
             {
                 [masterArray addObject:@"perform"];
             }
             else
             {
                 [masterArray addObject:@"normal"];
             }
             
             //AsiaPac
             for (int i=0; i<[elementNameAsiaPac count]; i++)
             {
                 //debug
                 //NSLog(@"status is %@ for %@", [[elementNameAsiaPac objectAtIndex:i] text], [[elementStatusAsiaPac objectAtIndex:i] text]);
                 if ([[[elementStatusAsiaPac objectAtIndex:i] text] rangeOfString:@"disruption" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //disruption
                     elementAsiaPacStatusServiceDisruptions++;
                 }
                 if ([[[elementStatusAsiaPac objectAtIndex:i] text] rangeOfString:@"performance" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //performance issues
                     elementAsiaPacStatusPerformanceIssues++;
                 }
                 if ([[[elementStatusAsiaPac objectAtIndex:i] text] rangeOfString:@"normally" options:NSCaseInsensitiveSearch].location != NSNotFound)
                 {
                     //normal
                     elementAsiaPacStatusNormal++;
                 }
             }
             
             if (elementAsiaPacStatusServiceDisruptions > 0)
             {
                 [masterArray addObject:@"disrupt"];
             }
             else if (elementAsiaPacStatusPerformanceIssues > 0)
             {
                 [masterArray addObject:@"perform"];
             }
             else
             {
                 [masterArray addObject:@"normal"];
             }
             
             //debug
             //NSLog(@"NA normal = %d, performance = %d, disruptions = %d", elementNorthAmericaStatusNormal, elementNorthAmericaStatusPerformanceIssues, elementNorthAmericaStatusServiceDisruptions);
             //NSLog(@"SA normal = %d, performance = %d, disruptions = %d", elementSouthAmericaStatusNormal, elementSouthAmericaStatusPerformanceIssues, elementSouthAmericaStatusServiceDisruptions);
             //NSLog(@"EU normal = %d, performance = %d, disruptions = %d", elementEuropeStatusNormal, elementEuropeStatusPerformanceIssues, elementEuropeStatusServiceDisruptions);
             //NSLog(@"AP normal = %d, performance = %d, disruptions = %d", elementAsiaPacStatusNormal, elementAsiaPacStatusPerformanceIssues, elementAsiaPacStatusServiceDisruptions);
             
             //NSLog(@"master array is %@", masterArray);
             
             NSArray *tmp = [[NSArray alloc] initWithObjects:_northAmericaStatusImageView, _southAmericaStatusImageView, _europeStatusImageView, _asiaPacStatusImageView, nil];
             NSImage *red = [NSImage imageNamed:@"cloudred@2x.png"];
             NSImage *yellow = [NSImage imageNamed:@"cloudyellow@2x.png"];
             NSImage *black = [NSImage imageNamed:@"cloud@2x.png"];
             NSImage *grey = [NSImage imageNamed:@"cloudgrey@2x.png"];
             

             NSUInteger index = 0;
             if ([tmp count] == [masterArray count])
             {
                 for (NSImageView *imgView in tmp)
                 {
                     //NSLog(@"index is %lu", (unsigned long)index);
                     if ([[masterArray objectAtIndex:index] isEqualToString:@"normal"])
                     {
                         [imgView setImage:[NSImage imageNamed:@"cloudgreen@2x.png"]];
                         [imgView setToolTip:@"Service is operating normally."];
                     }
                     else if ([[masterArray objectAtIndex:index] isEqualToString:@"perform"])
                     {
                         [imgView setImage:[NSImage imageNamed:@"cloudyellow@2x.png"]];
                         [imgView setToolTip:@"Performance Issues."];
                     }
                     else if ([[masterArray objectAtIndex:index] isEqualToString:@"disrupt"])
                     {
                         [imgView setImage:[NSImage imageNamed:@"cloudred@2x.png"]];
                         [imgView setToolTip:@"Service is disrupted."];
                     }
                     
                     [imgView setHidden:NO];
                     [imgView setNeedsDisplay:YES];
                     
                     
                     index++;
                 }
             }
             
             [self attachPopUpAnimation];

             
         }
         @catch (NSException *exception)
         {
             //NSLog(@"bad moo %@", exception);
             //[masterArray removeAllObjects];
         }
         @finally
         {
             [_connectionLabel setTextColor:[NSColor blackColor]];
             NSString *tmp = [NSString stringWithFormat:@"%@ %@", @"Last Check:", theTime];
             [_connectionLabel setStringValue:tmp];
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"master aray is %@", masterArray);
         //NSLog(@"Error: %@", error);
         [masterArray removeAllObjects];
         //set error message
         [_connectionLabel setTextColor:[NSColor redColor]];
         [_connectionLabel setStringValue:@"Connection Failed"];
     }];
    //NSLog(@"run");
    
    
}

@end
