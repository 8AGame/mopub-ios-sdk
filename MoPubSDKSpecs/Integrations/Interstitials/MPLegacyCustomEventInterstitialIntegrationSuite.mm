#import "MPAdConfigurationFactory.h"
#import "MPInterstitialAdController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@protocol FakeLegacyCustomEvent <MPInterstitialAdControllerDelegate>
- (void)legacyMethod:(MPInterstitialAdController *)controller;
@end

SPEC_BEGIN(MPLegacyCustomEventInterstitialIntegrationSuite)

describe(@"MPLegacyCustomEventInterstitialIntegrationSuite", ^{
    __block id<FakeLegacyCustomEvent, CedarDouble> delegate;
    __block MPInterstitialAdController *interstitial = nil;
    __block FakeMPAdServerCommunicator *communicator;
    __block MPAdConfiguration *configuration;

    beforeEach(^{
        delegate = nice_fake_for(@protocol(FakeLegacyCustomEvent));

        interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"legacy_custom_event_interstitial"];
        interstitial.delegate = delegate;

        [interstitial loadAd];
        communicator = fakeProvider.lastFakeMPAdServerCommunicator;
        communicator.loadedURL.absoluteString should contain(@"legacy_custom_event_interstitial");

        NSDictionary *headers = @{
                                  kCustomSelectorHeaderKey: @"legacyMethod",
                                  kAdTypeHeaderKey: @"custom"
                                  };
        configuration = [MPAdConfigurationFactory defaultInterstitialConfigurationWithHeaders:headers HTMLString:nil];
        [communicator receiveConfiguration:configuration];

        // clear out the communicator so we can make future assertions about it
        [communicator resetLoadedURL];

        // Just to make the compiler happy.

        id<FakeInterstitialAd> fakeInterstitialAd = fake_for(@protocol(FakeInterstitialAd));
        fakeInterstitialAd stub_method("presentingViewController").and_return((id)nil);
        setUpInterstitialSharedContext(communicator, delegate, interstitial, @"legacy_custom_event_interstitial", fakeInterstitialAd, configuration.failoverURL);
    });

    context(@"while the ad is loading", ^{
        it(@"should call the custom selector on the interstitial delegate", ^{
            verify_fake_received_selectors(delegate, @[@"legacyMethod:"]);
        });

        it(@"should not be ready", ^{
            interstitial.ready should equal(NO);
        });

        context(@"and the user tries to load again", ^{ itShouldBehaveLike(anInterstitialThatPreventsLoading); });
        context(@"and the timeout interval elapses", ^{ itShouldBehaveLike(anInterstitialThatTimesOut); });

        context(@"and the user tries to show the ad", ^{
            beforeEach(^{
                [delegate reset_sent_messages];
                UIViewController *controller = [[[UIViewController alloc] init] autorelease];
                [interstitial showFromViewController:controller];
            });

            it(@"should do nothing", ^{
                delegate.sent_messages should be_empty;
            });
        });
    });

    context(@"when the ad successfully loads", ^{
        beforeEach(^{
            [delegate reset_sent_messages];
            fakeProvider.sharedFakeMPAnalyticsTracker.trackedImpressionConfigurations.count should equal(0);
            [interstitial customEventDidLoadAd];
        });

        it(@"should track an impression (just once)", ^{
            fakeProvider.sharedFakeMPAnalyticsTracker.trackedImpressionConfigurations.count should equal(1);

            [interstitial customEventDidLoadAd];
            fakeProvider.sharedFakeMPAnalyticsTracker.trackedImpressionConfigurations.count should equal(1);
        });

        it(@"should not tell the delegate anything and should not be ready", ^{
            delegate.sent_messages should be_empty;
            interstitial.ready should equal(NO);
        });

        context(@"and the user tries to load again", ^{
            beforeEach(^{
                [delegate reset_sent_messages];
                [interstitial loadAd];
                [communicator receiveConfiguration:configuration];
            });

            it(@"should call the custom selector on the interstitial delegate (again)", ^{
                verify_fake_received_selectors(delegate, @[@"legacyMethod:"]);
            });
        });

        context(@"and the user tries to show the ad", ^{
            beforeEach(^{
                [delegate reset_sent_messages];
                UIViewController *controller = [[[UIViewController alloc] init] autorelease];
                [interstitial showFromViewController:controller];
            });

            it(@"should do nothing", ^{
                delegate.sent_messages should be_empty;
            });
        });

        context(@"and the timeout interval elapses", ^{ itShouldBehaveLike(anInterstitialThatDoesNotTimeOut); });
    });

    context(@"when the ad fails to load", ^{
        beforeEach(^{
            [delegate reset_sent_messages];
            [interstitial customEventDidFailToLoadAd];
        });

        itShouldBehaveLike(anInterstitialThatLoadsTheFailoverURL);
        context(@"and the timeout interval elapses", ^{ itShouldBehaveLike(anInterstitialThatDoesNotTimeOut); });
    });

    context(@"when a custom event action begins", ^{
        beforeEach(^{
            [delegate reset_sent_messages];
            fakeProvider.sharedFakeMPAnalyticsTracker.trackedClickConfigurations.count should equal(0);
            [interstitial customEventActionWillBegin];
        });

        it(@"should track a click (just once)", ^{
            fakeProvider.sharedFakeMPAnalyticsTracker.trackedClickConfigurations.count should equal(1);

            [interstitial customEventActionWillBegin];
            fakeProvider.sharedFakeMPAnalyticsTracker.trackedClickConfigurations.count should equal(1);
        });

        it(@"should not tell the delegate anything", ^{
            delegate.sent_messages should be_empty;
        });
    });
});

SPEC_END
