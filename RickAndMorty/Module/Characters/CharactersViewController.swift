//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Denis Khlopin on 04.05.2021.
//

import UIKit
import RxSwift

class CharactersViewController: UITableViewController {
    var viewModel: CharactersViewModel?

    private let disposeBag = DisposeBag()
    private lazy var activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribeObservers()
        viewModel?.viewIsInit()
    }

    private func setupUI() {
        setupTableView()
        setupRefreshControl()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = activityView
    }

    private func setupRefreshControl() {
        refreshControl?.addTarget(self, action: #selector(refresh(_:)),
                                  for: .valueChanged)
    }

    @objc func refresh(_ sender: AnyObject) {
        viewModel?.fetchFirst()
    }

    private func subscribeObservers() {
        viewModel?.loadingObserver.subscribe(onNext: { [unowned self] isLoading in
            isLoading
                ? self.activityView.startAnimating()
                : self.activityView.stopAnimating()
        }).disposed(by: disposeBag)
        viewModel?.reloadDataObserver.subscribe(onNext: { [unowned self] _ in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height

        if offsetY + frameHeight > contentHeight {
            viewModel?.fetchNext()
        }
    }
}

// MARK: - UITableViewDelegate
extension CharactersViewController {

}

// MARK: - UITableViewDataSource
extension CharactersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.characters.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let character = getCharacter(by: indexPath) else {
            return UITableViewCell()
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "id")
        cell.textLabel?.text = character.name
        cell.detailTextLabel?.text = "\(character.id)"
        return cell
    }

    private func getCharacter(by indexPath: IndexPath) -> Character? {
        let index = indexPath.row
        guard let characters = viewModel?.characters,
              index >= 0, index < characters.count else {
            return nil
        }
        return characters[index]
    }

}
