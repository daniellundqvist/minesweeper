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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeGame];
    }
    return self;
}

- (void)initializeGame {
    self.isGameStarted = NO;
    self.mineCounter = @10;
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

- (void)turnTileAtIndexPath:(NSIndexPath *)indexPath {
    TileModel *tile = self.tiles[indexPath.section][indexPath.row];
    tile.turned = YES;
}

- (void)startGameWithTileAtIndexPath:(NSIndexPath *)indexPath {
    TileModel *tile = self.tiles[indexPath.section][indexPath.row];
    tile.tileState = TileStateProtected;
    tile.turned = YES;
    self.isGameStarted = YES;
}

@end
