//
//  WordsView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import SwiftUI

struct WordsView: View {
    @ObservedObject var viewModel: WordsViewModel
    
    var fetchStateText: some View {
        Group {
            if viewModel.isFetching {
                Text("資料讀取中...")
            } else if let fetchResult = viewModel.fetchResult {
                switch fetchResult {
                case .completed:
                    Text("同步完成")
                case .failed(let error):
                    switch error {
                    case .networking(_):
                        Text("網路錯誤，請稍候重試")
                    case .decoding(_):
                        Text("遠端資料錯誤")
                    }
                }
            } else {
                EmptyView()
            }
        }
        .font(.subheadline)
        .padding(.leading)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                fetchStateText
                List {
                    ForEach(viewModel.words) { word in
                        WordRow(word: word)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("單字")
            .navigationBarItems(
                trailing: Button(action: { [unowned viewModel] in
                    viewModel.fetch()
                }) {
                    Text("更新")
                }
            )
        }
        .onAppear { [unowned viewModel] in
            // It will still be called before the view hasn't appeared: https://developer.apple.com/forums/thread/656655
            viewModel.connectDatabase()
        }
    }
}

struct WordRow: View {
    let word: Word
    
    var body: some View {
        if word.isInvalidated {
            EmptyView()
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Text(word.value.firstCapitalized).font(.largeTitle)
                    Text(word.ipa).opacity(0.5)
                }
                Text(word.partOfSpeech).font(.caption).opacity(0.5).padding(.top, 4)
                Text(word.translation).font(.title2)
                Text("例句").font(.caption).opacity(0.5).padding(.top, 4)
                Text(word.example).font(.title3)
                Text(word.exampleTranslation).font(.body).padding(.bottom, 4)
            }
        }
    }
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockWords = [
            Word(id: 1, value: "regarding", ipa: "/rɪˈɡɑːdɪŋ/", translation: "關於", example: "He said nothing regarding the lost documents", exampleTranslation: "關於遺失的文件他什麼都沒說。", partOfSpeech: "介系詞"),
            Word(id: 2, value: "conservative", ipa: "/kənˈsəːvətɪv/", translation: "保守的", example: "He has quite conservative views", exampleTranslation: "她的觀點還蠻保守的", partOfSpeech: "形容詞"),
        ]
        
        WordsView(viewModel: WordsViewModel(mockWords: mockWords))
    }
}
