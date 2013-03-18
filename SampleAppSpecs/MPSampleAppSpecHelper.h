//
//  MPSampleAppSpecHelper.h
//  MoPubSampleApp
//
//  Created by pivotal on 3/18/13.
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foundation+PivotalSpecHelper.h"
#import "UIKit+PivotalSpecHelper.h"
#import "NSObject+MethodRedirection.h"
#import "FakeMPSampleAppInstanceProvider.h"

typedef id (^IDReturningBlock)();

extern FakeMPSampleAppInstanceProvider *fakeProvider;

@interface MPSampleAppSpecHelper : NSObject

@end
