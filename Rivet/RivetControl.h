//
//  RivetBinder.h
//  Rivet
//
//  Created by Aaron Signorelli on 21/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivetElement.h"

@protocol RivetControl <NSObject, RivetElement>

@required
-(void) startMonitoringChanges;
-(void) stopMonitoringChanges;

@optional
// The binding uses this to update the model
-(id) fetchControlValue;

@end
