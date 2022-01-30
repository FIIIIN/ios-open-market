//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/18.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let containerStackView = UIStackView()
    let priceStackView = UIStackView()
    
    var productImageView = UIImageView()
    var productNameLabel = UILabel()
    var originalPriceLabel = UILabel()
    var priceLabel = UILabel()
    var stockLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    func setUpCell() {
        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
        ] )
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = Constants.CollectionView.defaultSpacing * 2
        containerStackView.clipsToBounds = true
        
        containerStackView.addArrangedSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + 5)
        ] )
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        containerStackView.addArrangedSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + 20),
            productNameLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + Constants.CollectionView.fontSize + 20),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7)
        ] )
        
        containerStackView.addArrangedSubview(priceStackView)
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            priceStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + Constants.CollectionView.fontSize + 29),
            priceStackView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + (Constants.CollectionView.fontSize * 3) + 29),
            priceStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7)
        ] )
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.distribution = .fill
        priceStackView.spacing = Constants.CollectionView.defaultSpacing
        
        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
        
        containerStackView.addArrangedSubview(stockLabel)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + (Constants.CollectionView.fontSize * 3) + 38),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.CollectionView.imageHeight + (Constants.CollectionView.fontSize * 4) + 38),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7)
        ] )
    }
    
    func updateCell(data: ProductPreview) {
        productNameLabel.text = data.name
        productNameLabel.font = UIFont.boldSystemFont(ofSize: Constants.CollectionView.defaultFontSize)
        productNameLabel.textAlignment = .center
        
        originalPriceLabel.attributedText = ("\(data.currency) \(data.price.demical())").strikeThroughStyle()
        originalPriceLabel.textColor = .systemRed
        originalPriceLabel.textAlignment = .center

        priceLabel.text = "\(data.currency) \((data.price - data.bargainPrice).demical())"
        priceLabel.textAlignment = .center
        priceLabel.textColor = .systemGray

        switch data.stock {
        case 0:
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
            stockLabel.textAlignment = .center
        default:
            stockLabel.text = "잔여 수량: \(data.stock)"
            stockLabel.textAlignment = .center
            stockLabel.textColor = .systemGray
        }
        
        guard let url = URL(string: data.thumbnail) else {
            return
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: data)
            }
        }
    }
}
