//
//  WeeklyCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 17/06/21.
//

import UIKit

protocol WeeklyCollectionViewCellProtocol {
    func reloadCell()
}

class WeeklyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
//    var selectedCell: Bool = false {
//        didSet{
//            self.changeUpdate()
//        }
//    }
    
//    var delegate : WeeklyCollectionViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(dateText : String){
        self.labelDate.text = dateText
        imageIcon.image = UIImage(systemName: "heart")
    }
    
    func changeUpdate(){
//        print("CELL : \(selectedCell) :: isselected \(isSelected)")
        if(isSelected){
            imageIcon.image = UIImage(systemName: "heart.fill")
        }else{
            imageIcon.image = UIImage(systemName: "heart")
        }
        
//        delegate?.reloadCell()
    }
    

}
