//
//  UIControl+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

// Binding back the other way

#import "UIControl+RivetBinder.h"
#import "UIView+Rivet.h"
#import <objc/runtime.h>
#import "RVMutableDictionary.h"
#import "NSObject+BlockObservation.h"

static char const * const RivetModelKey = "RivetModel";
static char const * const RivetScopeKey = "RivetScope";

@implementation UIControl (RivetBinder)
@dynamic model;


//Can we put the control on the scope to act as the model if there's nothing there to hold it already?

#pragma mark - accessors
-(NSString *) model {
    NSString *model = objc_getAssociatedObject(self, RivetModelKey);
    if(model) {
        return model;
    }
    
    //Dirty hack to allow us to set the template in the text field in interface builder
    if([self respondsToSelector:@selector(text)]) {
        model = [self performSelector:@selector(text)];
        [self setModel:[[model stringByReplacingOccurrencesOfString:@"{{" withString:@""] stringByReplacingOccurrencesOfString:@"}}" withString:@""]];
    }
    return model;
}

-(void) setModel:(NSString *)model {
    objc_setAssociatedObject(self, RivetModelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) isRivetable {
    return self.template != nil || self.model != nil;
}

//The user has changed the value in the control. Save the back to the model
//Subclasses should override this
-(void) flushUpToModel {
    
}

//Used if there's no keyPath set in the model.
-(id) getDefaultValue {
    return nil;
}

#pragma mark - handling scope
-(void) ensureModelPathExists:(id) scope {
    if(![scope isKindOfClass:[RVMutableDictionary class]]){
        //Don't edit user objects;
        return;
    }
    //If the scope doesn't contain the keyPath specified in the model we create it here so no errors are thrown
    id value = [self.scope valueForKeyPath:self.model];
    if(value == nil){
        id obj = [self getDefaultValue];
        [self.scope setObject:obj
                       forKey:self.model];
    }
}

-(void) attachScope:(id) scope {
    if(!self.model){
        return;
    }
    
    [self addTarget:self action:@selector(flushUpToModel) forControlEvents:UIControlEventValueChanged];
    [self ensureModelPathExists:scope];
    [scope watchKeyPath:self.model task:^(id object, NSDictionary *change) {
        [super changeSeenOnKeyPath:self.model object:object change:change];
    }];
    [super attachScope:scope];
}

-(void) detachScope:(id) scope {
    [self removeTarget:self action:@selector(flushUpToModel) forControlEvents:UIControlEventValueChanged];
    [super detachScope:scope];
}

@end
