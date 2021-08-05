//
//  ProfileCell.swift
//  Profile
//
//  Created by Rian on 03/08/21.
//

import Foundation
import UIKit

class SettingsProfileTableViewCell: UITableViewCell {
    static let identifier = "SettingsProfileTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let textField: UITextField = {
        let field = UITextField()
        field.text = nil
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(textField)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 25 , y: 0, width: contentView.frame.size.width * 1/3, height: contentView.frame.size.height)
        textField.frame = CGRect(x: label.frame.width + 25, y: 0, width: contentView.frame.size.width * 2/3 - 25, height: contentView.frame.size.height)
        textField.isUserInteractionEnabled = isEdited
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        textField.text = nil
    }
    
    var isEdited: Bool = false
    
    @objc func performGenderPicker(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showPickerController"), object: nil)
    }
    
    public func configure(with model: MapingDataProfile) {
        let index = model.index
        if index == 0 {
            textField.addTarget(self, action: #selector(performGenderPicker), for: .touchDown)
        }
        isEdited = model.isEdited
        label.text = model.name
        textField.text = model.value
        textField.tag = index
    }
}

