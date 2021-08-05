//
//  NutritionCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 02/08/21.
//

import UIKit

class NutritionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewNutrition: UIView!
    @IBOutlet weak var labelPersen: UILabel!
    @IBOutlet weak var labelJenisNutrisi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        viewNutrition.layer.cornerRadius = 15
//        viewNutrition.layer.masksToBounds = true
//        viewNutrition.dropShadow()
        
        viewNutrition.layer.cornerRadius = 15
        viewNutrition.layer.borderWidth = 1.0
        viewNutrition.layer.borderColor = UIColor.black.cgColor
        viewNutrition.layer.masksToBounds = true

        viewNutrition.layer.shadowColor = UIColor.black.cgColor
        viewNutrition.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        viewNutrition.layer.shadowRadius = 0.1
        viewNutrition.layer.shadowOpacity = 0.2
        viewNutrition.layer.masksToBounds = false
        viewNutrition.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        

    }
    
    func setUI(presentase : String, jenisNutrisi : String){
        self.labelPersen.text = presentase
        self.labelJenisNutrisi.text = jenisNutrisi
    }
}
