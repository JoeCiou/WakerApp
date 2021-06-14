//
//  CommonAlarmFormView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import SwiftUI

struct CommonAlarmFormView: View {
    @ObservedObject var viewModel: CommonAlarmFormViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    func buildFieldRow<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Text(title)
            Spacer()
            content()
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    TimeField(hour: $viewModel.hour, minute: $viewModel.minute)
                }
                Section() {
                    buildFieldRow(title: "標籤") {
                        TextField("", text: $viewModel.remark)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("新鬧鐘")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("儲存") { [unowned viewModel] in
                    viewModel.submit()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct CommonAlarmFormView_Previews: PreviewProvider {
    static var previews: some View {
        CommonAlarmFormView(viewModel: CommonAlarmFormViewModel())
    }
}
