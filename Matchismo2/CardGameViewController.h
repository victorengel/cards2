//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Victor Engel on 1/31/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

-(Deck *)createDeck; //abstract
@property (nonatomic) NSUInteger startingCardCount; //abstract
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
-(void)updateUI;
- (IBAction)deal:(UIButton *)sender;

@end
