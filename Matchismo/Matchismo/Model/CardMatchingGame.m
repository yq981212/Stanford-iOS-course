//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nenad Kovačević on 30/01/2013.
//  Copyright (c) 2013 Nenad Kovačević. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (readwrite, strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

// if no cards were flipped, result reads No cards were flipped
// model is the brain behind our application, and it knows about the flipped cards
// so it should contain this property, and not the controller
- (NSString *)result
{
    if (!_result) {
        _result = @"No cards were flipped";
    }
    return _result;
}

//lazy instantiation
- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS         4
#define MISMATCH_PENALTY    2
#define FLIP_COST           1

- (void)flipCardAtIndex:(NSUInteger)index forMatchingMode:(NSUInteger)mode
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *faceUpAndPlayableCards = [[NSMutableArray alloc] init]; // self explanatory
    
    if (card && !card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            // as soon as a card is flipped, we describe what happened
            self.result = [NSString stringWithFormat:@"Flipped %@", card.contents];
            
            //looping through other cards looking for another face up, playable ones
            for (Card *otherCard in self.cards)
            {
                // when found, they are added to the appropriate array
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [faceUpAndPlayableCards addObject:otherCard];
                }
                
                // checking to see if number of face up and playable cards correspond to 2 or 3-cards matching game
                // for 2-cards matching game there should be 1 card
                // for 3-cards matching game there should be 2 cards
                // mode is defined in the header file as a index of segmented control
                if ([faceUpAndPlayableCards count] == mode + 1)
                {
                    // if there are any face up and playable cards, we match them to the last flipped card
                    if ([faceUpAndPlayableCards count]) {
                        int matchScore = [card match:faceUpAndPlayableCards];
                        if (matchScore)
                        {
                            card.unplayable = YES;
                            for (Card *flippedCard in faceUpAndPlayableCards) {
                                flippedCard.unplayable = YES;
                            }
                            self.score += matchScore * MATCH_BONUS;
                            
                            // complete description of flipped cards
                            NSString *flippedCards = [card.contents stringByAppendingString:[self formResultFromFlippedCards:faceUpAndPlayableCards]];
                            self.result = [NSString stringWithFormat:@"Matched %@ for %d points", flippedCards, matchScore * MATCH_BONUS];
                        }
                        else
                        {
                            for (Card *flippedCard in faceUpAndPlayableCards) {
                                flippedCard.unplayable = NO;
                                flippedCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            
                            // complete description of flipped cards
                            NSString *flippedCards = [card.contents stringByAppendingString:[self formResultFromFlippedCards:faceUpAndPlayableCards]];
                            self.result = [NSString stringWithFormat:@"%@ don't match, %d points penalty", flippedCards, MISMATCH_PENALTY];
                        }
                        break;
                    }
                }
                // continue flipping cards until there is an apprpriate number of face up and playing cards depending on the match mode
                else continue;
            }
            self.score -= FLIP_COST;
        }
        //flip the card
        card.faceUp = !card.isFaceUp;
    }
}

// creating a string which describes played cards
- (NSString *)formResultFromFlippedCards:(NSArray *)cards
{
    NSString *result = @"";
    for (Card *card in cards) {
        if (card == [cards lastObject]) {
            result = [result stringByAppendingFormat:@"& %@", card.contents];
        }
        else result = [result stringByAppendingFormat:@", %@", card.contents];
    }
    return result;
}

//designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

@end
