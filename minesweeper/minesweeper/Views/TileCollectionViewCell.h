//
//  TileCollectionViewCell.h
//  minesweeper
//
//  Created by Daniel Lundqvist on 2019-02-26.
//  Copyright © 2019 Daniel Lundqvist. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TileCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *mineCountLabel;

@end

NS_ASSUME_NONNULL_END
