//
//  HttpUtils.m
//  EaseMobClientSDK
//
//  Created by Ji Fang on 9/21/13.
//  Copyright (c) 2013 EaseMob. All rights reserved.
//

#import "HttpUtils.h"
#import "ASIHTTPRequest.h"
#import "EMCJSONSerializer.h"
#import "NSDictionary_JSONExtensions.h"

@interface HttpUtils()

+ (NSDictionary *)_httpDelete:(NSString *)aUri
                      headers:(NSArray *)headers
                    parameter:(NSDictionary *)aParam
                   credential:(NSString *)aCredential
                 responseCode:(int *)pRespCode
                      timeout:(NSInteger)aTimeout
                        retry:(BOOL)retry;
+ (NSDictionary *)_httpPut:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                credential:(NSString *)aCredential
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry;
+ (NSDictionary *)_httpGet:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                credential:(NSString *)aCredential
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry;
+ (NSDictionary *)_httpPost:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                 credential:(NSString *)aCredential
               responseCode:(int *)pRespCode
                    timeout:(NSInteger)aTimeout
                      retry:(BOOL)retry;
+ (NSDictionary *)_httpDelete:(NSString *)aUri
                      headers:(NSArray *)headers
                    parameter:(NSDictionary *)aParam
                     username:(NSString *)username
                     password:(NSString *)password
                 responseCode:(int *)pRespCode
                      timeout:(NSInteger)aTimeout
                        retry:(BOOL)retry;
+ (NSDictionary *)_httpPut:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                  username:(NSString *)username
                  password:(NSString *)password
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry;
+ (NSDictionary *)_httpGet:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                  username:(NSString *)username
                  password:(NSString *)password
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry;
+ (NSDictionary *)_httpPost:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                   username:(NSString *)username
                   password:(NSString *)password
               responseCode:(int *)pRespCode
                    timeout:(NSInteger)aTimeout
                      retry:(BOOL)retry;

+ (BOOL)_validateUri:(NSString *)aUri;

@end

@implementation HttpUtils

static int kTimeoutRetryCount = 3;
#define kNULL @"(null)"

#ifdef DEBUG
+ (void)catchFailure:(int)retCode expected:(int)expectedCode {
    expectedCode = 401;
    if(!VALIDATE_HTTPSTATUS_CODE(retCode)) {
        NSLog(@"%d catched!", retCode);
    }
}
#endif

+ (BOOL)_validateUri:(NSString *)aUri {
    BOOL ret = NO;
    NSRange range = [aUri rangeOfString:kNULL];
    if (range.location == NSNotFound) {
        ret = YES;
    }
    
    return ret;
}

+ (BOOL)validateUri:(NSString *)aUri {
    BOOL ret = NO;
    ret = [HttpUtils _validateUri:aUri];
    
    return ret;
}

#pragma mark - helper
+ (NSDictionary *)_httpDelete:(NSString *)aUri
                      headers:(NSArray *)headers
                    parameter:(NSDictionary *)aParam
                   credential:(NSString *)aCredential
                 responseCode:(int *)pRespCode
                      timeout:(NSInteger)aTimeout
                        retry:(BOOL)retry {
    NSDictionary *ret = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return ret;
    }
    
    int retCode = -1;
    __block int retryCount = 1;
    __block EMASIHTTPRequest *request = nil;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"DELETE"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO; // TODO
            if (https) {
                [request setValidatesSecureCertificate:NO];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // add credential header
            if(aCredential.length>0) {
                // TODO
                NSString *token = [[NSString alloc] initWithFormat:@"Bearer %@", aCredential];
                [request addRequestHeader:@"Authorization"
                                    value:token];
            }
            
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set put data if any.
            if(aParam) {
                NSError *error = nil;
                EMCJSONSerializer *serializer = [EMCJSONSerializer serializer];
                NSData *jsonData = [serializer serializeDictionary:aParam error:&error];
                if(error) {
                    NSLog(@"convert to json data failed.");
                } else {
                    NSMutableData *mdata = [NSMutableData dataWithData:jsonData];
                    [request setPostBody:mdata];
                }
            }
            
            [request setAllowCompressedResponse:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.",
                  aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);

    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        ret = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        ret = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }

    return ret;
}

+ (NSDictionary *)_httpPut:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                credential:(NSString *)aCredential
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return retDict;
    }
    
    __block EMASIHTTPRequest *request = nil;
    int retCode = -1;
    __block int retryCount = 1;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"PUT"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO;
            if (https) { // TODO
                [request setValidatesSecureCertificate:NO];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // add credential header
            if(aCredential.length>0) {
                // TODO
                NSString *token = [[NSString alloc] initWithFormat:@"Bearer %@", aCredential];
                [request addRequestHeader:@"Authorization"
                                    value:token];
            }
            
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set put data if any.
            if(aParam) {
                NSError *error = nil;
                EMCJSONSerializer *serializer = [EMCJSONSerializer serializer];
                NSData *jsonData = [serializer serializeDictionary:aParam error:&error];
                if(error) {
                    NSLog(@"convert to json data failed.");
                } else {
                    NSMutableData *mdata = [NSMutableData dataWithData:jsonData];
                    [request setPostBody:mdata];
                }
            }
            [request setAllowCompressedResponse:YES];
            //[request setShouldCompressRequestBody:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.",
                  aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);

    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        retDict = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        retDict = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return retDict;
}

+ (NSDictionary *)_httpGet:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
              credential:(NSString *)aCredential
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return retDict;
    }
    
    aUri = [aUri stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    aUri = [aUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __block EMASIHTTPRequest *request = nil;
    int retCode = -1;
    __block int retryCount = 1;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO;
            if (https) { // TODO
                [request setValidatesSecureCertificate:NO];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // add credential header
            if(aCredential.length>0) {
                // TODO
                NSString *token = [[NSString alloc] initWithFormat:@"Bearer %@", aCredential];
                [request addRequestHeader:@"Authorization"
                                    value:token];
            }
            
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set post data if any.
            if(aParam) {
                NSArray *allKeys = [aParam allKeys];
                for(NSString *key in allKeys) {
                    NSString *value = [aParam objectForKey:key];
                    [request addRequestHeader:key value:value];
                }
            }
            [request setAllowCompressedResponse:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.",
                  aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);
    
    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        retDict = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        retDict = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return retDict;
}

+ (NSDictionary *)_httpPost:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                 credential:(NSString *)aCredential
               responseCode:(int *)pRespCode
                    timeout:(NSInteger)aTimeout
                      retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return retDict;
    }
    
    int retCode = -1;
    __block int retryCount = 1;
    __block EMASIHTTPRequest *request = nil;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"POST"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO;
            if (https) { // TODO
                [request setValidatesSecureCertificate:NO];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // add credential header
            if(aCredential.length>0) {
                // TODO
                NSString *token = [[NSString alloc] initWithFormat:@"Bearer %@", aCredential];
                [request addRequestHeader:@"Authorization"
                                    value:token];
            }
            
            //是否是form表单形式的body数据提交
            BOOL isFormData = NO;
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    //如果Content-Type是form表单类型, 标记isFromData为YES
                    NSString *formContentType = @"application/x-www-form-urlencoded";
                    if ([[header objectForKey:@"Content-Type"] isEqualToString:formContentType]) {
                        isFormData = YES;
                    }
                    NSArray *allKeys = [header allKeys];
                    //循环获取header, 并添加到request中
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set post data if any.
            if(aParam) {
                NSData *postBody = nil;
                //如果是form表单类型数据, 循环取得所有的key value
                if (isFormData) {
                    NSArray *allKeys = [aParam allKeys];
                    NSMutableArray *keyAndValueArray = [NSMutableArray array];
                    //循环生成key=value, 并将字符串保存到数组
                    for (int index=0; index<allKeys.count; index++)
                    {
                        NSString *key = allKeys[index];
                        NSString *value = aParam[key];
                        NSString *param = [NSString stringWithFormat:@"%@=%@", key, value];
                        [keyAndValueArray addObject:param];
                    }
                    //将数组通过"&"拼接成字符串
                    //拼接完成后的params格式为: key1=value1&key2=value2&key3=value3
                    NSString *formParams = [keyAndValueArray componentsJoinedByString:@"&"];
                    postBody = [formParams dataUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"POST Body: %@", formParams);
                }else{
                    EMCJSONSerializer *serializer = [EMCJSONSerializer serializer];
                    NSError *error = nil;
                    postBody = [serializer serializeDictionary:aParam error:&error];
                    if (error) {
                        NSLog(@"convert to json data failed.");
                    }
                    NSLog(@"POST Body: %@", aParam);
                }
                
                if(postBody) {
                    NSMutableData *mdata = [NSMutableData dataWithData:postBody];
                    [request setPostBody:mdata];
                }
            }
            [request setAllowCompressedResponse:YES];
            //[request setShouldCompressRequestBody:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, response code:%d.", api, ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);
    
    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        retDict = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        retDict = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return retDict;
}

+ (NSDictionary *)_httpDelete:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                   username:(NSString *)username
                   password:(NSString *)password
               responseCode:(int *)pRespCode
                      timeout:(NSInteger)aTimeout
                        retry:(BOOL)retry {
    NSDictionary *ret = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return ret;
    }
    
    __block EMASIHTTPRequest *request = nil;
    int retCode = -1;
    __block int retryCount = 1;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"DELETE"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO;
            if (https) { // TODO
                [request setValidatesSecureCertificate:NO];
            }
            
            // set credential info.
            if(username.length>0) {
                [request setUsername:username];
            }
            if(password.length>0) {
                [request setPassword:password];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set put data if any.
            if(aParam) {
                NSError *error = nil;
                EMCJSONSerializer *serializer = [EMCJSONSerializer serializer];
                NSData *jsonData = [serializer serializeDictionary:aParam error:&error];
                if(error) {
                    NSLog(@"convert to json data failed.");
                } else {
                    NSMutableData *mdata = [NSMutableData dataWithData:jsonData];
                    [request setPostBody:mdata];
                }
            }
            
            [request setAllowCompressedResponse:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.", aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);
    
    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        ret = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        ret = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return ret;
}

+ (NSDictionary *)_httpPut:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
                username:(NSString *)username
                password:(NSString *)password
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return retDict;
    }
    
    __block EMASIHTTPRequest *request = nil;
    int retCode = -1;
    __block int retryCount = 1;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"PUT"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO;
            if (https) { // TODO
                [request setValidatesSecureCertificate:NO];
            }
            
            // set credential info.
            if(username.length>0) {
                [request setUsername:username];
            }
            if(password.length>0) {
                [request setPassword:password];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set put data if any.
            if(aParam) {
                NSError *error = nil;
                EMCJSONSerializer *serializer = [EMCJSONSerializer serializer];
                NSData *jsonData = [serializer serializeDictionary:aParam error:&error];
                if(error) {
                    NSLog(@"convert to json data failed.");
                } else {
                    NSMutableData *mdata = [NSMutableData dataWithData:jsonData];
                    [request setPostBody:mdata];
                }
            }
            [request setAllowCompressedResponse:YES];
            //[request setShouldCompressRequestBody:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.", aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);
    
    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        retDict = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        retDict = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return retDict;
}

+ (NSDictionary *)_httpGet:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
                username:(NSString *)username
                password:(NSString *)password
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return retDict;
    }
    
    aUri = [aUri stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    aUri = [aUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    __block EMASIHTTPRequest *request = nil;
    int retCode = -1;
    __block int retryCount = 1;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO; // TODO
            if (https) {
                [request setValidatesSecureCertificate:NO];
            }
            
            // set credential info.
            if(username.length>0) {
                [request setUsername:username];
            }
            if(password.length>0) {
                [request setPassword:password];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set post data if any.
            if(aParam) {
                NSArray *allKeys = [aParam allKeys];
                for(NSString *key in allKeys) {
                    NSString *value = [aParam objectForKey:key];
                    [request addRequestHeader:key value:value];
                }
            }
            [request setAllowCompressedResponse:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.", aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);
    
    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        retDict = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        retDict = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return retDict;
}

+ (NSDictionary *)_httpPost:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                   username:(NSString *)username
                   password:(NSString *)password
               responseCode:(int *)pRespCode
                    timeout:(NSInteger)aTimeout
                      retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    if (![HttpUtils _validateUri:aUri]) {
        if (pRespCode) {
            *pRespCode = -1;
        }
        return retDict;
    }
    
    __block EMASIHTTPRequest *request = nil;
    int retCode = -1;
    __block int retryCount = 1;
    int (^block)(NSString *api) = ^(NSString *api) {
        int ret = -1;
        NSURL *url = [NSURL URLWithString:api];
        do {
            request = [EMASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"POST"];
            if (retry) {
                [request setNumberOfTimesToRetryOnTimeout:1];
            }
            [request setShouldAttemptPersistentConnection:YES];
            if (aTimeout>0) {
                [request setTimeOutSeconds:aTimeout * retryCount];
            }
            BOOL https = NO; // TODO
            if (https) {
                [request setValidatesSecureCertificate:NO];
            }
            
            // set credential info.
            if(username.length>0) {
                [request setUsername:username];
            }
            if(password.length>0) {
                [request setPassword:password];
            }
            
            // add content type json header
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json"];
            [request addRequestHeader:@"User-Agent"
                                value:[self httpHeaderUserAgent]];
            
            // handle additional headers
            if(headers) {
                for(NSDictionary *header in headers) {
                    NSArray *allKeys = [header allKeys];
                    for(NSString *key in allKeys) {
                        NSString *value = [header objectForKey:key];
                        [request addRequestHeader:key
                                            value:value];
                    }
                }
            }
            
            // set post data if any.
            if(aParam) {
                EMCJSONSerializer *serializer = [EMCJSONSerializer serializer];
                NSError *error = nil;
                NSData *jsonData = [serializer serializeDictionary:aParam error:&error];
                if(error) {
                    NSLog(@"convert to json data failed.");
                } else {
                    NSMutableData *mdata = [NSMutableData dataWithData:jsonData];
                    [request setPostBody:mdata];
                }
            }
            [request setAllowCompressedResponse:YES];
            //[request setShouldCompressRequestBody:YES];
            [request startSynchronous];
            ret = [request responseStatusCode];
            NSLog(@"URI:%@, param:%@, response code:%d.", aUri, aParam!=nil?aParam:@"nil", ret);
        }while(retry && !VALIDATE_HTTPSTATUS_CODE(ret) &&
               INVALIDATE_SERVER_HTTPSTATUS_CODE(ret) &&
               ++retryCount<=kTimeoutRetryCount);
        
        return ret;
    };
    retCode = block(aUri);
    
    if(pRespCode) {
        *pRespCode = retCode;
    }
    
    if(retCode == HTTP_OK_NOCONTENT) {
        retDict = [NSDictionary dictionary];
    } else {
        NSData *data = [request responseData];
        NSError *error = nil;
        retDict = [NSDictionary dictionaryWithJSONData:data error:&error];
        if(error) {
            NSLog(@"convert to json data failed while processing response data, error:%@", error);
            NSLog(@"response message:%@", [request responseString]);
        }
    }
    
    return retDict;
}

#pragma mark - http methods
+ (NSDictionary *)httpDelete:(NSString *)aUri
                     headers:(NSArray *)headers
                   parameter:(NSDictionary *)aParam
                  credential:(NSString *)aCredential
                responseCode:(int *)pRespCode
                     timeout:(NSInteger)aTimeout
                       retry:(BOOL)retry {
    NSDictionary *ret = nil;

    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsDelete:aUri
                             headers:headers
                           parameter:aParam
                          credential:aCredential
                        responseCode:pRespCode
                             timeout:aTimeout
                               retry:retry];
    } else {
        ret = [HttpUtils _httpDelete:aUri
                             headers:headers
                           parameter:aParam
                          credential:aCredential
                        responseCode:pRespCode
                             timeout:aTimeout
                               retry:retry];
    }
    
    return ret;
}
+ (NSDictionary *)httpPut:(NSString *)aUri
                  headers:(NSArray *)headers
                parameter:(NSDictionary *)aParam
               credential:(NSString *)aCredential
             responseCode:(int *)pRespCode
                  timeout:(NSInteger)aTimeout
                    retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsPut:aUri
                          headers:headers
                        parameter:aParam
                       credential:aCredential
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    } else {
        ret = [HttpUtils _httpPut:aUri
                          headers:headers
                        parameter:aParam
                       credential:aCredential
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    }
    
    return ret;
}
+ (NSDictionary *)httpGet:(NSString *)aUri
                  headers:(NSArray *)headers
                parameter:(NSDictionary *)aParam
               credential:(NSString *)aCredential
             responseCode:(int *)pRespCode
                  timeout:(NSInteger)aTimeout
                    retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsGet:aUri
                          headers:headers
                        parameter:aParam
                       credential:aCredential
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    } else {
        ret = [HttpUtils _httpGet:aUri
                          headers:headers
                        parameter:aParam
                       credential:aCredential
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    }
    
    return ret;
}
+ (NSDictionary *)httpPost:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                credential:(NSString *)aCredential
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsPost:aUri
                           headers:headers
                         parameter:aParam
                        credential:aCredential
                      responseCode:pRespCode
                           timeout:aTimeout
                             retry:retry];
    } else {
        ret = [HttpUtils _httpPost:aUri
                           headers:headers
                         parameter:aParam
                        credential:aCredential
                      responseCode:pRespCode
                           timeout:aTimeout
                             retry:retry];
    }
    
    return ret;
}

#pragma mark - http method with basic authentication
+ (NSDictionary *)httpDelete:(NSString *)aUri
                     headers:(NSArray *)headers
                   parameter:(NSDictionary *)aParam
                    username:(NSString *)username
                    password:(NSString *)password
                responseCode:(int *)pRespCode
                     timeout:(NSInteger)aTimeout
                       retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsDelete:aUri
                             headers:headers
                           parameter:aParam
                            username:username
                            password:password
                        responseCode:pRespCode
                             timeout:aTimeout
                               retry:retry];
    } else {
        ret = [HttpUtils _httpDelete:aUri
                             headers:headers
                           parameter:aParam
                            username:username
                            password:password
                        responseCode:pRespCode
                             timeout:aTimeout
                               retry:retry];
    }
    
    return ret;
}
+ (NSDictionary *)httpPut:(NSString *)aUri
                  headers:(NSArray *)headers
                parameter:(NSDictionary *)aParam
                 username:(NSString *)username
                 password:(NSString *)password
             responseCode:(int *)pRespCode
                  timeout:(NSInteger)aTimeout
                    retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsPut:aUri
                          headers:headers
                        parameter:aParam
                         username:username
                         password:password
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    } else {
        ret = [HttpUtils _httpPut:aUri
                          headers:headers
                        parameter:aParam
                         username:username
                         password:password
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    }
    
    return ret;
}

+ (NSDictionary *)httpGet:(NSString *)aUri
                  headers:(NSArray *)headers
                parameter:(NSDictionary *)aParam
                 username:(NSString *)username
                 password:(NSString *)password
             responseCode:(int *)pRespCode
                  timeout:(NSInteger)aTimeout
                    retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsGet:aUri
                          headers:headers
                        parameter:aParam
                         username:username
                         password:password
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    } else {
        ret = [HttpUtils _httpGet:aUri
                          headers:headers
                        parameter:aParam
                         username:username
                         password:password
                     responseCode:pRespCode
                          timeout:aTimeout
                            retry:retry];
    }
    
    return ret;
}

+ (NSDictionary *)httpPost:(NSString *)aUri
                   headers:(NSArray *)headers
                 parameter:(NSDictionary *)aParam
                  username:(NSString *)username
                  password:(NSString *)password
              responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    BOOL https = NO; // TODO
    if (https) {
        ret = [HttpUtils httpsPost:aUri
                           headers:headers
                         parameter:aParam
                          username:username
                          password:password
                      responseCode:pRespCode
                           timeout:aTimeout
                             retry:retry];
    } else {
        ret = [HttpUtils _httpPost:aUri
                           headers:headers
                         parameter:aParam
                          username:username
                          password:password
                      responseCode:pRespCode
                           timeout:aTimeout
                             retry:retry];
    }
    
    return ret;
}

#pragma mark - https methods
+ (NSDictionary *)httpsDelete:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                 credential:(NSString *)aCredential
               responseCode:(int *)pRespCode
                      timeout:(NSInteger)aTimeout
                        retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    ret = [self _httpDelete:httpsUri
                    headers:headers
                  parameter:aParam
                 credential:aCredential
               responseCode:pRespCode
                    timeout:aTimeout
                      retry:retry];
    
    return ret;
}

+ (NSDictionary *)httpsPut:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
              credential:(NSString *)aCredential
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    retDict = [self _httpPut:httpsUri
                     headers:headers
                   parameter:aParam
                  credential:aCredential
                responseCode:pRespCode
                     timeout:aTimeout
                       retry:retry];
    
    return retDict;
}

+ (NSDictionary *)httpsGet:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
              credential:(NSString *)aCredential
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    retDict = [self _httpGet:httpsUri
                     headers:headers
                   parameter:aParam
                  credential:aCredential
                responseCode:pRespCode
                     timeout:aTimeout
                       retry:retry];
    
    return retDict;
}

+ (NSDictionary *)httpsPost:(NSString *)aUri
                  headers:(NSArray *)headers
                parameter:(NSDictionary *)aParam
               credential:(NSString *)aCredential
             responseCode:(int *)pRespCode
                    timeout:(NSInteger)aTimeout
                      retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    retDict = [self _httpPost:httpsUri
                      headers:headers
                    parameter:aParam
                   credential:aCredential
                 responseCode:pRespCode
                      timeout:aTimeout
                        retry:retry];
    
    return retDict;
}

#pragma mark - http method with basic authentication
+ (NSDictionary *)httpsDelete:(NSString *)aUri
                    headers:(NSArray *)headers
                  parameter:(NSDictionary *)aParam
                   username:(NSString *)username
                   password:(NSString *)password
               responseCode:(int *)pRespCode
                      timeout:(NSInteger)aTimeout
                        retry:(BOOL)retry {
    NSDictionary *ret = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    ret = [self _httpDelete:httpsUri
                    headers:headers
                  parameter:aParam
                   username:username
                   password:password
               responseCode:pRespCode
                    timeout:aTimeout
                      retry:retry];
    
    return ret;
}

+ (NSDictionary *)httpsPut:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
                username:(NSString *)username
                password:(NSString *)password
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    retDict = [self _httpPut:httpsUri
                     headers:headers
                   parameter:aParam
                    username:username
                    password:password
                responseCode:pRespCode
                     timeout:aTimeout
                       retry:retry];

    return retDict;
}

+ (NSDictionary *)httpsGet:(NSString *)aUri
                 headers:(NSArray *)headers
               parameter:(NSDictionary *)aParam
                username:(NSString *)username
                password:(NSString *)password
            responseCode:(int *)pRespCode
                   timeout:(NSInteger)aTimeout
                     retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    retDict = [self _httpGet:httpsUri
                     headers:headers
                   parameter:aParam
                    username:username
                    password:password
                responseCode:pRespCode
                     timeout:aTimeout
                       retry:retry];
    
    return retDict;
}

+ (NSDictionary *)httpsPost:(NSString *)aUri
                  headers:(NSArray *)headers
                parameter:(NSDictionary *)aParam
                 username:(NSString *)username
                 password:(NSString *)password
             responseCode:(int *)pRespCode
                    timeout:(NSInteger)aTimeout
                      retry:(BOOL)retry {
    NSDictionary *retDict = nil;
    
    NSString *httpsUri = [aUri stringByReplacingOccurrencesOfString:@"http://" 
                                                         withString:@"https://"];
    
    retDict = [self _httpPost:httpsUri
                      headers:headers
                    parameter:aParam
                     username:username
                     password:password
                 responseCode:pRespCode
                      timeout:aTimeout
                        retry:retry];

    return retDict;
}

+ (NSString *)httpHeaderUserAgent{
    NSString *version = @"0.0.1";
    NSString *userAgent = [NSString stringWithFormat:@"WeiNai(iOS) %@", version];
    return userAgent;
}

@end
