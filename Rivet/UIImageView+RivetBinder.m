//
//  UIImageView+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 19/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIImageView+RivetBinder.h"
#import "UIView+Rivet.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (RivetBinder)

-(void) rivetToScope:(id) scope {
    if(!self.template || ![self keyPathFromTemplate]) {
        return;
    }
    
    NSString *imageLocation = [self.scope valueForKeyPath:[self keyPathFromTemplate]];
    if (imageLocation == nil) {
        // todo: there's too many null checks here. Perhaps re-work the logic
        return;
    }
    
    UIImage *image = [UIImage imageNamed:imageLocation];
    if(image) {
        [self setImage:image];
        return;
    }

    //Assume the string is a url and try and load from the net.
    [self setImageWithURL:[NSURL URLWithString:imageLocation]];
}

@end
