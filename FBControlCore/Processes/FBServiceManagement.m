/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBServiceManagement.h"

#import <ServiceManagement/ServiceManagement.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

@implementation FBServiceManagement

+ (nullable NSDictionary<NSString *, id> *)jobInformationForUserServiceNamed:(NSString *)serviceName
{
  CFDictionaryRef dictionary = SMJobCopyDictionary(kSMDomainUserLaunchd, (__bridge CFStringRef) serviceName);
  return (__bridge_transfer NSDictionary *) dictionary;
}

+ (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *)jobInformationForUserServicesNamed:(NSArray<NSString *> *)serviceNames
{
  NSSet<NSString *> *serviceSet = [NSSet setWithArray:serviceNames];

  CFArrayRef jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
  NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *jobInformation = [NSMutableDictionary dictionary];
  for (CFIndex index = 0; index < CFArrayGetCount(jobs); index++) {
    NSDictionary *dictionary = (__bridge NSDictionary *) CFArrayGetValueAtIndex(jobs, index);
    NSString *labelString = dictionary[@"Label"];
    if (![serviceSet containsObject:labelString]) {
      continue;
    }
    jobInformation[labelString] = dictionary;
  }
  return [jobInformation copy];
}

@end

#pragma clang diagnostic pop
