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
            self.viewFeel.backgroundColor = UIColor(named: "AvocadoGreen")
            self.labelFeel.textColor = .white
        }else{
            self.viewFeel.backgroundColor = UIColor(named: "MangoYoghurt")
            self.labelFeel.textColor = UIColor(named: "StateUnactiveText")
            
        }
    }

}
