//
//  WordsView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import SwiftUI

struct WordsView: View {
    @ObservedObject var viewModel: WordsViewModel
    
    var updateStateText: some View {
        Group {
            if let refreshResult = viewModel.refreshResult {
                switch refreshResult {
                case .completed:
                    Text("已從伺服器同步最新資料")
                case .failed(let error):
                    switch error {
                    case .networking(_):
                        Text("您正在使用本地資料") // Cannot use fallthrough in here
                    case .decoding(_):
                        Text("您正在使用本地資料")
                    }
                }
            } else {
                Text("從伺服器讀取資料...")
            }
        }
        .font(.subheadline)
        .padding(.vertical, 8)
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                List {
                    ForEach(viewModel.words) { word in
                        WordRow(word: word)
                    }
                }
                .listStyle(PlainListStyle())
                updateStateText
            }
            .navigationTitle("單字")
            .navigationBarItems(
                trailing: Button(action: { [unowned viewModel] in
                    viewModel.update()
                }) {
                    Text("更新")
                }
            )
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
