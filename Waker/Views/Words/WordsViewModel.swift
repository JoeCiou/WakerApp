//
//  WordsViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

class WordsViewModel: ObservableObject {
    private let isMock: Bool
    
    @Published var words = [Word]()
    @Published var refreshResult: RepositoryRefreshResult?
    
    private var dataCanceller: AnyCancellable?
    private var refreshResultCanceller: AnyCancellable?
    
    init() {
        isMock = false
        connect()
    }
    
    #if DEBUG
    init(mockWords: [Word]) {
        isMock = true
        words = mockWords
    }
    #endif
    
    deinit {
        if (!isMock) {
            disconnect()
        }
    }
    
    func connect() {
        let (dataPublisher, updateResultPublisher) = WordsRepository.shared.connect()
        
        if (dataCanceller == nil) {
            dataCanceller = dataPublisher.sink { [weak self] words in
                self?.words = words
            }
        }
        if (refreshResultCanceller == nil) {
            refreshResultCanceller = updateResultPublisher.sink { [weak self] updateResult in
                self?.refreshResult = updateResult
            }
        }
    }
    
    func disconnect() {
        dataCanceller?.cancel()
        refreshResultCanceller?.cancel()
        WordsRepository.shared.disconnect()
    }
    
    func update() {
        refreshResult = nil
        WordsRepository.shared.refresh()
    }
}
