//
//  customFlowLayout.swift
//  GridRace
//
//  Created by Christian on 3/9/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class customFlowLayout: UICollectionViewFlowLayout {

    init(collectionViewWidth: CGFloat, collectionViewHeigth: CGFloat) {
        super.init()
        let cellSpacing = collectionViewWidth * 0.1
        sectionInset = UIEdgeInsets(top: 10, left: (cellSpacing * 2), bottom: 10, right: (cellSpacing * 2))
        scrollDirection = .horizontal
        minimumInteritemSpacing = cellSpacing;
        minimumLineSpacing = cellSpacing
        itemSize = CGSize(width: collectionViewWidth * 0.6, height: collectionViewHeigth * 0.8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let previousPage = collectionView!.contentOffset.x / pageWidth()
        let currentPage = velocity.x > 0.0 ? floor(previousPage) : ceil(previousPage)
        let nextPage = velocity.x > 0.0 ? ceil(previousPage) : floor(previousPage)

        var proposedOffset = CGPoint(x: 0, y:0)
        let pannedLessThanAPage = fabs(1 + currentPage - previousPage) > 0.5
        let flicked = fabs(velocity.x) > 0.3

        if pannedLessThanAPage && flicked {
            proposedOffset.x = nextPage * pageWidth()
        } else {
            proposedOffset.x = round(previousPage) * pageWidth()
        }

        return proposedOffset
    }

    // page is 
    func pageWidth() -> CGFloat {
        return itemSize.width + minimumLineSpacing
    }

}
