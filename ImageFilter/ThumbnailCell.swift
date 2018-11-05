//
//  ThumbnailCell.swift
//  ImageFilter
//
//  Created by Keisuke Matsuo on 2018/08/15.
//  Copyright © 2018 Keisuke Matsuo. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
}
