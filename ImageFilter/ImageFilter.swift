//
//  ImageFilter.swift
//  ImageFilter
//
//  Created by Keisuke Matsuo on 2018/08/15.
//  Copyright © 2018 Keisuke Matsuo. All rights reserved.
//

import UIKit
import CoreImage

enum ImageFilter: CaseIterable {
    case original
    case goldenHour
    case aurora
    case ice

    var name: String {
        return String(describing: self)
    }

    var acvFileName: String? {
        switch self {
        case .goldenHour: return "GoldenHour.acv"
        case .aurora: return "Aurora.acv"
        case .ice: return "Ice.acv"
        default: return nil
        }
    }

    func apply(to image: UIImage) -> UIImage {
        guard let sourceImage = CIImage(image: image) else { return image }
        let filteredImage = self.applyingFilter(to: sourceImage)
        let context = CIContext(options: nil)
        guard let outputImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return image }
        return UIImage(cgImage: outputImage, scale: image.scale, orientation: image.imageOrientation)
    }

    fileprivate func applyingFilter(to sourceImage: CIImage) -> CIImage {

        guard let acvFileName = self.acvFileName else { return sourceImage }
        guard let parser = ACVParser(with: acvFileName) else { return sourceImage }

        return sourceImage
            .applyingFilter("CIColorCubeWithColorSpace", parameters: [
                "inputCubeDimension": parser.cubeDimension,
                "inputCubeData": parser.cubeData,
                "inputColorSpace": parser.colorSpace
                ])
    }
}
