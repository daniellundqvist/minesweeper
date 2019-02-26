//
//  GameModel.m
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import "GameModel.h"

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
    self.mineCounter = @10;
    self.tiles = [NSMutableArray new];
    for (int section = 0; section < numberOfTilesInSection; section++) {
        self.tiles[section] = [NSMutableArray new];
        for (int row = 0; row < numberOfTilesInSection; row++) {
            // Create tile models
            NSString *tile = @"tile";
            self.tiles[section][row] = tile;
        }
    }
}

@end
