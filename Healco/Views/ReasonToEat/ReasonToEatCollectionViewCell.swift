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
    
    func changeUpdate(){
        if(isSelected){
            self.viewReasonToEat.backgroundColor = UIColor(red: 0.38, green: 0.58, blue: 0.29, alpha: 1.00)
            self.labelReasonToEat.textColor = .white
        }else{
            self.viewReasonToEat.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00)
            self.labelReasonToEat.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.00)
            
        }
    }

}
