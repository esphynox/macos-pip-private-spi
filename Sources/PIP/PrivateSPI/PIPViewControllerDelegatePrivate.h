#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PIPViewController;

@protocol PIPViewControllerDelegate <NSObject>
@optional
- (BOOL)pipShouldClose:(PIPViewController *)pip;
- (void)pipWillClose:(PIPViewController *)pip;
- (void)pipDidClose:(PIPViewController *)pip;
- (void)pipActionPlay:(PIPViewController *)pip;
- (void)pipActionPause:(PIPViewController *)pip;
- (void)pipActionStop:(PIPViewController *)pip;
- (void)pipActionClose:(PIPViewController *)pip;
- (void)pipActionRestore:(PIPViewController *)pip;
- (void)pipActionReturn:(PIPViewController *)pip;
- (void)pipAction:(PIPViewController *)pip skipInterval:(NSTimeInterval)interval;
@end

NS_ASSUME_NONNULL_END
