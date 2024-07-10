//
//  SelectionCell.swift
//  WrapKit
//
//  Created by Daniiar Erkinov on 3/7/24.
//

#if canImport(UIKit)
import UIKit

public class SelectionCell: TableViewCell<SelectionCellContentView> {
    public var model: SelectionType.SelectionCellPresentableModel? {
        didSet {
            guard let model = model else { return }
            mainContentView.titleLabel.text = model.title
            mainContentView.trailingLabel.text = model.trailingTitle
            mainContentView.trailingImageView.image = model.isSelected ? model.configuration.selectedImage : model.configuration.notSelectedImage
            
            if let color = model.circleColor, let color = UIColor(hexaRGB: color, alpha: 1) {
                mainContentView.leadingImageView.layer.cornerRadius = 10
                mainContentView.leadingImageContainerView.isHidden = false
                mainContentView.leadingImageView.backgroundColor = color
            }
            if let iconUrl = model.icon {
                mainContentView.leadingImageContainerView.isHidden = false
                mainContentView.leadingImageContainerView.backgroundColor = .clear
                mainContentView.leadingImageViewConstraints?.height?.constant = 24
                mainContentView.leadingImageViewConstraints?.width?.constant = 24
//                mainContentView.leadingImageView.kf.setImage(with: iconUrl.asUrl)
            }
            
            mainContentView.lineView.backgroundColor = model.configuration.lineColor
            mainContentView.titleLabel.textColor = model.configuration.titleColor
            mainContentView.trailingLabel.textColor = model.configuration.trailingColor
            mainContentView.titleLabel.font = model.configuration.titleFont
            mainContentView.trailingLabel.font = model.configuration.trailingFont
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        mainContentView.trailingImageView.image = nil
        mainContentView.leadingImageView.image = nil
    }
}
#endif