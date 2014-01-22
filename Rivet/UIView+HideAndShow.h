//
//  UIView+HideAndShow.h
//  Rivet
//
//  Created by Aaron Signorelli on 22/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivetView.h"

@interface UIView (HideAndShow) <RivetView>

@property(nonatomic, retain) NSString *hide;
@property(nonatomic, retain) NSString *show;

@end
