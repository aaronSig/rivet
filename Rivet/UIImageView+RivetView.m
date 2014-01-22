//
//  UIImageView+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 19/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIImageView+RivetView.h"
#import "UIView+Rivet.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+HideAndShow.h"

@implementation UIImageView (RivetView)

-(void) createRivetBindings {
    if([[self template] length]) {
        NSString *template = self.template;
        if([template rangeOfString:@"{{"].location == NSNotFound || [template rangeOfString:@"}}"].location == NSNotFound){
            //Assume that the user has just entered the model key path here.
            template = [NSString stringWithFormat:@"{{%@}}", template];
        }
        
        Binding *b = [Binding whenTemplate:template requiresRenderingUpdateTheViewProperty:@"image"];
        [super addBinding:b];
    }
    [super createRivetBindings];
}

-(void) rivetToView:(Binding *)binding {
    if([binding.viewPropertyKeyPath isEqualToString:@"image"] == NO) {
        return;
    }

    NSString *imageLocation = [binding renderTemplateWithError:nil];
    if ([imageLocation length]) {
        // try to first load it from the local bundle
        UIImage *image = [UIImage imageNamed:imageLocation];
        if(image) {
            [self setImage:image];
            return;
        }
        
        //Assume the string is a url and try and load from the net.
        [self setImageWithURL:[NSURL URLWithString:imageLocation]];
    }
}

@end
