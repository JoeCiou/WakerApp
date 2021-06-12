//
//  WordService.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/9.
//

import Foundation
import Combine

class WordService: AnyDataFetchable<Word> {
    static let shared = WordService()
    
    private init() {
        super.init()
    }
        
    override func fetch() -> AnyPublisher<[Word], DataFetchableError> {
        let url = URL(string: "https://fc0771c0-9d23-4f83-b00a-7ef82192ac32.mock.pstmn.io/api/v1/words")!
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError(DataFetchableError.networking)
            .map(\.data)
            .decode(type: WordsApiResponse.self, decoder: JSONDecoder())
            .mapError(DataFetchableError.decoding)
            .map(\.words)
            .eraseToAnyPublisher()
    }
}

