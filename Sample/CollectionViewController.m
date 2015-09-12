//
//  CollectionViewController.m
//  Sample
//
//  Created by Pavel Stasyuk on 03/09/14.
//  Copyright (c) 2014 PS. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "InfiniteHorizontalLayout.h"

const NSInteger kNumberOfItems = 10;

@interface CollectionViewController () <UICollectionViewDataSource>

@end

@implementation CollectionViewController

static NSString *cellIdentifier = @"collectionCell";

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kNumberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.label.text = @(indexPath.row).description;
    
    NSInteger n = indexPath.row % 2;
    cell.contentView.backgroundColor = n ? [UIColor blueColor] : [UIColor greenColor];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.collectionViewLayout isKindOfClass:[InfiniteHorizontalLayout class]]) {
        InfiniteHorizontalLayout *layout = (InfiniteHorizontalLayout *)self.collectionViewLayout;
        [layout recenterLayoutIfNeeded];
    }
}

@end
