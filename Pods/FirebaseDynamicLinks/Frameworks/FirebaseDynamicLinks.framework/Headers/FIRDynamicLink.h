#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @file FIRDynamicLink.h
 * @abstract Dynamic Link object used in Firebase Dynamic Links.
 */

/**
 * @enum FIRDynamicLinkMatchConfidence
 * @abstract The confidence level of the matched Dynamic Link.
 */
typedef NS_ENUM(NSUInteger, FIRDynamicLinkMatchConfidence) {
  /**
   * The match between the Dynamic Link and this device may not be perfect, hence you should not
   *    reveal any personal information related to the dynamic link.
   */
  FIRDynamicLinkMatchConfidenceWeak,
  /**
   * The match between the Dynamic Link and this device is exact, hence you may reveal personal
   *     information related to the Dynamic Link.
   */
  FIRDynamicLinkMatchConfidenceStrong
};

/**
 * @class FIRDynamicLink
 * @abstract A received Dynamic Link.
 */
@interface FIRDynamicLink : NSObject

/**
 * @property url
 * @abstract The URL that was passed to the app.
 */
@property(nonatomic, copy, readonly, nullable) NSURL *url;

/**
 * @property matchConfidence
 * @abstract The match confidence of the received Dynamic Link.
 */
@property(nonatomic, assign, readonly) FIRDynamicLinkMatchConfidence matchConfidence;

@end

NS_ASSUME_NONNULL_END
