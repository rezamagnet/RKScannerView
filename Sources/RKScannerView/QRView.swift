//
//  QRView.swift
//  Parental Control
//
//  Created by Reza Khonsari on 5/30/21.
//

import UIKit

class QRView: UIView {
    
    var yOffset: CGFloat = .zero {
        didSet {
            centerYConstraint.constant = yOffset
        }
    }
    
    private lazy var centerYConstraint = innerImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor, constant: yOffset)
    
    @IBInspectable
    var imageName: String = "qrInnerImage" {
        didSet { innerImageView.image = UIImage(named: imageName, in: .module, compatibleWith: nil) }
    }
    
    @IBInspectable
    var opacityBackgroundColor: UIColor = #colorLiteral(red: 0.01568627451, green: 0.07450980392, blue: 0.1725490196, alpha: 0.5035190203) {
        didSet { backgroundColor = opacityBackgroundColor }
    }
    
    private var imageContainerView = UIView()
    private var innerImageView = UIImageView()
    
    var innerImageViewFrame: CGRect { innerImageView.frame }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        accessibilityLabel = "QRView"
        backgroundColor = opacityBackgroundColor
        addSubview(imageContainerView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        imageContainerView.addSubview(innerImageView)
        innerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            innerImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            centerYConstraint,
            innerImageView.widthAnchor.constraint(equalToConstant: 230),
            innerImageView.heightAnchor.constraint(equalToConstant: 230)
        ])
        innerImageView.image = UIImage(named: imageName, in: .module, compatibleWith: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutIfNeeded()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let mutablePath = CGMutablePath(roundedRect: innerImageView.frame.insetBy(dx: 4, dy: 4), cornerWidth: 40, cornerHeight: 40, transform: nil)
        mutablePath.addRect(bounds)
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = .evenOdd
        layer.mask = mask
    }
}
