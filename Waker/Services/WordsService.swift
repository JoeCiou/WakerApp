//
//  WordsService.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/9.
//

import Foundation
import Combine

struct WordsApiResponse: Decodable {
    let words: [Word]
}

class WordsService: Service {
    typealias Model = [Word]
    
    static let shared = WordsService()
    
    private init() {
        
    }
        
    func fetch() -> AnyPublisher<[Word], ServiceFetchError> {
        let url = URL(string: "https://fc0771c0-9d23-4f83-b00a-7ef82192ac32.mock.pstmn.io/api/v1/words")!
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: WordsApiResponse.self, decoder: JSONDecoder())
            .map(\.words)
            .mapError { error in
                if let urlError = error as? URLError {
                    return ServiceFetchError.networking(urlError)
                } else {
                    return ServiceFetchError.decoding(error)
                }
            }
            .eraseToAnyPublisher()
    }
}


