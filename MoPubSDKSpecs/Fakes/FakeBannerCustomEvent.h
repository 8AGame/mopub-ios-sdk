//
//  FakeBannerCustomEvent.h
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "MPBannerCustomEvent.h"

@interface FakeBannerCustomEvent : MPBannerCustomEvent

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) NSDictionary *customEventInfo;
@property (nonatomic, assign) BOOL didUnload;
@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) UIViewController *presentingViewController;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) BOOL enableAutomaticMetricsTracking;
@property (nonatomic, assign) BOOL didDisplay;

- (id)initWithFrame:(CGRect)frame;
- (void)simulateLoadingAd;
- (void)simulateFailingToLoad;
- (void)simulateUserTap;
- (void)simulateUserEndingInteraction;
- (void)simulateUserLeavingApplication;

@end
