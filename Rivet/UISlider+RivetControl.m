//
//  UISlider+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UISlider+RivetControl.h"
#import "UIView+Rivet.h"
#import "UIControl+RivetControl.h"
#import "UIView+HideAndShow.h"

@implementation UISlider (RivetControl)

-(void) createRivetBindings {
    if([[self template] length]){
        Binding *bindOut = [Binding whenTemplate:[NSString stringWithFormat:@"{{%@}}",self.template] requiresRenderingUpdateTheViewProperty:@"value"];
        [super addBinding:bindOut];
        
        Binding *bindIn = [Binding watchModelKeyPath:self.template];
        bindIn.defaultValue = [NSNumber numberWithFloat:0.5f];
        [super addBinding:bindIn];
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
-(id) fetchControlValue {
    return [NSNumber numberWithFloat:self.value];
}

@end
