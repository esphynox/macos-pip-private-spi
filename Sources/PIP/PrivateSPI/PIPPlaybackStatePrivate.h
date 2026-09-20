#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PIPPlaybackState : NSObject
@end

@interface PIPMutablePlaybackState : PIPPlaybackState
@property (nonatomic) NSTimeInterval contentDuration;
@property (nonatomic) NSInteger contentType;
- (void)setPlaybackRate:(double)playbackRate
            elapsedTime:(NSTimeInterval)elapsedTime
      timeControlStatus:(NSInteger)timeControlStatus;
@end

NS_ASSUME_NONNULL_END
