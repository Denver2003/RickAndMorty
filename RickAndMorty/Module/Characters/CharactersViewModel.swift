//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Denis Khlopin on 04.05.2021.
//

import RxSwift

class CharactersViewModel {
    private let router: CharactersRouter

    var characters = [Character]()
    let loadingObserver = BehaviorSubject<Bool>(value: false)
    let reloadDataObserver = PublishSubject<Bool>()
    let errorObserver = PublishSubject<RMError?>()
    var isLoading: Bool {
        (try? loadingObserver.value()) ?? false
    }
    private var page: Int?
    private var charactersService: CharactersService?
    private var pageInfo: CharactersInfo?
    private var totalPageCount: Int {
        pageInfo?.pages ?? 0
    }
    private var totalCount: Int {
        pageInfo?.count ?? 0
    }
    private var isFirstPage: Bool {
        page == nil
    }

    init(router: CharactersRouter) {
        self.router = router
    }

    func viewIsInit() {
        fetchFirst()
    }

    func fetchFirst() {
        if !canFetch() {
            return
        }
        clearPage()
        fetchCharacters()
    }

    func fetchNext() {
        if !canFetch() {
            return
        }
        increasePage()
        fetchCharacters()
    }

    private func clearPage() {
        page = nil
    }

    private func increasePage() {
        page = (page ?? 1) + 1
    }

    private func canFetch() -> Bool {
        if isLoading {
            return false
        }
        if let page = page, page > totalPageCount {
            return false
        }
        return true
    }

    private func fetchCharacters() {
        loadingObserver.onNext(true)
        charactersService = CharactersService()
        charactersService?.getCharacters(page: page) { [weak self] (result) in
            guard let self = self else {
                return
            }
            self.loadingObserver.onNext(false)
            switch result {
            case .success(let newCharacters):
                self.didGetCharacters(newCharacters)
            case .failure(let error):
                self.errorObserver.onNext(error)
            }
        }
    }

    private func didGetCharacters(_ characters: Characters) {
        let newCharacters = characters.results
        if isFirstPage {
            pageInfo = characters.info
            self.characters = newCharacters
        } else {
            self.characters.append(contentsOf: newCharacters)
        }
        reloadDataObserver.onNext(true)
    }
}
