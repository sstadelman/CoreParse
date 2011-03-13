//
//  Grammar.h
//  CoreParse
//
//  Created by Tom Davie on 13/02/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPNonTerminal.h"
#import "CPRule.h"

@interface CPGrammar : NSObject
{}

@property (readwrite,retain) CPNonTerminal *start;

+ (id)grammarWithStart:(NSString *)start rules:(NSArray *)rules;
- (id)initWithStart:(NSString *)start rules:(NSArray *)rules;

+ (id)grammarWithStart:(NSString *)start bnf:(NSString *)bnf;
- (id)initWithStart:(NSString *)start bnf:(NSString *)bnf;

- (NSSet *)allRules;
- (NSArray *)allNonTerminalNames;

- (void)addRule:(CPRule *)rule;
- (NSArray *)rulesForNonTerminal:(CPNonTerminal *)nonTerminal;

- (CPGrammar *)augmentedGrammar;

- (NSUInteger)indexOfRule:(CPRule *)rule;

- (NSSet *)follow:(NSString *)name;
- (NSSet *)first:(NSArray *)obj;

@end