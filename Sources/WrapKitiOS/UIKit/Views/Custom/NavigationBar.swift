//
//  NavigationBar.swift
//  WrapKit
//
//  Created by Stas Lee on 5/8/23.
//

#if canImport(UIKit)
import UIKit

open class NavigationBar: UIView {
    public lazy var leadingStackView = StackView(axis: .horizontal, spacing: 12)
    public lazy var centerView = UIView()
    public lazy var trailingStackView = StackView(axis: .horizontal, spacing: 12, isHidden: true)
    public lazy var mainStackView = StackView(axis: .horizontal, spacing: 8)
    
    public lazy var backButton = makeBackButton(imageName: "arrow-left")
    public lazy var titleViews = VKeyValueFieldView(
        keyLabel: Label(font: .systemFont(ofSize: 18), textColor: .black, textAlignment: .center, numberOfLines: 1),
        valueLabel: Label(isHidden: true, font: .systemFont(ofSize: 14), textColor: .black, numberOfLines: 1)
    )
    public lazy var closeButton = makeBackButton(imageName: "xmark")
    
    public var mainStackViewConstraints: AnchoredConstraints?
    public var backButtonConstraints: AnchoredConstraints?
    public var closeButtonConstraints: AnchoredConstraints?
    
    private let height: CGFloat = 52
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubviews(mainStackView)
        mainStackView.addArrangedSubview(leadingStackView)
        mainStackView.addArrangedSubview(centerView)
        mainStackView.addArrangedSubview(trailingStackView)
        leadingStackView.addArrangedSubview(backButton)
        centerView.addSubview(titleViews)
        trailingStackView.addArrangedSubview(closeButton)
        
        backButtonConstraints = backButton.anchor(.width(36))
        closeButtonConstraints = closeButton.anchor(.width(36))
    }
    
    private func setupConstraints() {
        
        mainStackViewConstraints = mainStackView.anchor(
            .top(safeAreaLayoutGuide.topAnchor),
            .leading(leadingAnchor, constant: 12),
            .trailing(trailingAnchor, constant: 12),
            .height(height),
            .bottom(bottomAnchor)
        )
        trailingStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleViews.anchor(
            .top(centerView.topAnchor),
            .bottom(centerView.bottomAnchor),
            .leadingLessThanEqual(centerView.leadingAnchor),
            .trailingGreaterThanEqual(centerView.trailingAnchor),
            .leading(leadingAnchor),
            .trailing(trailingAnchor)
        )
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NavigationBar {
    func makeBackButton(imageName: String, isHidden: Bool = false) -> Button {
        let btn = Button(
            image: UIImage(named: imageName),
            tintColor: .black,
            isHidden: isHidden
        )
        return btn
    }
}
#endif
