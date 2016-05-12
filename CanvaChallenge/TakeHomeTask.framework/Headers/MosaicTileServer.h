//
//  MosaicTileServer.h
//  TakeHomeTask
//
//  Copyright © 2016 Canva. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * An interface to a tile server, fetches images.
 */
@interface MosaicTileServer : NSObject

/**
 * Create a default mosaic tile server.
 * Note: It must be retained until fetch callbacks are called, it can be reused.
 */
-(instancetype _Nonnull) init NS_DESIGNATED_INITIALIZER;

/**
 * Fetch a mosaic tile from the "server" for a given color.
 *
 * @param color The color that the returned tile represents.
 * @param size The size of the tile being requested.
 * @param success The callback called with the tile image after a successful server response.
 * @param success The callback when the request fails, it has an `MosaicTileServerErrorDomain` error.
 * @return A cancellable progress object that can be used to track the request.
 */
-(NSProgress * _Nonnull) fetchTileForColor: (UIColor * _Nonnull) color
                                      size: (CGSize)size
                                   success: (void(^ _Nonnull)(UIImage * _Nonnull image)) success
                                   failure: (void(^ _Nonnull)(NSError * _Nonnull error)) failure;


@end

/**
 * The domain used for errors returned by `MosaicTileServer` requests.
 **/
extern NSString * const _Nonnull MosaicTileServerErrorDomain;

/**
 * The error codes used for `MosaicTileServerErrorDomain` errors.
 **/
typedef NS_ENUM(NSUInteger, MosaicTileServerErrorCode) {
    // The request timed out, probably network connectivity
    Timeout = 1,
    // The server response could not be interpreted correctly.
    ServerError = 2
};
