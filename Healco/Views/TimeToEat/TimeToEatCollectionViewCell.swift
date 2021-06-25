//
//  TimeToEatCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 25/06/21.
//

import UIKit

class TimeToEatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelTimeToEat: UILabel!
    @IBOutlet weak var viewTimeToEat: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTimeToEat.layer.cornerRadius = 15
        viewTimeToEat.layer.masksToBounds = true
        
        // Initialization code
    }
    
    func setUI(timeToEat : String){
        self.labelTimeToEat.text = timeToEat
    }
    
    func changeUpdate(){
        if(isSelected){
            self.viewTimeToEat.backgroundColor = UIColor(red: 0.38, green: 0.58, blue: 0.29, alpha: 1.00)
            self.labelTimeToEat.textColor = .white
        }else{
            self.viewTimeToEat.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00)
            self.labelTimeToEat.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.00)
            
        }
    }

}
