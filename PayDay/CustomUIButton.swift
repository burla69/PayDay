//
//  CustomUIButton.swift
//  PayDay
//
//  Created by Oleksandr Burla on 4/6/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.layer.bounds.height / 2.0
        
        self.layer.cornerRadius = radius
        
    }
}
