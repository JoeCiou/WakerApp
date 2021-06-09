//
//  RegularAlarmFormView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/7.
//

import SwiftUI

struct RegularAlarmFormView: View {
    @ObservedObject var viewModel: RegularAlarmFormViewModel
    
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
            VStack {
                List {
                    // Putting the time field to another section to fix the size issue caused from the cell size is changed
                    Section() {
                        TimeField(hour: $viewModel.hour, minute: $viewModel.minute)
                    }
                    Section() {
                        NavigationLink(destination: RepeatSettingsFormView(repeatSettings: $viewModel.repeatSettings)) {
                            buildFieldRow(title: "重複") {
                                Text(TimeUtils.getWeeksString(weeks: Array(viewModel.repeatSettings.weeks)))
                            }
                        }
                        buildFieldRow(title: "標籤") {
                            TextField("", text: $viewModel.remark)
                                .multilineTextAlignment(.trailing)
                        }
                        buildFieldRow(title: "啟用") {
                            Toggle("", isOn: $viewModel.isOn)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("新鬧鐘")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("儲存") {
                    viewModel.submit()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct RegularAlarmFormView_Previews: PreviewProvider {
    static var previews: some View {
        RegularAlarmFormView(viewModel: RegularAlarmFormViewModel(repository: AlarmMockRepository()))
    }
}
