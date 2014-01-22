//
//  UITextField+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UITextField+RivetControl.h"
#import "UIView+Rivet.h"
#import "UIControl+RivetControl.h"
#import "Binding.h"
#import "UIView+HideAndShow.h"

@implementation UITextField (RivetControl)

-(void) createRivetBindings {
    if([[self text] length]){
        //Use the text in the label for the template.
        // This binding pushes changes in the model to the TextField
        Binding *textBinder = [Binding whenTemplate:self.text requiresRenderingUpdateTheViewProperty:@"text"];
        [super addBinding:textBinder];
        
        // This binding pushes changes in the TextField back to the model
        Binding *inverseTextBinder = [Binding watchModelKeyPath:[[self.text stringByReplacingOccurrencesOfString:@"{{" withString:@""] stringByReplacingOccurrencesOfString:@"}}" withString:@""]];
        inverseTextBinder.defaultValue = @"";
        [super addBinding:inverseTextBinder];
    }
    if([[self placeholder] length]){
        //If there's a text in the lable then we assume its a template.
        Binding *placeholderBinder = [Binding whenTemplate:self.placeholder requiresRenderingUpdateTheViewProperty:@"placeholder"];
        [super addBinding:placeholderBinder];
    }
    
    [super createRivetBindings];
}

#pragma mark - RivetView
-(void) rivetToView:(Binding *) binding {
    NSError *err = nil;
    NSString *renderedStr = [binding renderTemplateWithError:&err];
    
    if(err){
        NSLog(@"Unable to compile template: %@ \nwith scope: %@ \nerror:%@", binding.template, binding.model, err);
    }
    [self setValue:renderedStr forKeyPath:binding.viewPropertyKeyPath];
}


#pragma mark - RivetControl
-(void) startMonitoringChanges {
    [self addTarget:self action:@selector(viewDidUpdate) forControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidEndOnExit];
}

-(void) stopMonitoringChanges {
    [self removeTarget:self action:@selector(viewDidUpdate) forControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidEndOnExit];
}

-(id) fetchControlValue {
    return self.text;
}

@end
