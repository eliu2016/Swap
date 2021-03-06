

//
//  AWSCloudLogic.h
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//

#import <AWSCore/AWSCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Cloud logic helper singleton class that provides convenient interface to invoke
 * AWS Lambda functions and handle the results asynchronously.
 * Requires the AWSLambda framework of AWSiOSSDK.
 */
@interface AWSCloudLogic : NSObject

/**
 Returns the default Cloud Logic singleton instance configured using the information provided in `Info.plist` file.
 
 *Swift*
 
    let cloudLogic = AWSCloudLogic.defaultCloudLogic()
 
 *Objective-C*

    AWSCloudLogic *cloudLogic =  [AWSCloudLogic defaultCloudLogic];
 
 */
+ (instancetype)defaultCloudLogic NS_SWIFT_NAME(defaultCloudLogic());

/**
 Creates a helper client for `AWSCloud` for specified configuration with mentioned key.
 Use this method only if you require a helper client with specific configuration.
 
 For example, set the configuration in `- application:didFinishLaunchingWithOptions:`
 
  *Swift*
 
    let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
    let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
 
    AWSCloudLogic.registercloudLogicWithConfiguration(configuration, forKey: "USWest2cloudLogic")
 
 *Objective-C*
 
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                    identityPoolId:@"YourIdentityPoolId"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                         credentialsProvider:credentialsProvider];
    [AWSCloudLogic registercloudLogicWithConfiguration:configuration
                                                forKey:@"USWest2cloudLogic"];
 
 Then call the following to get the helper client:
 
 *Swift*
 
 	let cloudLogic = AWSCloudLogic(forKey: "USWest2cloudLogic")
 
 *Objective-C*
 
 	AWSCloudLogic *cloudLogic = [AWSCloudLogic cloudLogicForKey:@"USWest2cloudLogic"];
 
 @warning After calling this method, do not modify the configuration object. It may cause unspecified behaviors.
 
 @param  serviceConfiguration    AWSServiceConfiguration object for the cloud logic.
 @param  key                     A string to identify the helper client.
 */
+ (void)registerCloudLogicWithConfiguration:(AWSServiceConfiguration *)serviceConfiguration
                                     forKey:(NSString *)key;

/**
 Retrieves the helper client associated with the key. You need to call `+ registercloudLogicWithConfiguration:` before invoking this method. If `+ registercloudLogicWithConfiguration:` has not been called in advance or the key does not exist, this method returns `nil`.
 
 *Swift*
 
    let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
    let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
 
    AWSCloudLogic.registercloudLogicWithConfiguration(configuration, forKey: "USWest2cloudLogic")
 
 *Objective-C*
 
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                    identityPoolId:@"YourIdentityPoolId"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                         credentialsProvider:credentialsProvider];
    [AWSCloudLogic registercloudLogicWithConfiguration:configuration
                                                forKey:@"USWest2cloudLogic"];
 
 Then call the following to get the helper client:
 
 *Swift*
 
 	let CloudLogic = AWSCloudLogic.CloudLogic(forKey: "USWest2cloudLogic")
 
 *Objective-C*
 
 	AWSCloudLogic *CloudLogic = [AWSCloudLogic CloudLogicForKey:@"USWest2cloudLogic"];
 
 @param  key  A string to identify the helper client.
 @return An instance of AWSCloudLogic for specified key.
 */
+ (instancetype)CloudLogicForKey:(NSString *)key NS_SWIFT_NAME(CloudLogic(forKey:));

/**
 Removes the helper client associated with the key and release it.
 
 *Swift*
 
    AWSCloudLogic.removecloudLogicForKey("USWest2cloudLogic")
 
 *Objective-C*
 
    [AWSCloudLogic removecloudLogicForKey:@"USWest2cloudLogic"];
 
 @warning Before calling this method, make sure no method is running on this client.
 
 @param key A string to identify the helper client.
 */
+ (void)removeCloudLogicForKey:(NSString *)key;

/**
 Invokes the specified AWS Lambda function and passes the results and possible error back to the application asynchronously.
 
 @param name AWS Lambda function name, e.g., hello-world
 @param parameters The object from which to generate JSON request data. Can be `nil`.
 @param completionBlock handler for results from the function
 */
- (void)invokeFunction:(NSString *)name
        withParameters:(nullable id)parameters
       completionBlock:(void (^)(id result, NSError *error))completionBlock;

@end

NS_ASSUME_NONNULL_END

