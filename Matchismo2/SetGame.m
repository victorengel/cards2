//
//  SetGame.m
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//
// New code to modify, copied from CardMatchingGame

#import "SetGame.h"

@interface SetGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *otherCards;
@property (readwrite, nonatomic) int score;
@property (nonatomic, readwrite) NSString *flipResult;
@end

@implementation SetGame

-(NSMutableArray *)cards
{
   if (!_cards) _cards = [[NSMutableArray alloc] init];
   return _cards;
}
-(NSUInteger)cardCount
{
   return [self.cards count];
}
-(NSMutableArray *)otherCards
{
   if (!_otherCards) _otherCards = [[NSMutableArray alloc] init];
   return _otherCards;
}

-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
   self = [super init];
   if (self) {
      for (int i=0; i<cardCount; i++) {
         Card *card = [deck drawRandomCard];
         if (!card) {
            self = nil; //This can happen if there are not enough cards in the deck.
            break;
         } else {
            self.cards[i] = card;
         }
      }
   }
   self.gameMode = 3;
   return self;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
   return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index gameMode:(NSUInteger)gameMode
{
   //gameMode indicates number of cards to match.
   Card *card = [self cardAtIndex:index];
   BOOL cardIsPlayable = !card.isUnplayable;
   //The card is already face up, so it just needs to be turned back over.
   if (card.faceUp && cardIsPlayable) {
      self.flipResult = [NSString stringWithFormat:@"%@ flipped",card.contents];
      card.faceUp = !card.faceUp;
      [self.otherCards removeObjectIdenticalTo:card];
   } else {
      if (cardIsPlayable) {
         self.flipResult = [NSString stringWithFormat:@"%@ flipped",card.contents];
         //The card is face down, so it needs to be turned face up.
         card.faceUp = YES;
         //If turning over the new card results in gameMode cards turned up, evaluate the match.
         int totalCards = 1 + [self.otherCards count];
         if (totalCards == gameMode) {
            int matchScore = [card match:self.otherCards];
            if (matchScore == 4) {
               //If there is a score, make cards unplayable.
               self.flipResult = card.contents;
               for (Card *otherCard in self.otherCards) {
                  self.flipResult = [self.flipResult stringByAppendingString:[NSString stringWithFormat:@",%@",otherCard.contents]];
               }
               self.flipResult = [self.flipResult stringByAppendingString:[NSString stringWithFormat:@" matched: %d",matchScore]];
               card.Unplayable = YES;
               card.faceUp = YES;
               for (Card *otherCard in self.otherCards) {
                  otherCard.faceUp = YES;
                  otherCard.unplayable = YES;
               }
               [self.otherCards removeAllObjects];
               self.score += 1;
            } else {
               self.flipResult = @"No match - flip oldest card";
               //There was no score. Assess a penalty and turn oldest card over.
               //If the result of the match is 0, then turn the oldest card face down.
               Card *oldestCard = self.otherCards[0];
               oldestCard.faceUp = NO;
               [self.otherCards removeObjectAtIndex:0];
               //Now add the current card to the otherCards array.
               [self.otherCards addObject:card];
               self.score -= 1;
            }
         } else {
            [self.otherCards addObject:card];
         }
      }
   }
}
@end


