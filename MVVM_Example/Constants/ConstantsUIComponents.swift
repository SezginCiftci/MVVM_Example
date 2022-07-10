//
//  ConstantsUIComponents.swift
//  MVVM_Example
//
//  Created by Sezgin on 9.04.2022.
//

import UIKit

class MakeProperty {
    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .secondarySystemBackground
        label.backgroundColor = .clear
        return label
    }
    static func makeStarImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .secondarySystemBackground
        iv.image = UIImage(named: "star")
        return iv
    }
}

class MakeAlert {
    static func makeAlertView(_ title: String, _ message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
}
