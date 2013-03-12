//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetGame.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController()
//not working right when using following line. Need to work out bug in SetGame.m
@property (strong, nonatomic) SetGame *game;
@end

@implementation SetGameViewController

-(SetGame *)game
{
   //   if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
   if (!_game) _game = [[SetGame alloc] initWithCardCount:self.startingCardCount
                                                usingDeck:[self createDeck]];
   return _game;
}

-(Deck *)createDeck //abstract in CardGameViewController, but we implement it here.
{
   return [[SetCardDeck alloc] init];
}
- (NSUInteger) startingCardCount //abstract in CardGameViewController, but we implement it here.
{
   return 12;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [self.game cardCount];
}

-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card //abstract in CardGameViewController, but we implement it here.
{
   if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
      SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
      if ([card isKindOfClass:[SetCard class]]) {
         SetCard *setCard = (SetCard *)card;
         setCardView.color = setCard.color;
         setCardView.symbol = setCard.symbol;
         setCardView.shading = setCard.shading;
         setCardView.number = setCard.number;
         setCardView.faceUp = setCard.isFaceUp;
         setCardView.alpha = setCard.isUnplayable ? 0.1 : 1.0;
      }
   }
}

-(void)updateUI
{
   //[super updateUI]; // Does this block:
   //HW3#5 remove these cards from the display.
   //Remove the unplayable cards.
   NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
   NSMutableArray *cardsToDelete = [[NSMutableArray alloc] init];
   NSIndexPath *indexPath; //Move the declaration out of the loop to expand its scope.
   for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
      indexPath = [self.cardCollectionView indexPathForCell:cell];
      Card *card = [self.game cardAtIndex:indexPath.item];
      //SetCard *setCard = (SetCard *)card;
      if (card.isFaceUp /*&& !setCard.isUnplayable*/) {
         [indexPathsToDelete insertObject:indexPath atIndex:[indexPathsToDelete count]];
         //[self.game deleteCard:card];
         [cardsToDelete insertObject:card  atIndex:[cardsToDelete count]];
      }
   }
   NSLog(@"indexPathsToDelete count is: %d",[indexPathsToDelete count]);
   if ([indexPathsToDelete count] == 3) {
      [self.game deleteCards:cardsToDelete];
      //[self.cardCollectionView reloadData];
      [self.cardCollectionView deleteItemsAtIndexPaths:indexPathsToDelete];
   }
   for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
      NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
      Card *card = [self.game cardAtIndex:indexPath.item];
      if ([card isKindOfClass:[SetCard class]]) {
         SetCard *setCard = (SetCard *)card;
         [self updateCell:cell usingCard:card];
         if (setCard.isFaceUp && !setCard.isUnplayable) {
            cell.backgroundColor = [UIColor grayColor];
            [cell setHighlighted:YES];
         } else cell.backgroundColor = nil;
      }
   }
}
@end
