//
//  Binding.m
//  Rivet
//
//  Created by Aaron Signorelli on 21/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "Binding.h"
#import "RivetControl.h"
#import "RivetView.h"
#import "GRMustache.h"
#import "NSObject+BlockObservation.h"
#import <UIKit/UIKit.h>
#import "RVMutableDictionary.h"

@implementation Binding

@synthesize template, viewPropertyKeyPath, view, model;

// ---
// user updates view (i.e. text box) -> on editing change fires -> bind back to model
// model changes -> watch fires -> compile template -> update view with rendered template
// ----

+(Binding *) bindingWithTemplate:(NSString *)aTemplate {
    Binding *b = [[Binding alloc] init];
    b.template = aTemplate;
    return b;
}

+(Binding *) watchModelKeyPath:(NSString *) aKeyPath {
    Binding *b = [[Binding alloc] init];
    b.modelKeyPath = aKeyPath;
    return b;
}

+(Binding *) whenTemplate:(NSString *)aTemplate requiresRenderingUpdateTheViewProperty:(NSString *)aViewPropertyKeyPath {
    Binding *b = [[Binding alloc] init];
    b.template = aTemplate;
    b.viewPropertyKeyPath = aViewPropertyKeyPath;
    return b;
}

#pragma mark - handling model -> view updates
-(void) attachModel:(id)aModel {
    model = aModel;
    __weak Binding *binding = self;

    if([self.modelKeyPath length]) {
        [self ensureKeyPathExistsInModel:self.modelKeyPath];
        [model watchKeyPath:self.modelKeyPath task: ^(id obj, NSDictionary *change){
            [binding modelDidUpdate];
        }];
    }
    
    NSArray *keyPaths = [self keyPathsInTemplate];
    for(NSString *keyPath in keyPaths) {
        [self ensureKeyPathExistsInModel:keyPath];
        [model watchKeyPath:keyPath task: ^(id obj, NSDictionary *change){
            [binding modelDidUpdate];
        }];
    }
    
    [self modelDidUpdate];
}

-(void) detachModel {
    //  Pretty sure we dont need to remove the observer here for memory. We would if you wanted to use the scope for something else. TODO
    //    [model removeObserverWithBlockToken:modelChangeWatcher];
    model = nil;
}

-(void) modelDidUpdate {
    if([view conformsToProtocol:@protocol(RivetView)]) {
        UIView<RivetView> *aView = (UIView<RivetView> *) view;
        __weak Binding* this = self;
        //This prevents updates if the user is editing the control
        if(![aView isFirstResponder]){
            //UI updates can only happen on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [aView rivetToView:this.model];
            });
        }
    } else {
        NSError *err = nil;
        NSString *updatedValue = [self renderTemplateWithError:&err];
        if(err){
            NSLog(@"Error compiling template: %@ \n%@", template, err);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //Possible that the view can be any object so cater for that here
            [view setValue:updatedValue forKeyPath:viewPropertyKeyPath];
        });
    }
}

//TODO pull this out into its own class. Really want to be able to eval expressions too.
-(NSString *) renderTemplateWithError:(NSError **)error {
    [GRMustacheConfiguration defaultConfiguration].contentType = GRMustacheContentTypeText;
    NSString *rendered = [GRMustacheTemplate renderObject:self.model
                                               fromString:self.template
                                                    error:error];
    if(error) {
        NSLog(@"Error rendering template: %@ model: %@ \n %@", self.template, model, *error);
    }
    return rendered;
}

//If the scope doesn't contain the keyPath specified in the model we create it here so no errors are thrown
-(void) ensureKeyPathExistsInModel:(NSString *) aKeyPath {
    if(![model isKindOfClass:[RVMutableDictionary class]]){
        //Don't edit user objects;
        return;
    }
    id value = [model valueForKeyPath:aKeyPath];
    if(value == nil){
        id obj = [self defaultValue];
        [model setObject:obj
                  forKey:self.model];
    }
}

#pragma mark - handling view -> model updates
// We dont know the event to listen for on the view to grab editing changes.
// Rely on the view (or more specifically categories we create on the view) to call this
-(void) viewDidUpdate {
    if(![view conformsToProtocol:@protocol(RivetControl)]) {
        NSLog(@"WARNING - a view which does not conform to the %@ protocol has requested to update the model. Not updating.", NSStringFromProtocol(@protocol(RivetControl)));
        return;
    }
    id<RivetControl> rivetControl = (id<RivetControl>) view;
    //N.B. UIKit isn't generally KVO compliant so we ask the control to give us its value here.
    id updatedValue = [rivetControl fetchControlValue];
    [model setValue:updatedValue forKeyPath:self.modelKeyPath];
}

#pragma mark - helpers
-(NSArray *) keyPathsInTemplate {
    if(![[self template] length]) {
        return [NSArray array];
    }
    NSMutableArray *keyPaths = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{.*?\\}\\}" options:0 error:nil];
    NSArray *matches = [regex matchesInString:self.template
                                      options:0
                                        range:NSMakeRange(0, [self.template length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        NSString *matchString = [self.template substringWithRange:NSMakeRange(matchRange.location + 2, matchRange.length - 4)];
        [keyPaths addObject:matchString];
    }
    return [NSArray arrayWithArray:keyPaths];
}

@end
