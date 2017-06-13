//
//  ObjectObserver.m
//  TestKeyObsever
//
//  Created by Nguyen, K. (Khang) on 6/06/2017.
//  Copyright © 2017 Nguyen, K. (Khang). All rights reserved.
//

#import "ObjectObserver.h"

static void* const ObjectObserverContext = (void *)&ObjectObserverContext;

@interface ObjectObserver()

@property(nonatomic, assign) id target;
@property(nonatomic, strong) NSMutableArray *observers;

@end

#pragma mark - Observer interface

@interface Observer: NSObject

@property(nonatomic, weak) id target;
@property(nonatomic, assign) SEL action;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, weak) NSObject *observedObject;
@property(nonatomic, weak) NSObject *boundObject;
@property(nonatomic, copy) NSString *boundKeyPath;

- (instancetype)initWithObserverObject:(NSObject *)object;

- (void)addTarget:(id)target keyPath:(NSString *)keyPath action:(SEL)action;
- (void)addTarget:(id)target keyPath:(NSString *)keyPath boundObject:(NSObject *)boundObject boundKeyPath:(NSString *)boundKeypath action:(SEL)action;

@end

@implementation ObjectObserver

- (instancetype)initWithTarget:(id)target
{
  if (self = [super init]) {
    _target = target;
    _observers = [NSMutableArray new];
  }
  
  return self;
}

- (void)observeObject:(NSObject *)object keyPath:(NSString *)keyPath action:(SEL)action
{
  Observer *observer = [[Observer alloc] initWithObserverObject:object];
  [observer addTarget:self.target keyPath:keyPath action:action];
  
  [self.observers addObject:observer];
}

- (void)bindObject:(NSObject *)object withKeypath:(NSString *)keypath toObject:(NSObject *)toObject toKeyPath:(NSString *)toKeyPath
{
  Observer *observer = [[Observer alloc] initWithObserverObject:object];
  
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  [observer addTarget:observer keyPath:keypath boundObject:toObject boundKeyPath:toKeyPath action:@selector(observedObjectChange:)];
  
  #pragma clang diagnostic pop
  
  [self.observers addObject:observer];
}

- (void)dealloc
{
  [self.observers removeAllObjects];
}

- (void)invalidate
{
  [self.observers removeAllObjects];
}

@end

#pragma mark - ObjectObserver implementation

@implementation Observer

- (instancetype)initWithObserverObject:(NSObject *)object
{
  if (self = [super init]) {
    _observedObject = object;
  }
  
  return self;
}

- (void)addTarget:(id)target keyPath:(NSString *)keyPath action:(SEL)action
{
  self.target = target;
  self.keyPath = keyPath;
  self.action = action;
  
  [self.observedObject addObserver:self forKeyPath:self.keyPath options:NSKeyValueObservingOptionNew context:ObjectObserverContext];
}

- (void)addTarget:(id)target keyPath:(NSString *)keyPath boundObject:(NSObject *)boundObject boundKeyPath:(NSString *)boundKeypath action:(SEL)action
{
  self.target = target;
  self.keyPath = keyPath;
  self.action = action;
  self.boundObject = boundObject;
  self.boundKeyPath = boundKeypath;
  
  [self.observedObject addObserver:self forKeyPath:self.keyPath options:NSKeyValueObservingOptionNew context:ObjectObserverContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
  if (context == ObjectObserverContext) {
    IMP imp = [self.target methodForSelector:self.action];
    void (*func)(id, SEL, NSDictionary*) = (void *)imp;
    func(self.target, self.action, change);
  }
}

- (void)observedObjectChange:(NSDictionary *)changeDictionary
{
  [self.boundObject setValue:changeDictionary[NSKeyValueChangeNewKey] forKey:self.boundKeyPath];
}

- (void)invalidate
{
  [self.observedObject removeObserver:self forKeyPath:self.keyPath];
}

- (void)dealloc
{
  [self invalidate];
}

@end
