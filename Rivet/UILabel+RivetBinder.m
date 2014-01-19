//
//  UILabel+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UILabel+RivetBinder.h"
#import "UIView+Rivet.h"

@implementation UILabel (RivetBinder)

-(void) rivetToScope:(id) scope {
    NSError *err = nil;
    self.text = [super compileTemplate:self.template toStringWithScope:scope error: &err];
    if(err){
        NSLog(@"Unable to compile template: %@ \nwith scope: %@ \nerror:%@", self.template, scope, err);
    }
}

@end
