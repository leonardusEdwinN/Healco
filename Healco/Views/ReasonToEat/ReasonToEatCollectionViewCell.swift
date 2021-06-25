//
//  ReasonToEatCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 25/06/21.
//

import UIKit

class ReasonToEatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelReasonToEat: UILabel!
    @IBOutlet weak var viewReasonToEat: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewReasonToEat.layer.cornerRadius = 15
        viewReasonToEat.layer.masksToBounds = true
        // Initialization code
    }
    
    func setUI(reasonToEat : String){
        labelReasonToEat.text = reasonToEat
    }

}