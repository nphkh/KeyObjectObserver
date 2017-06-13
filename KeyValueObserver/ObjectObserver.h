//
//  ObjectObserver.h
//  TestKeyObsever
//
//  Created by Nguyen, K. (Khang) on 6/06/2017.
//  Copyright © 2017 Nguyen, K. (Khang). All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define SafeKey(class, key)              ([(class *)nil key] ? @#key : @#key)
#define ProtocolKey(protocol, key)   ([(id <protocol>)nil key] ? @#key : @#key)
#else
#define SafeKey(class, key)              @#key
#define ProtocolKey(class, key)      @#key
#endif

@interface ObjectObserver : NSObject

- (instancetype)initWithTarget:(id)target;

- (void)observeObject:(NSObject *)object keyPath:(NSString *)keyPath action:(SEL)action;
- (void)bindObject:(NSObject *)object withKeypath:(NSString *)keypath toObject:(NSObject *)toObject toKeyPath:(NSString *)toKeyPath;
- (void)invalidate;

@end
