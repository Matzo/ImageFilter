//
//  ViewController.swift
//  ImageFilter
//
//  Created by Keisuke Matsuo on 2018/08/15.
//  Copyright © 2018 Keisuke Matsuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    var filters = ImageFilter.allCases
    var originalImage: UIImage?

    // MARK: Outlets
    @IBOutlet weak var filteredImageView: UIImageView! {
        didSet {
            filteredImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        }
    }

    @IBAction func selectImage() {
        pickImageFromLibrary()
    }

    // MARK: Initialization

    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupDefaultImage()
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Public Methods

    // MARK: Private Methods
    func setupDefaultImage() {
        if let image = UIImage(named: "sample") {
            didSelectImage(image)
        }
    }

    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }

    func didSelectImage(_ image: UIImage) {
        originalImage = image
        filteredImageView.image = image
        collectionView.reloadData()
    }

    // MARK: Class Methods

}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: { [weak self] in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self?.didSelectImage(image)
            }
        })
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath)
        if let cell = cell as? ThumbnailCell {
            cell.nameLabel.text = filters[indexPath.item].name
            if let image = originalImage {
                cell.imageView.image = filters[indexPath.item].apply(to: image)
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filters.count > indexPath.item {
            if let image = originalImage {
                filteredImageView.image = filters[indexPath.item].apply(to: image)
            }
        }
    }
}
