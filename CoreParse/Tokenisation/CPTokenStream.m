//
//  CPTokenStream.m
//  CoreParse
//
//  Created by Tom Davie on 10/02/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "CPTokenStream.h"

@interface CPTokenStream ()

@property (readwrite,retain) NSMutableArray *tokens;
@property (readwrite,retain) NSMutableArray *rewrittenTokens;

- (void)filterTokens;

@end

@implementation CPTokenStream
{
    TokenRewriter tokenRewriter;
}

@synthesize tokens;
@synthesize rewrittenTokens;

- (TokenRewriter)tokenRewriter
{
    return tokenRewriter;
}

- (void)setTokenRewriter:(TokenRewriter)newTokenRewriter
{
    @synchronized(self)
    {
        if (tokenRewriter != newTokenRewriter)
        {
            Block_release(tokenRewriter);
            tokenRewriter = Block_copy(newTokenRewriter);
        }
    }
}

- (id)init
{
    self = [super init];
    
    if (nil != self)
    {
        self.tokens = [NSMutableArray array];
        self.rewrittenTokens = [NSMutableArray array];
        self.tokenRewriter = ^ NSArray * (CPToken *t) { return [NSArray arrayWithObject:t]; };
    }
    
    return self;
}

- (void)dealloc
{
    Block_release(tokenRewriter);
    [tokens release];
    [rewrittenTokens release];
    
    [super dealloc];
}

- (BOOL)hasToken
{
    BOOL has;
    @synchronized(self)
    {
        [self filterTokens];
        has = [rewrittenTokens count] > 0;
    }
    
    return has;
}

- (CPToken *)peekToken
{
    @synchronized(self)
    {
        [self filterTokens];
    }
    return [[[rewrittenTokens objectAtIndex:0] retain] autorelease];
}

- (CPToken *)popToken
{
    CPToken *first;
    @synchronized(self)
    {
        [self filterTokens];
        first = [[[rewrittenTokens objectAtIndex:0] retain] autorelease];
        [rewrittenTokens removeObjectAtIndex:0];
    }
    return first;
}

- (void)pushToken:(CPToken *)token
{
    @synchronized(self)
    {
        [tokens addObject:token];
    }
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    
    @synchronized(self)
    {
        [self filterTokens];
        [rewrittenTokens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             [desc appendFormat:@"%@ ", obj];
         }];
    }
    
    return desc;
}

- (void)filterTokens
{
    NSUInteger tCount = [tokens count];
    while (tCount > 0)
    {
        [rewrittenTokens addObjectsFromArray:tokenRewriter([tokens objectAtIndex:0])];
        [tokens removeObjectAtIndex:0];
        tCount--;
    }
}

- (NSArray *)peekAllRemainingTokens
{
    @synchronized(self)
    {
        [self filterTokens];
        return [[rewrittenTokens copy] autorelease];
    }
}

@end