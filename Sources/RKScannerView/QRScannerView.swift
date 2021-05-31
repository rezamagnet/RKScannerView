//
//  QRScannerView.swift
//  QRDemo
//
//  Created by Reza Khonsari on 5/31/21.
//

import UIKit

public class QRScannerView: UIView {
    
    // MARK: - Public API
    @IBInspectable
    public var indicatorColor: UIColor = #colorLiteral(red: 0.1921568627, green: 0.462745098, blue: 0.9215686275, alpha: 1)
    
    @IBInspectable
    public var yOffset: CGFloat = .zero {
        didSet {
            qrView.yOffset = yOffset
        }
    }
    
    @IBInspectable
    public var animationSpeed: CGFloat = 1 {
        didSet {
            layoutIfNeeded()
            setNeedsDisplay()
        }
    }

    
    // MARK: - Private API
    private var qrView = QRView()
    private var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubview(qrView)
        qrView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrView.topAnchor.constraint(equalTo: topAnchor),
            qrView.bottomAnchor.constraint(equalTo: bottomAnchor),
            qrView.leadingAnchor.constraint(equalTo: leadingAnchor),
            qrView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        addSubview(lineView)
        lineView.backgroundColor = indicatorColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(indicatorAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = .init(x: qrView.innerImageViewFrame.minX - 25, y: qrView.innerImageViewFrame.maxY-2, width: qrView.innerImageViewFrame.width + 50, height: 4)
        lineView.layer.cornerRadius = 2
    }
    
    
    @objc private func indicatorAnimation() {
        lineView.frame.origin.y = qrView.innerImageViewFrame.maxY-2
        UIView.animate(withDuration: TimeInterval(animationSpeed), delay: .zero, options: [.curveEaseInOut, .repeat, .autoreverse]) {
            self.lineView.frame.origin.y -= self.qrView.innerImageViewFrame.height
        } completion: { _ in }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        indicatorAnimation()
    }
    
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutIfNeeded()
        setNeedsDisplay()
    }
}
