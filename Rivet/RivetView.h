//
//  RivetView.h
//  Rivet
//
//  Created by Aaron Signorelli on 21/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivetElement.h"
#import "Binding.h"

@protocol RivetView <NSObject, RivetElement>

// Use the values in the binding to render the template to the view
-(void) rivetToView:(Binding *) binding;

@end
