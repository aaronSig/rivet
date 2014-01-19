//
//  UIView+Rivet.h
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rivet)

@property(nonatomic, retain) NSString *template;
@property (nonatomic, readonly) id scope;

-(NSArray *) rivetableSubviews;
-(void) attachScope:(id) scope;
-(void) detachScope:(id) scope;
-(BOOL) isRivetable;
-(BOOL) hasTemplate;
-(NSString *) keyPathFromTemplate;
-(NSString *) compileTemplate:(NSString*) template toStringWithScope:(id) scope error:(NSError **)error;

@end
