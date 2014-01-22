//
//  UILabel+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UILabel+RivetView.h"
#import "UIView+Rivet.h"
#import "UIView+HideAndShow.h"

@implementation UILabel (RivetView)

-(void) createRivetBindings {
    if([[self text] length]){
        //If there's a text in the label then we assume its a template.
        Binding * textBinder = [Binding whenTemplate:self.template requiresRenderingUpdateTheViewProperty:@"text"];
        [super addBinding:textBinder];
    }
    [super createRivetBindings];
}

-(void) rivetToView:(Binding *) binding {
    NSError *err = nil;
    NSString *renderedStr = [binding renderTemplateWithError:&err];
    
    if(err){
        NSLog(@"Unable to compile template: %@ \nwith scope: %@ \nerror:%@", binding.template, binding.model, err);
    }
    [self setValue:renderedStr forKeyPath:binding.viewPropertyKeyPath];
}

@end
