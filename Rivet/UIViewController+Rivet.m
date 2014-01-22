//
//  UIViewController+Rivet.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIViewController+Rivet.h"
#import "UIView+Rivet.h"
#import "RVMutableDictionary.h"
#import <objc/runtime.h>

static char const * const RivetScopeKey = "RivetScope";

@implementation UIViewController (Rivet)

@dynamic scope;

#pragma mark - scope
-(id) scope {
    id scope = objc_getAssociatedObject(self, RivetScopeKey);
    if(scope == nil){
        //set the default scope to a dictionary. This one has a method to ignore nil if the key is optional.
        scope = [[RVMutableDictionary alloc] init];
        [self setScope:scope];
    }
    return scope;
}

-(void) setScope:(id)scope {
    id previousScope = objc_getAssociatedObject(self, RivetScopeKey);
    if(previousScope != nil) {
        [self detachScope:previousScope];
    }
    objc_setAssociatedObject(self, RivetScopeKey, scope, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self attachScope:scope];
}

#pragma mark - binding
-(void) attachScope:(id) scope {
    NSArray *rivetableSubviews = [self.view rivetableSubviews];
    for(UIView *rivetableView in rivetableSubviews) {
        [rivetableView attachScope:scope];
    }
}

// Responsible for ensuring that the subviews no longer contain any references to a scope
-(void) detachScope:(id) scope {
    NSArray *rivetableSubviews = [self.view rivetableSubviews];
    for(UIView *rivetableView in rivetableSubviews) {
        [rivetableView detachScope:scope];
    }
}

@end
