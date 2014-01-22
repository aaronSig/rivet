//
//  RivetElement.h
//  Rivet
//
//  Created by Aaron Signorelli on 22/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+template.h"

@protocol RivetElement <NSObject>

// This is called after the view is awoken from the nib. Use this to create any bindings
-(void) createRivetBindings;

@end
