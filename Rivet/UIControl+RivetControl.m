//
//  UIControl+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

// Binding back the other way

#import "UIControl+RivetControl.h"
#import "UIView+Rivet.h"
#import "Binding.h"
#import "UIView+HideAndShow.h"

@implementation UIControl (RivetControl)

-(void) createRivetBindings {
    [super createRivetBindings];
}

#pragma mark- monitoring for changes
-(void) startMonitoringChanges {
    [self addTarget:self action:@selector(viewDidUpdate) forControlEvents:UIControlEventValueChanged];
}

-(void) stopMonitoringChanges {
    [self removeTarget:self action:@selector(viewDidUpdate) forControlEvents:UIControlEventValueChanged];
}

@end
