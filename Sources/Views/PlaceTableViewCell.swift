//
//  PlaceTableViewCell.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/13/23.
//

import UIKit

final class PlaceTableViewCell: UITableViewCell {
    static let reusableIdentifier = String(describing: PlaceTableViewCell.self)
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(for place: Place) {
        nameLabel.text = place.name
        let detailLabelText = detailLabelText(for: place)
        detailLabel.text = detailLabelText
        accessibilityTraits = .button
    }
}

private extension PlaceTableViewCell {
    func setupSubviews() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        nameLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        nameLabel.textColor = .label
        detailLabel.textColor = .secondaryLabel
    }
    
    func detailLabelText(for place: Place) -> String {
        let distance = UserFormatter.stringForDistance(meters: place.distance)
        let categoryNames = place.categories.compactMap { $0.name }
        let categoryString = categoryNames.joined(separator: ", ")
        return [distance, categoryString].joined(separator: ", ")
    }
}
