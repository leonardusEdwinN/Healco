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

    @IBOutlet weak var labelHari: UILabel!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var labelTanggal: UILabel!
    
//    var selectedCell: Bool = false {
//        didSet{
//            self.changeUpdate()
//        }
//    }
    
//    var delegate : WeeklyCollectionViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTanggal.layer.cornerRadius = labelTanggal.frame.size.width / 2
        labelTanggal.layer.masksToBounds = true
        
        viewOuter.layer.cornerRadius = 10
        viewOuter.layer.masksToBounds = true
        // Initialization code
    }
    
    func setUI(dateText : String, dayString : String){
        //dayString untuk hari, dateText untuk tanggal
        self.labelHari.text = dayString
        self.labelTanggal.text = dateText
    }
    
    func changeUpdate(){
        print("CELL :: isselected \(isSelected)")
        if(isSelected){
            viewOuter.backgroundColor = .green
        }else{
            viewOuter.backgroundColor = .white
        }
//        if(status == "Healthy"){
//            imageIcon.image = UIImage(systemName: "heart.fill")
//            imageIcon.tintColor = .red
//        }else if (status == "Unhealthy"){
//            imageIcon.image = UIImage(systemName: "hand.thumbsdown.fill")
//            imageIcon.tintColor = .red
//        }else{
//            imageIcon.image = UIImage(systemName: "circle.fill")
//            imageIcon.tintColor = .secondaryLabel
//        }
        
//        delegate?.reloadCell()
    }
    

}
