//
//  StorageTableViewCell.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

class StorageTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Device memory"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let freeSpaceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = UIColor.lightGray
        progress.progressTintColor = .navigationBar
        progress.layer.cornerRadius = 6
        progress.clipsToBounds = true
        return progress
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        freeSpaceLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(freeSpaceLabel)
        contentView.addSubview(progressView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            freeSpaceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            freeSpaceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
