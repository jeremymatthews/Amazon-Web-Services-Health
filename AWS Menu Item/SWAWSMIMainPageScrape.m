//
//  SWAWSMIMainPageScrape.m
//  AWS Menu Item
//
//  Created by Jeremy Matthews on 2/10/14.
//  Copyright (c) 2014 SISU Works LLC. All rights reserved.
//

#import "SWAWSMIMainPageScrape.h"
#import "AFNetworking.h"
#import "TFHpple.h"

@interface SWAWSMIMainPageScrape ()
@end

@implementation SWAWSMIMainPageScrape

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+(NSArray *)groupStatus
{
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
            NSLog(@"NA normal = %d, performance = %d, disruptions = %d", elementNorthAmericaStatusNormal, elementNorthAmericaStatusPerformanceIssues, elementNorthAmericaStatusServiceDisruptions);
            NSLog(@"SA normal = %d, performance = %d, disruptions = %d", elementSouthAmericaStatusNormal, elementSouthAmericaStatusPerformanceIssues, elementSouthAmericaStatusServiceDisruptions);
            NSLog(@"EU normal = %d, performance = %d, disruptions = %d", elementEuropeStatusNormal, elementEuropeStatusPerformanceIssues, elementEuropeStatusServiceDisruptions);
            NSLog(@"AP normal = %d, performance = %d, disruptions = %d", elementAsiaPacStatusNormal, elementAsiaPacStatusPerformanceIssues, elementAsiaPacStatusServiceDisruptions);
            
            NSLog(@"master array is %@", masterArray);
        }
        @catch (NSException *exception)
        {
            NSLog(@"bad moo %@", exception);
            //[masterArray removeAllObjects];
        }
        @finally
        {
            
        }
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
        NSLog(@"master aray is %@", masterArray);
        NSLog(@"Error: %@", error);
        [masterArray removeAllObjects];
    }];
    
    if ([masterArray count] > 0) {
        return masterArray;
    }
    else
    {
        return nil;
    }
}


@end
