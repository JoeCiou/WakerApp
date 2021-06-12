//
//  LearningViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

class WordsViewModel: ObservableObject {
    @Published var words = [Word]()
    @Published var fetchResult: DataFetchResult?
    @Published var isFetching: Bool = false
    
    var dataCanceller: AnyCancellable?
    var fetchResultCanceller: AnyCancellable?
    
    init() {
        dataCanceller = WordRepository.shared.dataSubject.sink { words in
            self.words = words
        }
        fetchResultCanceller = WordRepository.shared.fetchResultSubject.sink { fetchResult in
            self.isFetching = false
            self.fetchResult = fetchResult
        }
    }
    
    #if DEBUG
    init(mockWords: [Word]) {
        self.words = mockWords
    }
    #endif
    
    deinit {
        self.dataCanceller?.cancel()
        self.fetchResultCanceller?.cancel()
    }

    func fetch() {
        isFetching = true
        WordRepository.shared.fetch()
    }
}
