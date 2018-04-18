//
//  UIView+Animation.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

extension UIView {
  func startShakeAnimation() {
    transform = CGAffineTransform(translationX: 20, y: 0);
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
      self.transform = .identity
    })
  }
}
