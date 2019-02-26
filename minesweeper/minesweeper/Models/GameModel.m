//
//  GameModel.m
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import "GameModel.h"
#import "TileModel.h"

CGFloat const spacing = 0.3f;
int const numberOfTilesInSection = 9;
int const numberOfMines = 10;

@implementation GameModel

- (void)dealloc {
    [self.timer invalidate];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeGame];
    }
    return self;
}

- (void)initializeGame {
    self.isGameStarted = self.isGameOver = NO;
    [self.timer invalidate];
    self.mineCounter = @10;
    self.seconds = 0;
    self.tiles = [NSMutableArray new];
    // Create representation of sections and rows
    for (int section = 0; section < numberOfTilesInSection; section++) {
        self.tiles[section] = [NSMutableArray new];
        for (int row = 0; row < numberOfTilesInSection; row++) {
            // Create tile models
            TileModel *tile = [TileModel new];
            tile.tileState = TileStateNoMine;
            self.tiles[section][row] = tile;
        }
    }
}

- (void)placeMines {
    int placedMines = 0;
    while (placedMines < numberOfMines) {
        int randomSection = arc4random_uniform(numberOfTilesInSection);
        int randomRow = arc4random_uniform(numberOfTilesInSection);
        TileModel *tile = self.tiles[randomSection][randomRow];
        if (tile.tileState != TileStateProtected && tile.tileState != TileStateMine) {
            tile.tileState = TileStateMine;
            placedMines += 1;
        }
    }
}

- (void)turnTileAtIndexPath:(NSIndexPath *)indexPath {
    TileModel *tile = self.tiles[indexPath.section][indexPath.row];
    tile.turned = YES;
    tile.mineCount = [self getMineCountForTileAtIndexPath:indexPath];
    
    if (tile.tileState == TileStateMine) {
        self.isGameOver = YES;
        [self.timer invalidate];
    }
}

- (void)startGameWithTileAtIndexPath:(NSIndexPath *)indexPath {
    TileModel *tile = self.tiles[indexPath.section][indexPath.row];
    tile.tileState = TileStateProtected;
    tile.turned = YES;
    
    [self placeMines];
    
    self.isGameStarted = YES;
}

- (BOOL)isTileTurnedOrFlaggedAtIndexPath:(NSIndexPath *)indexPath {
    TileModel *tile = self.tiles[indexPath.section][indexPath.row];
    return tile.turned || tile.flagged;
}

- (NSInteger)getMineCountForTileAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger mineCount = 0;
    NSMutableArray *models = [self getModelsForTilesSurroundingIndexPath:indexPath];
    for (TileModel *tile in models) {
        if (tile.tileState == TileStateMine) {
            mineCount++;
        }
    }
    return mineCount;
}

- (NSMutableArray *)getModelsForTilesSurroundingIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *models = [NSMutableArray new];
    for (int section = -1; section < 2; section++) {
        for (int row = -1; row < 2; row++) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row + row inSection:indexPath.section + section];
            if (currentIndexPath.section >= 0 && currentIndexPath.section < numberOfTilesInSection) {
                if (currentIndexPath.row >= 0 && currentIndexPath.row < numberOfTilesInSection) {
                    TileModel *tile = self.tiles[currentIndexPath.section][currentIndexPath.row];
                    [models addObject:tile];
                }
            }
        }
    }
    return models;
}

@end
