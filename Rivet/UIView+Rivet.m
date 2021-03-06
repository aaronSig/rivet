//
//  UIView+Rivet.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIView+Rivet.h"
#import <objc/runtime.h>
#import "GRMustache.h"
#import "NSObject+BlockObservation.h"
#import "Rivetable.h"

static char const * const RivetTemplateKey = "RivetTemplate";
static char const * const RivetScopeKey = "RivetScope";

@implementation UIView (Rivet)

@dynamic scope, template;

#pragma mark - scope
-(id) scope {
    return objc_getAssociatedObject(self, RivetScopeKey);
}

#pragma mark - template accessors
-(NSString *) template {
    NSString *template = objc_getAssociatedObject(self, RivetTemplateKey);
    if(template) {
        return template;
    }
    
    //Dirty hack to allow us to set the template in the text field in interface builder
    if([self respondsToSelector:@selector(text)]) {
        template = [self performSelector:@selector(text)];
        if([template length] > 0 && [template rangeOfString:@"{{"].location != NSNotFound && [template rangeOfString:@"}}"].location != NSNotFound) {
            [self setTemplate:template];
            [self performSelector:@selector(setText:) withObject:@""];
        } else {
            template = nil;
        }
    }
    
    return template;
}

-(void) setTemplate:(NSString *)template {
    objc_setAssociatedObject(self, RivetTemplateKey, template, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) isRivetable {
    return [self template] != nil;
}

-(BOOL) hasTemplate {
    return [self template] != nil;
}

-(NSString *) compileTemplate:(NSString*) template toStringWithScope:(id) scope error:(NSError **)error{
    [GRMustacheConfiguration defaultConfiguration].contentType = GRMustacheContentTypeText;
    NSString *rendered = [GRMustacheTemplate renderObject:scope
                                               fromString:template
                                                    error:error];
    return rendered;
}

-(NSString *) keyPathFromTemplate {
    return [[self keyPathsInTemplate] objectAtIndex:0];
}

-(NSArray *) keyPathsInTemplate {
    if(self.hasTemplate == NO) {
        return [NSArray array];
    }
    NSMutableArray *keyPaths = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{.*?\\}\\}" options:0 error:nil];
    NSArray *matches = [regex matchesInString:self.template
                                      options:0
                                        range:NSMakeRange(0, [self.template length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        NSString *matchString = [self.template substringWithRange:NSMakeRange(matchRange.location + 2, matchRange.length - 4)];
        [keyPaths addObject:matchString];
    }
    return [NSArray arrayWithArray:keyPaths];
}

#pragma mark - listening for scope changes
-(void) attachScope:(id) scope {
    objc_setAssociatedObject(self, RivetScopeKey, scope, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSArray *keyPaths = [self keyPathsInTemplate];
    for(NSString *keyPath in keyPaths) {
        [scope watchKeyPath:keyPath task:^(id object, NSDictionary *change) {
            [self changeSeenOnKeyPath:keyPath object:object change:change];
        }];
    }
}

//Something in the scope has changed. Trigger a recompile of the template.
-(void) changeSeenOnKeyPath:(NSString *) keyPath object:(id) object change:(NSDictionary *) change {
    // TODO in the future we can optimise to only change the part of the view that needs changing.
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self conformsToProtocol:@protocol(Rivetable)]){
            if(![self isFirstResponder]){
                [(id<Rivetable>)self rivetToScope:object];
            }
            return;
        }
    });
}

-(void) detachScope:(id) scope {
    //N.B. From what I've read we don't have to remove the observers. GC should handle that.
    
    objc_setAssociatedObject(self, RivetScopeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - helpers
// Returns all the subviews which conform the the Rivetable protocol
// including those which are subviews of subviews.
-(NSArray *) rivetableSubviews {
    NSArray *subviews = [self subviews];
    NSMutableArray *rivetableSubviews = [[NSMutableArray alloc] init];
    for(UIView *subview in subviews) {
        if([subview isRivetable]){
            [rivetableSubviews addObject:subview];
        }
        [rivetableSubviews addObjectsFromArray:[subview rivetableSubviews]];
    }
    return [NSArray arrayWithArray:rivetableSubviews];
}


@end
