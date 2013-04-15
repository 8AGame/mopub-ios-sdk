//
//  MPInterstitialCustomEventAdapter.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MPInterstitialCustomEventAdapter.h"

#import "MPAdConfiguration.h"
#import "MPLogging.h"
#import "MPInstanceProvider.h"
#import "MPInterstitialCustomEvent.h"

@interface MPInterstitialCustomEventAdapter ()

@property (nonatomic, retain) MPInterstitialCustomEvent *interstitialCustomEvent;
@property (nonatomic, retain) MPAdConfiguration *configuration;
@property (nonatomic, assign) BOOL hasTrackedImpression;
@property (nonatomic, assign) BOOL hasTrackedClick;

@end

@implementation MPInterstitialCustomEventAdapter
@synthesize hasTrackedImpression = _hasTrackedImpression;
@synthesize hasTrackedClick = _hasTrackedClick;

@synthesize interstitialCustomEvent = _interstitialCustomEvent;

- (void)dealloc
{
    [self.interstitialCustomEvent customEventDidUnload];
    self.interstitialCustomEvent.delegate = nil;
    [[_interstitialCustomEvent retain] autorelease];
    self.interstitialCustomEvent = nil;
    self.configuration = nil;

    [super dealloc];
}

- (void)getAdWithConfiguration:(MPAdConfiguration *)configuration
{
    MPLogInfo(@"Looking for custom event class named %@.", configuration.customEventClass);
    self.configuration = configuration;

    self.interstitialCustomEvent = [[MPInstanceProvider sharedProvider] buildInterstitialCustomEventFromCustomClass:configuration.customEventClass delegate:self];

    if (self.interstitialCustomEvent) {
        [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:configuration.customEventClassData];
    } else {
        [self.delegate adapter:self didFailToLoadAdWithError:nil];
    }
}

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
    [self.interstitialCustomEvent showInterstitialFromRootViewController:controller];
}

#pragma mark - MPInterstitialCustomEventDelegate

- (CLLocation *)location
{
    return [self.delegate location];
}

- (id)interstitialDelegate
{
    return [self.delegate interstitialDelegate];
}

- (void)interstitialCustomEvent:(MPInterstitialCustomEvent *)customEvent
                      didLoadAd:(id)ad
{
    [self.delegate adapterDidFinishLoadingAd:self];
}

- (void)interstitialCustomEvent:(MPInterstitialCustomEvent *)customEvent
       didFailToLoadAdWithError:(NSError *)error
{
    [self.delegate adapter:self didFailToLoadAdWithError:error];
}

- (void)interstitialCustomEventWillAppear:(MPInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialWillAppearForAdapter:self];
}

- (void)interstitialCustomEventDidAppear:(MPInterstitialCustomEvent *)customEvent
{
    if ([self.interstitialCustomEvent enableAutomaticImpressionAndClickTracking] && !self.hasTrackedImpression) {
        self.hasTrackedImpression = YES;
        [self trackImpression];
    }
    [self.delegate interstitialDidAppearForAdapter:self];
}

- (void)interstitialCustomEventWillDisappear:(MPInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialWillDisappearForAdapter:self];
}

- (void)interstitialCustomEventDidDisappear:(MPInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialDidDisappearForAdapter:self];
}

- (void)interstitialCustomEventDidExpire:(MPInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialDidExpireForAdapter:self];
}

- (void)interstitialCustomEventDidReceiveTapEvent:(MPInterstitialCustomEvent *)customEvent
{
    if ([self.interstitialCustomEvent enableAutomaticImpressionAndClickTracking] && !self.hasTrackedClick) {
        self.hasTrackedClick = YES;
        [self trackClick];
    }
}

- (void)interstitialCustomEventWillLeaveApplication:(MPInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialWillLeaveApplicationForAdapter:self];
}

@end
