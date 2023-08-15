//
//  RadiusTableViewCell.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/14/23.
//

import UIKit

final class RadiusTableViewCell: UITableViewCell {
    static let reusableIdentifier = String(describing: RadiusTableViewCell.self)
    private let nameLabel = UILabel()
    private let slider = UISlider()
    var sliderActionHandler: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(for currentRadius: Int) {
        slider.minimumValue = 1
        slider.maximumValue = 25
        slider.value = Float(currentRadius)
        
        configureLabel(for: currentRadius)
    }
}

private extension RadiusTableViewCell {
    func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, slider])
        stackView.axis = .vertical
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.textColor = .label
        
        slider.addTarget(self, action: #selector(handleSliderAction), for: .valueChanged)
        
        selectionStyle = .none
    }
    
    func configureLabel(for currentRadius: Int) {
        nameLabel.text = NSLocalizedString("Within distance: \(currentRadius) mi", comment: "search radius label")
    }
    
    @objc func handleSliderAction() {
        let currentRadius = Int(slider.value.rounded())
        configureLabel(for: currentRadius)
        sliderActionHandler?(currentRadius)
    }
}
