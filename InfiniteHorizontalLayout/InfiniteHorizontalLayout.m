//
//  InfiniteHorizontalLayout.m
//  collectionview
//
//  Created by Pavel Stasyuk on 24.06.14.
//  Copyright (c) 2014 fort1. All rights reserved.
//

#import "InfiniteHorizontalLayout.h"

#define MIN_NUMBER_OF_ITEMS_REQUIRED 6

@implementation InfiniteHorizontalLayout {
    CGSize _collectionViewOriginalSize;
    BOOL _used;
}

#pragma mark - Public

- (CGPoint)preferredContentOffsetForElementAtIndex:(NSInteger)index
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) {
        return CGPointMake(0, 0);
    }
    NSAssert((index >= 0) && (index < [self.collectionView numberOfItemsInSection:0]), @"preferredContentOffsetForElementAtIndex: index must be in range");
    CGFloat value = (self.itemSize.width + self.minimumLineSpacing) * index;
    if (_used) {
        value += trunc(self.itemSize.width / 2) * _collectionViewOriginalSize.width;
    }
    
    return CGPointMake(value - self.collectionView.contentInset.left, self.collectionView.contentOffset.y);
}

- (void)recenterLayoutIfNeeded
{
    if (_used) {
        CGFloat page = self.collectionView.contentOffset.x / _collectionViewOriginalSize.width;
        CGFloat residue = (self.collectionView.contentOffset.x - trunc(page) * _collectionViewOriginalSize.width) / _collectionViewOriginalSize.width;
        
        if (residue >= 0. && residue <= 0.0002 && page >= self.itemSize.width / 2 + 40) {
            self.collectionView.contentOffset = [self preferredContentOffsetForElementAtIndex:0];
        }
        if (page < 1.) {
            self.collectionView.contentOffset = [self preferredContentOffsetForElementAtIndex:0];
        }
    }
}

#pragma mark - Overriden

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    NSAssert(self.collectionView.numberOfSections <= 1, @"You cannot use InfiniteLayout with more than 2 sections");
    
    _used = [self.collectionView numberOfItemsInSection:0] >= MIN_NUMBER_OF_ITEMS_REQUIRED;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.minimumLineSpacing);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [super prepareLayout];
    _collectionViewOriginalSize = [super collectionViewContentSize];
}

- (CGSize)collectionViewContentSize
{
    CGSize size;
    
    if (_used) {
        size = CGSizeMake(_collectionViewOriginalSize.width * self.itemSize.width, _collectionViewOriginalSize.height);
    }
    else {
        size = _collectionViewOriginalSize;
    }
    
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (_used == NO) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    
    CGFloat position = rect.origin.x / _collectionViewOriginalSize.width;
    CGFloat rectPosition = position - trunc(position);
    CGRect modifiedRect = CGRectMake(rectPosition * _collectionViewOriginalSize.width, rect.origin.y, rect.size.width, rect.size.height);
    CGRect secondRect = CGRectZero;
    if (CGRectGetMaxX(modifiedRect) > _collectionViewOriginalSize.width) {
        secondRect = CGRectMake(0, rect.origin.y, CGRectGetMaxX(modifiedRect) - _collectionViewOriginalSize.width, rect.size.height);
        modifiedRect.size.width = _collectionViewOriginalSize.width - modifiedRect.origin.x;
    }
    
    NSArray *attributes = [self newAttributesForRect:modifiedRect offset:trunc(position) * _collectionViewOriginalSize.width];
    NSArray *attributes2 = [self newAttributesForRect:secondRect offset:(trunc(position)+ 1) * _collectionViewOriginalSize.width];
    
    NSArray *result = [attributes arrayByAddingObjectsFromArray:attributes2];
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

#pragma mark - Hidden

- (NSArray *)newAttributesForRect:(CGRect)rect offset:(CGFloat)offset
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    return [self modifyLayoutAttributes:attributes offset:offset];
}

- (NSArray *)modifyLayoutAttributes:(NSArray *)attributes offset:(CGFloat)offset
{
    NSMutableArray *result = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        UICollectionViewLayoutAttributes *newAttr = [attr copy];
        newAttr.center = CGPointMake(attr.center.x + offset, attr.center.y);
        [result addObject:newAttr];
    }
    
    return result;
}

@end
