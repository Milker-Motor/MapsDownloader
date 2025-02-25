//
//  MapTableViewCell.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import UIKit

public final class MapTableViewCell: UITableViewCell {
    
    enum State {
        case `default`
        case downloading
        case downloaded
        case notRun
    }
    
    var onState: ((State) -> Void)?
//    = { state in
//        accessoryType = state == .default ? .disclosureIndicator : .none
//        progressView.isHidden = state != .downloading
//        iconImageView.tintColor = state == .downloaded ? .iconMapDownloaded : .iconMapDefault
//        selectionStyle = state == .default ? .default : .none
//        
//        switch state {
//        case .default:
//            actionButton.setImage(nil, for: .normal)
//            actionButton.isHidden = true
//        case .downloading:
//            actionButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
//            actionButton.isHidden = false
//        case .downloaded:
//            actionButton.setImage(nil, for: .normal)
//            actionButton.isHidden = true
//        case .notRun:
//            progressView.progress = 0
//            actionButton.setImage(UIImage(named: "ic_custom_download"), for: .normal)
//            actionButton.isHidden = false
//        }
//        layoutIfNeeded()
//        //        }
//    }()
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        view.widthAnchor.constraint(equalToConstant: 32).isActive = true
        view.addSubviewAndPinToCenter(iconImageView)
        
        return view
    }()
    
    private lazy var iconImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "ic_custom_show_on_map")
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .darkText
        
        return label
    }()
    
    lazy var progressView = {
        let progressView = UIProgressView()
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.isHidden = true
        
        return progressView
    }()
    
    lazy var actionButton = {
        let button = UIButton(type: .custom)
        
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.tintColor = .blue
        button.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        return button
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fill
        container.spacing = 16
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(progressView)
        
        container.addArrangedSubview(iconContainer)
        container.addArrangedSubview(stackView)
        container.addArrangedSubview(actionButton)
        
        backgroundColor = .tableCellBackground
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        
        container.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        let topAnchor = container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        let bottomAnchor = container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        topAnchor.priority = UILayoutPriority(999)
        bottomAnchor.priority = UILayoutPriority(999)
        
        topAnchor.isActive = true
        bottomAnchor.isActive = true
        
        configureState()
    }
    
    private func configureState() {
        onState = { [weak self] state in
            self?.accessoryType = state == .default ? .disclosureIndicator : .none
            self?.progressView.isHidden = state != .downloading
            self?.iconImageView.tintColor = state == .downloaded ? .iconMapDownloaded : .iconMapDefault
            self?.selectionStyle = state == .default ? .default : .none
    
            switch state {
            case .default:
                self?.actionButton.setImage(nil, for: .normal)
                self?.actionButton.isHidden = true
            case .downloading:
                self?.actionButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
                self?.actionButton.isHidden = false
            case .downloaded:
                self?.actionButton.setImage(nil, for: .normal)
                self?.actionButton.isHidden = true
            case .notRun:
                self?.progressView.progress = 0
                self?.actionButton.setImage(UIImage(named: "ic_custom_download"), for: .normal)
                self?.actionButton.isHidden = false
            }
            self?.layoutIfNeeded()
        }
    }
}
