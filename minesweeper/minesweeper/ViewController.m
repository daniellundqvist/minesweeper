//
//  ViewController.m
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import "ViewController.h"
#import "GameModel.h"

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 9;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tile" forIndexPath:indexPath];
    
    return cell;
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


@end
