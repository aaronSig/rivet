//
//  UIView+Rivet.h
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Binding.h"

@interface UIView (Rivet)

@property(nonatomic, retain) NSMutableArray *bindings;
@property (nonatomic, readonly) id scope;

-(void) attachScope:(id) scope;
-(void) detachScope:(id) scope;
-(BOOL) isRivetable;
-(BOOL) hasBindings;

-(void) addBinding: (Binding *)binding;

-(NSArray *) rivetableSubviews;
-(void) viewDidUpdate;

@end
