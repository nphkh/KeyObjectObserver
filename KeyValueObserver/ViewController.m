//
//  ViewController.m
//  KeyValueObserver
//
//  Created by Khang Nguyen on 9/6/17.
//  Copyright © 2017 Khang Nguyen. All rights reserved.
//

#import "ViewController.h"

#import "ViewModel.h"
#import "ObjectObserver.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UILabel *testlabel;
@property(nonatomic, weak) IBOutlet UIButton *requestButton;
@property(nonatomic, strong) ObjectObserver *observer;
@property(nonatomic, strong) ViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.viewModel = [[ViewModel alloc] init];
  self.observer = [[ObjectObserver alloc] initWithTarget:self];  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
//  [self.observer observeObject:self.viewModel keyPath:@"testLabelText" action:@selector(updateUI:)];
  [self.observer bindObject:self.viewModel withKeypath:@"testLabelText" toObject:self.testlabel toKeyPath:@"text"];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self.observer invalidate];
}

- (void)updateUI:(NSDictionary *)dictionary
{
  self.testlabel.text = dictionary[NSKeyValueChangeNewKey];
}

- (IBAction)request:(id)sender
{
  self.viewModel.testLabelText = @"It has been changed";
}

@end
