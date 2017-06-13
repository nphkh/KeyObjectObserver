# KeyObjectObserver

A helper to do databiding with KVO.

## Usage

To use the helper, simply import ObjectObserver.h and ObjectObserver.m into your project. Instantiate ObjectObserver in the class
that you want to monitor the change of object. 

```objective-c
  self.observer = [[ObjectObserver alloc] initWithTarget:self];
```

Then register a call back when the keypath of the object changes in viewWillAppear

```objective-c
[self.observer observeObject:self.viewModel
	             keyPath:@"name"
                      action:@selector(nameChanged:)];
```

Value of object also can be bound to value of the other object. Example

```objective-c
[self.observer bindObject:self.viewModel 
              withKeypath:@"email"
                 toObject:self.emailLabel 
                toKeyPath:@"text"];
```

When the email property of viewModel objecg is changed, emailLabel's text will be set to its value.

## Demo

<p align="center">
<img src="https://media.giphy.com/media/q7SCUL47kugjS/giphy.gif"
alt="KeyObjectObserver">
</p>


