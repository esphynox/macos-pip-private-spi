#import <Cocoa/Cocoa.h>

#import "PIPPlaybackStatePrivate.h"
#import "PIPViewControllerDelegatePrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PIPViewController : NSViewController
@property (nonatomic, weak, nullable) id<PIPViewControllerDelegate> delegate;
@property (nonatomic, weak, nullable) NSWindow *replacementWindow;
@property (nonatomic) NSRect replacementRect;
@property (nonatomic) BOOL playing;
@property (nonatomic) BOOL userCanResize;
@property (nonatomic) NSSize aspectRatio;
- (void)presentViewControllerAsPictureInPicture:(NSViewController *)viewController;
- (void)updatePlaybackStateUsingBlock:(void (NS_NOESCAPE ^)(PIPMutablePlaybackState *state))block;
@end

NS_ASSUME_NONNULL_END
