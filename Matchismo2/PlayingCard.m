//
//  PlayingCard.m
//  Matchismo
//
//  Created by Victor Engel on 1/31/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
   int score=0;
   float ranksAvailable = [PlayingCard maxRank];
   float suitsAvailable = [[PlayingCard validSuits] count];
   float totalCards = ranksAvailable * suitsAvailable - 1;
   ranksAvailable --;
   suitsAvailable --;
   if ([otherCards count]) {
      for (int i=0; i<[otherCards count]; i++) {
         PlayingCard *otherCard = otherCards[i];
         if ([otherCard.suit isEqualToString:self.suit]) {
            score += floor(totalCards/ranksAvailable+0.5);
            ranksAvailable -= 1.0;
         } else if (otherCard.rank == self.rank) {
            score += floor(totalCards/suitsAvailable+0.5);
            suitsAvailable -= 1.0;
         }
      }
   }
   return score;
}
-(NSString *)contents
{
   return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+(NSArray *)validSuits
{
   static NSArray *validSuits = nil;
   if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
   return validSuits;
}
-(void)setSuit:(NSString *)suit
{
   if ([[PlayingCard validSuits] containsObject:suit]) {
      _suit = suit;
   }
}
-(NSString *)suit
{
   return _suit ? _suit : @"?";
}
+(NSArray *)rankStrings
{
   return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+(NSUInteger)maxRank {return [self rankStrings].count-1; }
-(void)setRank:(NSUInteger)rank
{
   if (rank <= [PlayingCard maxRank]) {
      _rank = rank;
   }
}

@end
