//
//  LandscapeManager.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import Foundation
/*
 Class untuk memanggil LandscapeManager yang mengatur life-cycle app ketika launching
*/
class LandscapeManager{
    static let shared = LandscapeManager()
    var isFirstLaunch: Bool{
        get{
            !UserDefaults.standard.bool(forKey: #function)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
