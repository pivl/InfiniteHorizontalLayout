//
//  InfiniteHorizontalLayout.h
//  collectionview
//
//  Created by Pavel Stasyuk on 24.06.14.
//  Copyright (c) 2014 fort1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteHorizontalLayout : UICollectionViewFlowLayout

- (CGPoint)preferredContentOffsetForElementAtIndex:(NSInteger)index;

// should be called from scrollViewDidScroll
- (void)recenterLayoutIfNeeded;

@end
