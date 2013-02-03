//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Nenad Kovačević on 26/01/2013.
//  Copyright (c) 2013 Nenad Kovačević. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchControl;
@property (nonatomic) NSUInteger matchMode;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateDisabled|UIControlStateSelected];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.unplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        // wasn't sure how to implement task 7 in two lines of code but this did the trick
        if (!cardButton.isSelected) [cardButton setImage:[UIImage imageNamed:@"cardback.png"] forState:UIControlStateNormal];
        else [cardButton setImage:nil forState:UIControlStateNormal];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = self.game.result;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    if (flipCount) {
        self.matchControl.enabled = NO;
    }
    else self.matchControl.enabled = YES;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] forMatchingMode:self.matchMode];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)deal
{
    self.game = nil;
    self.flipCount = 0;
    self.matchControl.selectedSegmentIndex = TWO_CARDS_MATCHING_GAME;
    [self updateUI];
}
- (IBAction)changeMatchMode:(UISegmentedControl *)sender
{
    self.matchMode = sender.selectedSegmentIndex;
}

@end
