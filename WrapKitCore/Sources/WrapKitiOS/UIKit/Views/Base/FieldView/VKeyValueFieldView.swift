//
//  VKeyValueFieldView.swift
//  WrapKit
//
//  Created by Stas Lee on 5/8/23.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

//open class VKeyValueFieldView: UIView {
//    public lazy var keyLabel = Label(
//        font: .systemFont(ofSize: 11),
//        textColor: .black,
//        numberOfLines: 1
//    )
//    public lazy var valueLabel = Label(
//        font: .systemFont(ofSize: 14),
//        textColor: .black,
//        numberOfLines: 1,
//        minimumScaleFactor: 0.5,
//        adjustsFontSizeToFitWidth: true
//    )
//    
//    public var spacing: CGFloat = 0 {
//        didSet {
//            valueLabelConstraints?.top?.constant = spacing
//        }
//    }
//    
//    public var contentInsets: UIEdgeInsets = .zero {
//        didSet {
//            keyLabelConstraints?.top?.constant = contentInsets.top
//            keyLabelConstraints?.leading?.constant = contentInsets.left
//            keyLabelConstraints?.trailing?.constant = -contentInsets.right
//            
//            valueLabelConstraints?.top?.constant = contentInsets.top
//            valueLabelConstraints?.leading?.constant = contentInsets.left
//            valueLabelConstraints?.trailing?.constant = -contentInsets.right
//            valueLabelConstraints?.bottom?.constant = -contentInsets.bottom
//        }
//    }
//    
//    private(set) var keyLabelConstraints: AnchoredConstraints?
//    private(set) var valueLabelConstraints: AnchoredConstraints?
//    
//    public init(
//        keyLabel: Label = Label(
//            font: .systemFont(ofSize: 11),
//            textColor: .black,
//            numberOfLines: 0
//        ),
//        valueLabel: Label = Label(
//            font: .systemFont(ofSize: 14),
//            textColor: .black,
//            numberOfLines: 0,
//            minimumScaleFactor: 0.5,
//            adjustsFontSizeToFitWidth: true
//        ),
//        spacing: CGFloat = 4,
//        contentInsets: UIEdgeInsets = .zero,
//        isHidden: Bool = false
//    ) {
//        super.init(frame: .zero)
//        
//        self.keyLabel = keyLabel
//        self.valueLabel = valueLabel
//        self.isHidden = isHidden
//        self.spacing = spacing
//        self.contentInsets = contentInsets
//        self.valueLabel.addObserver(self, forKeyPath: "hidden", options: [.new], context: nil)
//        
//        setupSubviews()
//        setupConstraints()
//    }
//    
//    override open func observeValue(
//        forKeyPath keyPath: String?,
//        of object: Any?,
//        change: [NSKeyValueChangeKey: Any]?,
//        context: UnsafeMutableRawPointer?
//    ) {
//        guard keyPath == "hidden" else { return }
//        valueLabelConstraints?.height?.isActive = valueLabel.isHidden
//        UIView.animate(withDuration: 0.3) {
//            self.layoutIfNeeded()
//        }
//    }
//    
//    deinit {
//        valueLabel.removeObserver(self, forKeyPath: "hidden")
//    }
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setupSubviews()
//        setupConstraints()
//    }
//    
//    public required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupSubviews() {
//        addSubview(keyLabel)
//        addSubview(valueLabel)
//    }
//    
//    func setupConstraints() {
//        keyLabelConstraints = keyLabel.anchor(
//            .top(topAnchor, constant: contentInsets.top),
//            .leading(leadingAnchor, constant: contentInsets.left),
//            .trailing(trailingAnchor, constant: contentInsets.right)
//        )
//        
//        valueLabelConstraints = valueLabel.anchor(
//            .top(keyLabel.bottomAnchor, constant: spacing),
//            .leading(leadingAnchor, constant: contentInsets.left),
//            .trailing(trailingAnchor, constant: contentInsets.right),
//            .bottom(bottomAnchor, constant: contentInsets.bottom),
//            .height(0, priority: .defaultLow)
//        )
//        valueLabelConstraints?.height?.isActive = false
//    }
//}

open class VKeyValueFieldView: UIView {
    public lazy var stackView = StackView(axis: .vertical, spacing: 4)
    public lazy var keyLabel = Label(
        font: .systemFont(ofSize: 11),
        textColor: .black,
        numberOfLines: 1
    )
    public lazy var valueLabel = Label(
        font: .systemFont(ofSize: 14),
        textColor: .black,
        numberOfLines: 1,
        minimumScaleFactor: 0.5,
        adjustsFontSizeToFitWidth: true
    )

    public init(
        keyLabel: Label = Label(
            font: .systemFont(ofSize: 11),
            textColor: .black,
            numberOfLines: 1
        ),
        valueLabel: Label = Label(
            font: .systemFont(ofSize: 14),
            textColor: .black,
            numberOfLines: 1,
            minimumScaleFactor: 0.5,
            adjustsFontSizeToFitWidth: true
        ),
        spacing: CGFloat = 4,
        contentInsets: UIEdgeInsets = .zero,
        isHidden: Bool = false
    ) {
        super.init(frame: .zero)

        self.stackView = StackView(axis: .vertical, spacing: spacing, contentInset: contentInsets)
        self.keyLabel = keyLabel
        self.valueLabel = valueLabel
        self.isHidden = isHidden

        setupSubviews()
        setupConstraints()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VKeyValueFieldView {
    func setupSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(keyLabel)
        stackView.addArrangedSubview(valueLabel)
    }

    func setupConstraints() {
        stackView.anchor(
            .top(topAnchor),
            .bottom(bottomAnchor),
            .leading(leadingAnchor),
            .trailing(trailingAnchor)
        )
    }
}

@available(iOS 13.0, *)
struct VKeyValueFieldViewKeyLabelValueLabelRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> VKeyValueFieldView {
        let view = VKeyValueFieldView()
        view.backgroundColor = .cyan
        view.keyLabel.text = "Key Label"
        view.valueLabel.text = "Value Label"
        return view
    }

    func updateUIView(_ uiView: VKeyValueFieldView, context: Context) {
        // Leave this empty
    }
}

struct VKeyValueFieldViewKeyLabelRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> VKeyValueFieldView {
        let view = VKeyValueFieldView()
        view.backgroundColor = .yellow
        view.keyLabel.text = "Key Label"
        view.valueLabel.isHidden = true
        return view
    }

    func updateUIView(_ uiView: VKeyValueFieldView, context: Context) {
        // Leave this empty
    }
}

struct VKeyValueFieldViewValueLabelRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> VKeyValueFieldView {
        let view = VKeyValueFieldView()
        view.backgroundColor = .green
        view.keyLabel.isHidden = true
        view.valueLabel.text = "Value Label"
        return view
    }

    func updateUIView(_ uiView: VKeyValueFieldView, context: Context) {
        // Leave this empty
    }
}

@available(iOS 13.0, *)
struct VKeyValueFieldView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        VStack {
            VKeyValueFieldViewKeyLabelValueLabelRepresentable()
                .frame(height: 35)
                .padding()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE (2nd generation)")

            VKeyValueFieldViewKeyLabelRepresentable()
                .frame(height: 25)
                .padding()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE (2nd generation)")

            VKeyValueFieldViewValueLabelRepresentable()
                .frame(height: 25)
                .padding()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE (2nd generation)")
            Spacer()
        }
    }
}
#endif
