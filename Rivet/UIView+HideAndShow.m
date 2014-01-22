//
//  UIView+HideAndShow.m
//  Rivet
//
//  Created by Aaron Signorelli on 22/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIView+HideAndShow.h"
#import "UIView+Rivet.h"

static char const * const RivetHideKey = "RivetHide";
static char const * const RivetShowKey = "RivetShow";

@implementation UIView (HideAndShow)

@dynamic hide, show;

#pragma mark - RivetView
-(void) createRivetBindings {
    if(self.hide) {
        Binding *b = [Binding whenTemplate:self.hide requiresRenderingUpdateTheViewProperty:@"hide"];
        [self addBinding:b];
    }
    
    if(self.show) {
        Binding *b = [Binding whenTemplate:self.show requiresRenderingUpdateTheViewProperty:@"show"];
        [self addBinding:b];
    }
}

-(void) rivetToView:(Binding *)binding {
    NSString * rendered = [binding renderTemplateWithError:nil];
    BOOL value = [rendered boolValue];
    
    if([binding.viewPropertyKeyPath isEqualToString:@"hide"]){
        self.hidden = value;
    } else if ([binding.viewPropertyKeyPath isEqualToString:@"show"]){
        self.hidden = !value;
    }
}

#pragma mark - accessors
-(NSString *) hide {
    return objc_getAssociatedObject(self, RivetHideKey);
}

-(void) setHide:(NSString *) hideTemplate {
    objc_setAssociatedObject(self, RivetHideKey, hideTemplate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *) show {
    return objc_getAssociatedObject(self, RivetShowKey);
}

-(void) setShow:(NSString *) showTemplate {
    objc_setAssociatedObject(self, RivetShowKey, showTemplate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
