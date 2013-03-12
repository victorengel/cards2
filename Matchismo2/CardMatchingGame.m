//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Victor Engel on 2/1/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *otherCards;
@property (readwrite, nonatomic) int score;
@property (nonatomic, readwrite) NSString *flipResult;
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards
{
   if (!_cards) _cards = [[NSMutableArray alloc] init];
   return _cards;
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
      for (int i=0; i<=cardCount; i++) {
         Card *card = [deck drawRandomCard];
         if (!card) {
            self = nil; //This can happen if there are not enough cards in the deck.
            break;
         } else {
            self.cards[i] = card;
         }
      }
   }
   self.gameMode = 2;
   return self;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
   NSLog(@"CardMatchingGame-cardAtIndex %d",index);
   NSLog(@"%d cards in self.cards",[self.cards count]);
   return (index < [self.cards count]) ? self.cards[index] : nil;
}
-(void)deleteCards:(NSMutableArray *)cardsToDelete
{
   for (Card *card in cardsToDelete) {
      if (card) [self.cards removeObject:card];
   }
}
#define MATCH_BONUS 4
#define MATCH_PENALTY -2
#define FLIP_COST -1

-(void)flipCardAtIndex:(NSUInteger)index gameMode:(NSUInteger)gameMode
{
//gameMode indicates number of cards to match.
   Card *card = [self cardAtIndex:index];
   BOOL cardIsPlayable = !card.isUnplayable;
   //The card is already face up, so it just needs to be turned back over.
   if (card.faceUp && cardIsPlayable) {
      self.flipResult = [NSString stringWithFormat:@"%@ flipped",card.contents];
      self.score += FLIP_COST;
      card.faceUp = !card.faceUp;
      [self.otherCards removeObjectIdenticalTo:card];
   } else {
      if (cardIsPlayable) {
         self.flipResult = [NSString stringWithFormat:@"%@ flipped",card.contents];
         self.score += FLIP_COST;
         //The card is face down, so it needs to be turned face up.
         card.faceUp = YES;
         //If turning over the new card results in gameMode cards turned up, evaluate the match.
         int totalCards = 1 + [self.otherCards count];
         if (totalCards == gameMode) {
            int matchScore = [card match:self.otherCards];
            if (matchScore) {
               //If there is a score, make cards unplayable.
               self.flipResult = card.contents;
               for (Card *otherCard in self.otherCards) {
                  self.flipResult = [self.flipResult stringByAppendingString:[NSString stringWithFormat:@",%@",otherCard.contents]];
               }
               self.flipResult = [self.flipResult stringByAppendingString:[NSString stringWithFormat:@" matched: %d",matchScore]];
               NSLog(@"Flip result is %@",self.flipResult);
               card.Unplayable = YES;
               card.faceUp = YES;
               for (Card *otherCard in self.otherCards) {
                  otherCard.faceUp = YES;
                  otherCard.unplayable = YES;
               }
               [self.otherCards removeAllObjects];
            } else {
               self.flipResult = @"No match - flip oldest card";
               //There was no score. Assess a penalty and turn oldest card over.
               //If the result of the match is 0, then turn the oldest card face down.
               Card *oldestCard = self.otherCards[0];
               oldestCard.faceUp = NO;
               [self.otherCards removeObjectAtIndex:0];
               //Now add the current card to the otherCards array.
               [self.otherCards addObject:card];
               matchScore = MATCH_PENALTY;
            }
            self.score += matchScore;
         } else {
            [self.otherCards addObject:card];
         }
      }
   }
}
@end


