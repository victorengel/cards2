//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Victor Engel on 2/26/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation PlayingCardGameViewController

-(Deck *)createDeck //abstract in CardGameViewController, but we implement it here.
{
   return [[PlayingCardDeck alloc] init];
}
- (NSUInteger) startingCardCount //abstract in CardGameViewController, but we implement it here.
{
   return 20;
}
-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card //abstract in CardGameViewController, but we implement it here.
{
   if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
      PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
      if ([card isKindOfClass:[PlayingCard class]]) {
         PlayingCard *playingCard = (PlayingCard *)card;
         playingCardView.rank = playingCard.rank;
         playingCardView.suit = playingCard.suit;
         playingCardView.faceUp = playingCard.isFaceUp;
         playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
      }
   }
}


@end
