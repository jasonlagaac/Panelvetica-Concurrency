//
//  SettingsModel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 22/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Accounts/Accounts.h>

@interface SettingsModel : NSObject
{
    NSArray         *accounts;
    ACAccountStore  *accountStore;
}

@property (strong, nonatomic) ACAccountStore *accountStore; 
@property (strong, nonatomic) NSArray *accounts;

@end
