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
    
    var state: State = .default {
        didSet {
            switch state {
            case .default:
                accessoryType = .disclosureIndicator
                progressView.isHidden = true
                actionButton.setImage(nil, for: .normal)
                iconImageView.tintColor = .iconMapDefault
                selectionStyle = .default
            case .downloading:
                accessoryType = .none
                progressView.isHidden = false
                actionButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
                iconImageView.tintColor = .iconMapDefault
                selectionStyle = .none
            case .downloaded:
                accessoryType = .disclosureIndicator
                progressView.isHidden = true
                actionButton.setImage(nil, for: .normal)
                iconImageView.tintColor = .iconMapDownloaded
                selectionStyle = .none
            case .notRun:
                accessoryType = .none
                progressView.isHidden = true
                actionButton.setImage(UIImage(named: "ic_custom_download"), for: .normal)
                iconImageView.tintColor = .iconMapDefault
                selectionStyle = .none
            }
        }
    }
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
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
        
//        var configuration = defaultContentConfiguration()
//        
//        configuration.imageProperties.tintColor = .iconMapDefault
//        configuration.image = UIImage(named: "ic_custom_show_on_map")
//        
//        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
//        backgroundConfig.backgroundColor = .tableCellBackground
//        
//        backgroundConfig.backgroundColorTransformer = UIConfigurationColorTransformer { color in
//            color.resolvedColor(with: UITraitCollection.current).withAlphaComponent(0.5)
//        }
//        
//        backgroundConfiguration = backgroundConfig
        
        container.addArrangedSubview(iconContainer)
        container.addArrangedSubview(stackView)
        container.addArrangedSubview(actionButton)
        
        backgroundColor = .tableCellBackground
        contentView.addSubviewAndPin(container, padding: 8)
    }
    
}

public extension UIView {
    func addSubviewAndPin(_ view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, safeArea: Bool = false) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if safeArea {
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottom).isActive = true
            view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: left).isActive = true
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -right).isActive = true
        } else {
            view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom).isActive = true
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -right).isActive = true
        }
    }
    
    func addSubviewAndPinToCenter(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func addSubviewAndPin(_ view: UIView, padding: CGFloat, safeArea: Bool = false) {
        addSubviewAndPin(view, top: padding, left: padding, bottom: padding, right: padding, safeArea: safeArea)
    }
}
