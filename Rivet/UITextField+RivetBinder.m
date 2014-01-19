//
//  UITextField+RivetBinder.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UITextField+RivetBinder.h"
#import "UIView+Rivet.h"
#import "UIControl+RivetBinder.h"

@implementation UITextField (RivetBinder)

-(id) getDefaultValue {
    return self.text;
}

-(void) rivetToScope:(id)scope {
    NSError *err = nil;
    NSString *template = (self.template ? self.template : [NSString stringWithFormat:@"{{%@}}", self.model]);
    self.text = [super compileTemplate:template toStringWithScope:scope error: &err];
    if(err){
        NSLog(@"Unable to compile template: %@ \nwith scope: %@ \nerror:%@", template, scope, err);
    }
}

-(void) flushUpToModel {
     [self.scope setValue:self.text forKeyPath:self.model];
}

#pragma mark - handling scope
-(void) attachScope:(id) scope {
    [self addTarget:self action:@selector(flushUpToModel) forControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidEndOnExit];
    [self ensureModelPathExists:scope];
    [super attachScope:scope];
}

-(void) detachScope:(id) scope {
    [self removeTarget:self action:@selector(flushUpToModel) forControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidEndOnExit];
    [super detachScope:scope];
}

@end
