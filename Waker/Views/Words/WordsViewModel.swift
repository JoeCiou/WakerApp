//
//  LearningViewModel.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

class WordsViewModel: ObservableObject {
    let wordService: WordService = WordService.shared
    
    @Published var words: [Word]
    @Published var fetchError: DataFetchableError?
    @Published var anwserInput: String = ""
    
    var canceller: AnyCancellable?
    
    init() {
        self.words = [Word]()
    }
    
    #if DEBUG
    init(mockWords: [Word]) {
        self.words = mockWords
    }
    #endif

    func fetch() {
        canceller = wordService.fetch()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.fetchError = nil
            case .failure(let error):
                self.fetchError = error
            }
        }, receiveValue: { questions in
            self.words = questions
        })
    }
}
