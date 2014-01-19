//
//  RVMutableDictionary.m
//  Rivet
//
//  Created by Aaron Signorelli on 18/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import "RVMutableDictionary.h"

//
// A MutableDictionary that ignores nils as values for keys. Saves neither the value or the key.
// also creates a new pairing if asked to set a value for an undefined key.
//

@implementation RVMutableDictionary

-(instancetype) init {
    self = [super init];
    if(self) {
        _backingDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if(anObject == nil) {
        return;
    }
    [_backingDict setObject:anObject forKey:aKey];
}

-(id) valueForKey:(NSString *) key {
    return [_backingDict objectForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [_backingDict setObject:value forKey:key];
}

//Dont override. We do want the app to error out if there is a missing key
//- (id)valueForUndefinedKey:(NSString *)key {
//
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [_backingDict setObject:value forKey:key];
}

#pragma mark - passing messages to the backing dictionary
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([_backingDict respondsToSelector:
         [anInvocation selector]])
        [anInvocation invokeWithTarget:_backingDict];
    else
        [super forwardInvocation:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMutableDictionary instanceMethodSignatureForSelector:aSelector];
}

#pragma mark - remaing KVO compliant. Invisibly ignoring this class
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    [_backingDict addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    [_backingDict removeObserver:observer forKeyPath:keyPath context:context];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    [_backingDict removeObserver:observer forKeyPath: keyPath];
}

-(NSString *) description {
    return [_backingDict description];
}

@end
