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
    NSMutableArray *faceUpAndPlayableCards = [[NSMutableArray alloc] init];
    
    if (card && !card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            self.result = [NSString stringWithFormat:@"Flipped %@", card.contents];
            //if the card was not face up we should check whether flipping this card creates the match
            //looping through other cards looking for another face up, playable one
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [faceUpAndPlayableCards addObject:otherCard];
                }
                if ([faceUpAndPlayableCards count] == mode + 1)
                {
                    if ([faceUpAndPlayableCards count]) {
                        //when found, we check to see if it matches
                        int matchScore = [card match:faceUpAndPlayableCards];
                        if (matchScore)
                        {
                            card.unplayable = YES;
                            for (Card *flippedCard in faceUpAndPlayableCards) {
                                flippedCard.unplayable = YES;
                            }
                            self.score += matchScore * MATCH_BONUS;
                            if (mode == TWO_CARDS_MATCHING_GAME) {
                                self.result = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card.contents, [[faceUpAndPlayableCards lastObject] contents], matchScore * MATCH_BONUS];
                            }
                            else self.result = [NSString stringWithFormat:@"Matched %@, %@ & %@ for %d points", card.contents, [faceUpAndPlayableCards[0] contents], [faceUpAndPlayableCards[1] contents], matchScore * MATCH_BONUS];
                        
                        }
                        else
                        {
                            for (Card *flippedCard in faceUpAndPlayableCards) {
                                flippedCard.unplayable = NO;
                                flippedCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            if (mode == TWO_CARDS_MATCHING_GAME) {
                                self.result = [NSString stringWithFormat:@"%@ & %@ don't match, %d points penalty", card.contents, [[faceUpAndPlayableCards lastObject] contents], MISMATCH_PENALTY];
                            }
                            else self.result = [NSString stringWithFormat:@"%@, %@ & %@ don't match, %d points penalty", card.contents, [faceUpAndPlayableCards[0] contents], [faceUpAndPlayableCards[1] contents], MISMATCH_PENALTY];
                        }
                        break;
                    }
                }
                else continue;
            }
            self.score -= FLIP_COST;
        }
        //flip the card
        card.faceUp = !card.isFaceUp;
    }
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
