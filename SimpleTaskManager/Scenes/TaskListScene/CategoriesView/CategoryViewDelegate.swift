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
  
  init(categories: [Category], editable: Bool) {
    let c: Category = CoreDataStore.sharedInstance.create()
    c.color = UIColor.red
    c.name = "project"
    
    let c2: Category = CoreDataStore.sharedInstance.create()
    c2.color = UIColor.orange
    c2.name = "personal"

    self.categories = [c, c2]
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
  
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewDelegate: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let text = categories[indexPath.row].name! as NSString
    let size = text.size(withAttributes: [.font: Styles.systemFont])
    return CGSize(width: size.width + 15, height: size.height + 3)
  }
}
