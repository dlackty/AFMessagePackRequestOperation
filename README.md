# AFMessagePackRequestOperation

AFMessagePackRequestOperation is an extension for [AFNetworking](http://github.com/AFNetworking/AFNetworking/) that provides an interface to parse [MessagePack](http://msgpack.org/).

## Example Usage

``` objective-c
AFMessagePackRequestOperation *operation = [AFMessagePackRequestOperation messagePackRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/example.msgpack"]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id *messagePack) {
      NSLog(@"MessagePack: %@", messagePack);
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id *messagePack) {
      NSLog(@"Failure!");
}];

[operation start];
```

## Contact

Richard Lee

- http://github.com/dlackty
- http://twitter.com/dlackty
- dlackty@gmail.com

## License

AFMessagePackRequestOperation is available under the MIT license. See the LICENSE file for more info.