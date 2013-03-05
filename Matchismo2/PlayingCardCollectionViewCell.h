//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Victor Engel on 2/26/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
