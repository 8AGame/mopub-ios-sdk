//
//  FakeMPTimer.h
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "MPTimer.h"

@interface FakeMPTimer : MPTimer

+ (FakeMPTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                                target:(id)target
                              selector:(SEL)aSelector
                               repeats:(BOOL)repeats;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL isScheduled;
@property (nonatomic, assign) BOOL isPaused;


- (void)trigger;

@end
