// AFMessagePackRequestOperation.m
//
// Copyright (c) 2013 Richard Lee (http://dlackty.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFMessagePackRequestOperation.h"
#import "MessagePack.h"

@interface AFMessagePackRequestOperation ()
@property (readwrite, nonatomic, strong) id responseMessagePack;
@end

@implementation AFMessagePackRequestOperation

+ (instancetype)messagePackRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id messagePack))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id messagePack))failure
{
  AFMessagePackRequestOperation *requestOperation = [(AFMessagePackRequestOperation *)[self alloc] initWithRequest:urlRequest];
  [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (success) {
      success(operation.request, operation.response, responseObject);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) {
      failure(operation.request, operation.response, error, [(AFMessagePackRequestOperation *)operation responseMessagePack]);
    }
  }];
  
  return requestOperation;
}

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
  return [NSSet setWithObjects:@"application/x-msgpack", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
  return [[[request URL] pathExtension] isEqualToString:@"msgpack"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
  self.completionBlock = ^ {
    if (self.error) {
      if (failure) {
        dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
          failure(self, self.error);
        });
      }
    } else {
      self.responseMessagePack = [self.responseData messagePackParse];
      
      if (success) {
        dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
          success(self, self.responseMessagePack);
        });
      }
    }
  };
#pragma clang diagnostic pop
}

@end
