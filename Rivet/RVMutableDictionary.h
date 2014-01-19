//
//  RVMutableDictionary.h
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RVMutableDictionary : NSObject {
    NSMutableDictionary *_backingDict;
}

- (void) setObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
