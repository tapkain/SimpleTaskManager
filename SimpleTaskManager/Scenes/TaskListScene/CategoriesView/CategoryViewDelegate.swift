//
//  CategoryView.swift
//  SimpleTaskManager
//
//  Created by Yevhen Velizhenkov on 4/16/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit

class CategoryViewDelegate: NSObject {
  let categories: [Category]
  var userInteractionEnabled = false
  
  init(categories: [Category], userInteractionEnabled: Bool) {
    self.categories = categories
    self.userInteractionEnabled = userInteractionEnabled
  }
}


// MARK: - UICollectionViewDataSource
extension CategoryViewDelegate: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
    let category = categories[indexPath.row]
    cell.category.text = category.name
    cell.category.backgroundColor = category.color as? UIColor
    return cell
  }
}


// MARK: - UICollectionViewDelegate
extension CategoryViewDelegate: UICollectionViewDelegate {  
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewDelegate: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let text = categories[indexPath.row].name! as NSString
    let size = text.size(withAttributes: [.font: Styles.systemFont])
    return CGSize(width: size.width + 15, height: size.height + 3)
  }
}
