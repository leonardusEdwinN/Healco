//
//  FeelToEatCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 25/06/21.
//

import UIKit

class FeelToEatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewFeel: UIView!
    @IBOutlet weak var labelFeel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewFeel.layer.cornerRadius = 15
        viewFeel.layer.masksToBounds = true
        // Initialization code
    }
    
    func setUI(feel : String){
        labelFeel.text = feel
    }
    
    func changeUpdate(){
        if(isSelected){
            self.viewFeel.backgroundColor = UIColor(red: 0.38, green: 0.58, blue: 0.29, alpha: 1.00)
        }else{
            self.viewFeel.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00)
        }
    }

}
