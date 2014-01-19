//
//  UISlider+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UISlider+RivetBinder.h"
#import "UIView+Rivet.h"
#import "UIControl+RivetBinder.h"

@implementation UISlider (RivetBinder)

-(id) getDefaultValue {
    return [NSNumber numberWithFloat:self.value];
}

#pragma mark - bind in
-(void) rivetToScope:(id) scope {
    NSError *err = nil;
    self.value = [[[super scope] valueForKeyPath:self.model] floatValue];
    if(err){
        NSLog(@"Unable to compile template: %@ \nwith scope: %@ \nerror:%@", self.template, scope, err);
    }
}

#pragma mark - bind out
-(void) flushUpToModel {
    [self.scope setValue:[NSNumber numberWithFloat:self.value]
              forKeyPath:self.model];
}

@end
