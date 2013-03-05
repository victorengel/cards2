//
//  Card.m
//  Matchismo
//
//  Created by Victor Engel on 1/31/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize faceUp = _faceUp;
@synthesize unplayable = _unplayable;

-(int)match:(NSArray *)otherCards
{
   int score = 0;
   
   for (Card *card in otherCards) {
      if ([card.contents isEqualToString:self.contents]) {
         score = 1;
      }
   }
   return score;
}
-(NSString *)description
{
   return self.contents;
}
@end
