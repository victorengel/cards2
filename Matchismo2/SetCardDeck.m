//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck
-(id)init
{
   self = [super init];
   if (self) {
      for (NSString *number in [SetCard validNumbers]) {
         for (NSString *symbol in [SetCard validSymbols]) {
            for (NSString *shading in [SetCard validShadings]) {
               for (NSString *color in [SetCard validColors]) {
                  SetCard *card = [[SetCard alloc] init];
                  card.number = number;
                  card.symbol = symbol;
                  card.shading = shading;
                  card.color = color;
                  [self addCard:card atTop:YES];
                  //NSLog(@"Adding card %@",card.contents);
               }
            }
         }
      }
   }
   return self;
}

@end
