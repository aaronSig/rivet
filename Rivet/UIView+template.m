//
//  UIView+template.m
//  Rivet
//
//  Created by Aaron Signorelli on 22/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "UIView+template.h"

static char const * const RivetTemplateKey = "RivetTemplate";

@implementation UIView (template)

@dynamic template;

-(NSString *) template {
    return objc_getAssociatedObject(self, RivetTemplateKey);
}

-(void) setTemplate:(NSString *) template {
    objc_setAssociatedObject(self, RivetTemplateKey, template, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
