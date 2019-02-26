//
//  TileModel.h
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TileState) {
    TileStateNoMine,
    TileStateMine,
    TileStateProtected,
};

@interface TileModel : NSObject

@property (nonatomic) TileState tileState;
@property (nonatomic) BOOL flagged;
@property (nonatomic) BOOL turned;
@property (nonatomic) BOOL hint;
@property (nonatomic) NSInteger mineCount;

@end

NS_ASSUME_NONNULL_END
