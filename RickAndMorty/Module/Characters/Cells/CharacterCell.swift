//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Denis Khlopin on 05.05.2021.
//

import UIKit
import SDWebImage

class CharacterCell: UITableViewCell {
    static let identifier = "CharacterCell"

    private var viewModel: CharacterCellViewModel?
    private let placeholderImage = #imageLiteral(resourceName: "noPhoto")

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lastLocationLabel: UILabel!
    @IBOutlet weak var lastEpisobeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func initWith(viewModel: CharacterCellViewModel) {
        self.viewModel = viewModel
        setAvatarImage()

        let character = viewModel.character
        nameLabel.text = character.name
        statusView.backgroundColor = UIColor(named: character.status.colorName)
        statusLabel.text = "\(character.status.rawValue) - \(character.gender.rawValue)"

        lastLocationLabel.text = character.location.name
        lastEpisobeLabel.text = character.episode.first
    }

    private func setupUI() {
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
        statusView.layer.cornerRadius = statusView.frame.height / 2
    }

    private func setAvatarImage() {
        avatarImageView.image = placeholderImage
        guard let viewModel = viewModel else {
            return
        }
        if let url = URL(string: viewModel.character.image) {
            avatarImageView.sd_setImage(with: url)
        }
    }
    
}
