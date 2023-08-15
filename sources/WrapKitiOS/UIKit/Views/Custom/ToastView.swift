//
//  ToastView.swift
//  WrapKit
//
//  Created by Stas Lee on 6/8/23.
//

#if canImport(UIKit)
import UIKit

public extension UIView {
    func showToast(
        title: String,
        subtitle: String? = nil,
        image: UIImage,
        position: ToastView.Position,
        duration: TimeInterval = 3.0
    ) {
        let toastView = ToastView(title: title, subtitle: subtitle, image: image, duration: duration)
        toastView.removePastToastIfNeeded(from: self)
        toastView.setPosition(on: self, position: position)
        toastView.animate(constant: duration, inside: self) { [weak self, weak toastView, duration] _ in
            guard let self = self else { return }
            toastView?.hide(after: duration, for: self)
        }
    }
}

open class ToastView: UIView {
    
    public let iconImageView = ImageView()
    public let titleViews = VKeyValueFieldView(
        keyLabel: Label(font: .systemFont(ofSize: 16), textColor: .black),
        valueLabel: Label(font: .systemFont(ofSize: 14), textColor: .gray)
    )
    public let duration: TimeInterval
    public var leadingConstraint: NSLayoutConstraint?
    
    static let tag = 228
    
    public enum Position {
        case top
        case middle
        case bottom
    }
    
    public init(title: String, subtitle: String?, image: UIImage, duration: TimeInterval = 3.0) {
        self.duration = duration
        super.init(frame: .zero)
        self.tag = Self.tag
        setup(title: title, subtitle: subtitle, image: image)
        setupSubviews()
        setupConstraints()
        setSwipe()
        setTapGesture()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String, subtitle: String?, image: UIImage) {
        titleViews.keyLabel.text = title
        titleViews.valueLabel.text = subtitle
        titleViews.valueLabel.isHidden = subtitle == nil
        iconImageView.image = image
    }
    
    private func setupSubviews() {
        addSubview(iconImageView)
        addSubview(titleViews)
    }
    
    private func setupConstraints() {
        iconImageView.anchor(
            .centerY(titleViews.centerYAnchor),
            .width(32),
            .height(32),
            .leading(leadingAnchor, constant: 16)
        )
        
        titleViews.anchor(
            .top(topAnchor, constant: 16),
            .leading(iconImageView.trailingAnchor, constant: 16),
            .trailing(trailingAnchor, constant: 20),
            .bottom(bottomAnchor, constant: 16)
        )
    }
    
    public func removePastToastIfNeeded(from view: UIView) {
        view.viewWithTag(Self.tag)?.removeFromSuperview()
    }
    
    private func setSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwiped))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTap(gesture: UITapGestureRecognizer) {
        guard let toastSuperView = superview else { return }
        hide(after: 0, for: toastSuperView)
    }
    
    @objc
    private func didSwiped(gesture: UISwipeGestureRecognizer) {
        guard let toastSuperView = superview else { return }
        
        if gesture.direction == .right {
            hide(after: 0, for: toastSuperView)
        }
    }
    
    public func setPosition(on view: UIView, position: Position) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        case .middle:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .bottom:
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }
        
        leadingConstraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width)
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        view.layoutIfNeeded()
    }
    
    public func animate(constant: CGFloat, inside view: UIView, completion: @escaping (Bool) -> Void) {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.leadingConstraint?.constant = constant
                view.layoutIfNeeded()
            },
            completion: completion
        )
    }
    
    public func hide(after duration: Double, for view: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.animate(constant: UIScreen.main.bounds.width, inside: view) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
#endif
