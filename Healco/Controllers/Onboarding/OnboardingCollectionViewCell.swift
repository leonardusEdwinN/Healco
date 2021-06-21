//
//  OnboardingCollectionViewCell.swift
//  Healco
//
//  Created by Fahmi Dzulqarnain on 17/06/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descr: UILabel!
    
    func setup(_ slide: OnboardingSlide) {
        image?.image = slide.image
        title?.text = slide.title
        descr?.text = slide.description
    }
}
