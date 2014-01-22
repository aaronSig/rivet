//
//  UIView+Rivet.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIView+Rivet.h"
#import <objc/runtime.h>
#import "GRMustache.h"
#import "JRSwizzle.h"
#import "NSObject+BlockObservation.h"
#import "Binding.h"
#import "RivetControl.h"
#import "RivetView.h"

static char const * const RivetBindingsKey = "RivetBindings";
static char const * const RivetScopeKey = "RivetScope";

@implementation UIView (Rivet)

@dynamic scope, bindings;

-(BOOL) isRivetable {
    return [self hasBindings];
}

#pragma mark - Creating bindings after IB load
+(void) load {
    NSError *err = nil;
    [self jr_swizzleClassMethod:@selector(awakeFromNib) withClassMethod:@selector(swizzledAwakeFromNib) error:&err];
    if(err) {
        NSLog(@"Rivet was unable to swizzle the awakeFromNib method. You will have to create the Rivet bindings manually");
    }
}

-(void) swizzledAwakeFromNib {
    if([self conformsToProtocol:@protocol(RivetView)]){
        UIView<RivetView> *rivetView = (UIView<RivetView> *) self;
        [rivetView createRivetBindings];
    }
    [self swizzledAwakeFromNib];
}

#pragma mark - scope
-(id) scope {
    return objc_getAssociatedObject(self, RivetScopeKey);
}

#pragma mark - bindings
-(NSMutableArray *) bindings {
    NSMutableArray *bindings = objc_getAssociatedObject(self, RivetBindingsKey);
    if(!bindings) {
        bindings = [NSMutableArray array];
        [self setBindings:bindings];
        return bindings;
    }
    return bindings;
}

-(void) setBindings:(NSMutableArray *)bindings {
    objc_setAssociatedObject(self, RivetBindingsKey, bindings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) addBinding: (Binding *)binding {
    [[self bindings] addObject:binding];
}

-(BOOL) hasBindings {
    return [[self bindings] count];
}

#pragma mark - listening for scope changes
-(void) attachScope:(id) scope {
    objc_setAssociatedObject(self, RivetScopeKey, scope, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    for(Binding *b in self.bindings) {
        [b attachModel:scope];
    }
    if([self conformsToProtocol:@protocol(RivetControl)]) {
        [(id<RivetControl>)self startMonitoringChanges];
    }
}

-(void) detachScope:(id) scope {
    if([self conformsToProtocol:@protocol(RivetControl)]) {
        [(id<RivetControl>)self stopMonitoringChanges];
    }
    for(Binding *b in self.bindings) {
        [b detachModel];
    }
    objc_setAssociatedObject(self, RivetScopeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - helpers
-(void) viewDidUpdate {
    for(Binding *b in self.bindings) {
        [b viewDidUpdate];
    }
}

// Returns all the subviews which conform the the Rivetable protocol
// including those which are subviews of subviews.
-(NSArray *) rivetableSubviews {
    NSArray *subviews = [self subviews];
    NSMutableArray *rivetableSubviews = [[NSMutableArray alloc] init];
    for(UIView *subview in subviews) {
        if([subview isRivetable]){
            [rivetableSubviews addObject:subview];
        }
        [rivetableSubviews addObjectsFromArray:[subview rivetableSubviews]];
    }
    return [NSArray arrayWithArray:rivetableSubviews];
}

@end
