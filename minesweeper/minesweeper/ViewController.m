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

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *replayButton;
@property (strong, nonatomic) IBOutlet UILabel *mineCounterLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) GameModel *gameModel;

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.gameModel = [GameModel new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        cell.backgroundColor = UIColor.greenColor;
        cell.imageView.hidden = YES;
        cell.mineCountLabel.hidden = YES;
    } else {
        cell.backgroundColor = UIColor.redColor;
        switch (tileModel.tileState) {
            case TileStateNoMine:
                cell.imageView.hidden = YES;
                break;
            case TileStateMine:
                cell.imageView.image = [UIImage imageNamed:@"mine"];
                cell.imageView.hidden = NO;
                break;
            case TileStateProtected:
                break;
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameModel.isGameOver) {
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
    
}

- (void)updateTimerLabel {
    self.gameModel.seconds += 1;
    self.timerLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameModel.seconds];
}

@end
