//
//  KIFTestScenario+GAD.m
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "KIFTestScenario+GAD.h"
#import "UIView-KIFAdditions.h"

@implementation KIFTestStep (GADScenario)

+ (KIFTestStep *)stepToDismissGADInterstitial {
    return [KIFTestStep stepWithDescription:@"Dismiss GAD interstitial" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError *__autoreleasing *error) {

        UIViewController *topMostViewController = [KIFHelper topMostViewController];

        UIButton *closeButton = [[KIFHelper findViewsOfClass:[UIButton class]] lastObject];
        [closeButton tap];

        [KIFHelper waitForViewControllerToStopAnimating:topMostViewController];
        return KIFTestStepResultSuccess;
    }];
}

@end


@implementation KIFTestScenario (GAD)

+ (KIFTestScenario *)scenarioForGADInterstitial
{
    KIFTestScenario *scenario = [MPSampleAppTestScenario scenarioWithDescription:@"Test that a GAD interstitial ad works."];
    NSIndexPath *indexPath = [MPAdSection indexPathForAd:@"Google AdMob Interstitial" inSection:@"Interstitial Ads"];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Ad Table View"
                                                                     atIndexPath:indexPath]];

    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Load"]];
    [scenario addStep:[KIFTestStep stepToWaitUntilActivityIndicatorIsNotAnimating]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show"]];
    [scenario addStep:[KIFTestStep stepToVerifyPresentationOfViewControllerClass:NSClassFromString(@"GADWebAppViewController")]];
    [scenario addStep:[KIFTestStep stepToDismissGADInterstitial]];

    [scenario addStep:[KIFTestStep stepToReturnToBannerAds]];

    return scenario;
}

@end
