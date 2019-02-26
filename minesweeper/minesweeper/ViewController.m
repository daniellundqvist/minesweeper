//
//  ViewController.m
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import "ViewController.h"
#import "GameModel.h"
#import "TileModel.h"
#import "TileCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet UIButton *replayButton;
@property (strong, nonatomic) IBOutlet UILabel *mineCounterLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property (nonatomic) GameModel *gameModel;

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.gameModel = [GameModel new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.delaysTouchesBegan = YES;
    longPress.minimumPressDuration = 0.5f;
    [self.collectionView addGestureRecognizer:longPress];
    
    self.flowLayout.minimumLineSpacing = spacing;
    self.flowLayout.minimumInteritemSpacing = spacing;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 9;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tile" forIndexPath:indexPath];
    TileModel *tileModel = self.gameModel.tiles[indexPath.section][indexPath.row];
    
    if (!tileModel.turned) {
        cell.mineCountLabel.hidden = YES;
        cell.backgroundColor = UIColor.greenColor;
        if (tileModel.flagged) {
            cell.imageView.image = [UIImage imageNamed:@"flag"];
            cell.imageView.hidden = NO;
        } else {
            cell.imageView.hidden = YES;
        }
    } else {
        cell.backgroundColor = UIColor.redColor;
        switch (tileModel.tileState) {
            case TileStateNoMine:
                cell.imageView.hidden = YES;
                if (tileModel.mineCount > 0) {
                    cell.mineCountLabel.text = [NSString stringWithFormat:@"%ld", (long)tileModel.mineCount];
                    cell.mineCountLabel.hidden = NO;
                } else {
                    cell.mineCountLabel.hidden = YES;
                }
                break;
            case TileStateMine:
                cell.imageView.image = [UIImage imageNamed:@"mine"];
                cell.imageView.hidden = NO;
                cell.mineCountLabel.hidden = YES;
                break;
            case TileStateProtected:
                break;
            default:
                break;
        }
    }
    
    if (self.gameModel.isGameOver) {
        if (!tileModel.turned) {
            if (tileModel.flagged && tileModel.tileState == TileStateNoMine) {
                cell.imageView.image = [UIImage imageNamed:@"mine_misplaced"];
                cell.imageView.hidden = NO;
            } else if (!tileModel.flagged && tileModel.tileState == TileStateMine) {
                cell.imageView.image = [UIImage imageNamed:@"mine"];
                cell.imageView.hidden = NO;
            }
        }
        [self.replayButton setTitle:@":(" forState:UIControlStateNormal];
    }
    
    if (self.gameModel.isGameWon) {
        if (tileModel.tileState == TileStateMine) {
            cell.imageView.image = [UIImage imageNamed:@"flag"];
            cell.imageView.hidden = NO;
            [self.replayButton setTitle:@":D" forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.gameModel isTileTurnedOrFlaggedAtIndexPath:indexPath] || self.gameModel.isGameOver || self.gameModel.isGameWon) {
        return;
    }
    
    if (self.gameModel.isGameStarted) {
        [self.gameModel turnTileAtIndexPath:indexPath];
    } else {
        [self.gameModel startGameWithTileAtIndexPath:indexPath];
        // Add and start timer
        self.gameModel.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.gameModel.timer forMode:NSRunLoopCommonModes];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tileSize = (self.view.frame.size.width / self.collectionView.numberOfSections) - 2 * spacing;
    return CGSizeMake(tileSize, tileSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

#pragma mark - Action Methods

- (IBAction)replayButtonTapped:(id)sender {
    [self.gameModel initializeGame];
    [self.replayButton setTitle:@":)" forState:UIControlStateNormal];
    self.mineCounterLabel.text = @"10";
    self.timerLabel.text = @"0";
    
    [self.collectionView reloadData];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (self.gameModel.isGameOver || self.gameModel.isGameWon) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath) {
            TileModel *tileModel = self.gameModel.tiles[indexPath.section][indexPath.row];
            if (tileModel.turned) {
                return;
            }
            if (tileModel.flagged) {
                tileModel.flagged = NO;
                int value = [self.gameModel.mineCounter intValue];
                self.gameModel.mineCounter = [NSNumber numberWithInt:value + 1];
            } else {
                tileModel.flagged = YES;
                int value = [self.gameModel.mineCounter intValue];
                self.gameModel.mineCounter = [NSNumber numberWithInt:value - 1];
            }
            
            // Haptic feedback
            UIImpactFeedbackGenerator *feed = [UIImpactFeedbackGenerator new];
            [feed impactOccurred];
            
            self.mineCounterLabel.text = [NSString stringWithFormat:@"%@", self.gameModel.mineCounter];
            
            [self.collectionView reloadData];
        }
    }
    
}

- (void)updateTimerLabel {
    self.gameModel.seconds += 1;
    self.timerLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameModel.seconds];
}

@end
