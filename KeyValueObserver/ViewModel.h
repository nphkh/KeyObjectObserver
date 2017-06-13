//
//  ViewModel.h
//  KeyValueObserver
//
//  Created by Khang Nguyen on 12/6/17.
//  Copyright © 2017 Khang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject

@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *name;

- (void)request;

@end
