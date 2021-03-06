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
   if (!_game) {
      SetCardDeck *deck = (SetCardDeck *)[self createDeck];
      _game = [[SetGame alloc] initWithCardCount:self.startingCardCount
                                       usingDeck:deck];
      _game.deck = deck;
   }
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
         //Add following section to try to get rid of remmant highlighting of cells.
         if (setCard.isFaceUp && !setCard.isUnplayable) {
            cell.backgroundColor = [UIColor grayColor];
            [cell setHighlighted:YES];
         } else {
            cell.backgroundColor = nil;
            [cell setHighlighted:NO];
         }
      }
   }
}

-(void)updateUI
{
   //Cards are now deleted in SetGame. If they are deleted, in the above code, card should be nil, I think. Try taking advantage
   //of that to be able to use deleteItemsAtIndexPaths for animation. Should be able to do this if three cards are nil.
   NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
   NSUInteger nilCount = 0;
   NSIndexPath *indexPath; //Move the declaration out of the loop to expand its scope.
   for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
      indexPath = [self.cardCollectionView indexPathForCell:cell];
      Card *card = [self.game cardAtIndex:indexPath.item];
      if (!card) {
         nilCount++;
         [indexPathsToDelete insertObject:indexPath atIndex:[indexPathsToDelete count]];
      }
   }
   if (nilCount==3) {
      [self.cardCollectionView deleteItemsAtIndexPaths:indexPathsToDelete];
   } else {
      [self.cardCollectionView reloadData];
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
- (IBAction)deal:(UIButton *)sender {
   //User has touched the deal button. Clean up and deal a new deck of cards.
   NSUInteger cardsInPlay = [self.game cardCount];
   NSUInteger cardsInDeck = [self.game.deck cardCount];
   if (cardsInDeck >=3 && cardsInPlay >0) {
      // Deal 3 more cards
      [self.game dealThreeMore];
      [self.cardCollectionView reloadData];
      [self updateUI];
   } else {
      [super deal:sender];
   }
   [self updateUI];
}

@end
