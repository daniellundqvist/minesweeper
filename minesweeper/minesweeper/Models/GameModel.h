//
//  GameModel.h
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat const spacing;
extern int const numberOfTilesInSection;

@interface GameModel : NSObject

@property (nonatomic) NSMutableArray *tiles;
@property (nonatomic) BOOL isGameStarted;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) NSNumber *mineCounter;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger seconds;

- (void)initializeGame;
- (void)startGameWithTileAtIndexPath:(NSIndexPath *)indexPath;
- (void)turnTileAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isTileTurnedOrFlaggedAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
