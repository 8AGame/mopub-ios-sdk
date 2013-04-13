//
//  FakeBannerCustomEvent.m
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "FakeBannerCustomEvent.h"

@implementation FakeBannerCustomEvent

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.enableAutomaticImpressionAndClickTracking = YES;
    }
    return self;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    self.size = size;
    self.customEventInfo = info;
    self.presentingViewController = self.delegate.viewControllerForPresentingModalView;
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation
{
    self.orientation = newOrientation;
}

- (void)didDisplayAd
{
    self.didDisplay = YES;
}

- (void)customEventDidUnload
{
    self.didUnload = YES;
    [super customEventDidUnload];
}

- (void)simulateLoadingAd
{
    [self.delegate bannerCustomEvent:self didLoadAd:self.view];
}

- (void)simulateFailingToLoad
{
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)simulateUserTap
{
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)simulateUserEndingInteraction
{
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)simulateUserLeavingApplication
{
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
