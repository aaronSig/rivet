//
//  UIControl+RivetBinder.h
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (RivetBinder)

@property(nonatomic, retain) NSString* model;

-(void) ensureModelPathExists:(id) scope;

@end
