/*
 Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at

 http://aws.amazon.com/apache2.0

 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */
 

#import <Foundation/Foundation.h>
#import <AWSAPIGateway/AWSAPIGateway.h>



NS_ASSUME_NONNULL_BEGIN

/**
 The service client object.
 */
@interface AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient: AWSAPIGatewayClient

/**
 Returns the singleton service client. If the singleton object does not exist, the SDK instantiates the default service client with `defaultServiceConfiguration` from `[AWSServiceManager defaultServiceManager]`. The reference to this object is maintained by the SDK, and you do not need to retain it manually.

 If you want to enable AWS Signature, set the default service configuration in `- application:didFinishLaunchingWithOptions:`
 
 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
         AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
          AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                          identityPoolId:@"YourIdentityPoolId"];
          AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                               credentialsProvider:credentialsProvider];
          [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

          return YES;
      }

 Then call the following to get the default service client:

 *Swift*

     let serviceClient = AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient.defaultClient()

 *Objective-C*

     AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient *serviceClient = [AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient defaultClient];

 Alternatively, this configuration could also be set in the `info.plist` file of your app under `AWS` dictionary with a configuration dictionary by name `AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient`.

 @return The default service client.
 */
+ (instancetype)defaultClient;

/**
 Creates a service client with the given service configuration and registers it for the key.

 If you want to enable AWS Signature, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient.registerClientWithConfiguration(configuration, forKey: "USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient registerClientWithConfiguration:configuration forKey:@"USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient(forKey: "USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient")

 *Objective-C*

     AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient *serviceClient = [AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient clientForKey:@"USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient"];

 @warning After calling this method, do not modify the configuration object. It may cause unspecified behaviors.

 @param configuration A service configuration object.
 @param key           A string to identify the service client.
 */
+ (void)registerClientWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;

/**
 Retrieves the service client associated with the key. You need to call `+ registerClientWithConfiguration:forKey:` before invoking this method or alternatively, set the configuration in your application's `info.plist` file. If `+ registerClientWithConfiguration:forKey:` has not been called in advance or if a configuration is not present in the `info.plist` file of the app, this method returns `nil`.

 For example, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient.registerClientWithConfiguration(configuration, forKey: "USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient registerClientWithConfiguration:configuration forKey:@"USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient(forKey: "USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient")

 *Objective-C*

     AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient *serviceClient = [AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient clientForKey:@"USWest2AWSAPI_0MZ6OXIFT5_SwapUsersMobileHubClient"];

 @param key A string to identify the service client.

 @return An instance of the service client.
 */
+ (instancetype)clientForKey:(NSString *)key;

/**
 Removes the service client associated with the key and release it.
 
 @warning Before calling this method, make sure no method is running on this client.
 
 @param key A string to identify the service client.
 */
+ (void)removeClientForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
