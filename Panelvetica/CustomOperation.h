//
//  CustomOperation.h
//  Panelvetica
//
//  Created by Jason Lagaac on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomOperation : NSOperation
{
    BOOL                executing;
    BOOL                finished;
}

- (void)completedOperation;

@end
