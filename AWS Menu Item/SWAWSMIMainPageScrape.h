//
//  SWAWSMIMainPageScrape.h
//  AWS Menu Item
//
//  Created by Jeremy Matthews on 2/10/14.
//  Copyright (c) 2014 SISU Works LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWAWSMIMainPageScrape : NSObject

{
    
}

@property (nonatomic, readwrite) NSString *northAmericaStatus;
@property (nonatomic, readwrite) NSString *southAmericaStatus;
@property (nonatomic, readwrite) NSString *europeStatus;
@property (nonatomic, readwrite) NSString *asiaPacStatusStatus;

+(NSArray *)groupStatus;

@end
