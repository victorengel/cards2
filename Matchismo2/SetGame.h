//
//  SetGame.h
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCardDeck.h"

@interface SetGame : CardMatchingGame
@property (strong, nonatomic) SetCardDeck *deck;

-(NSUInteger)cardCount;
-(void)dealThreeMore;
@end
