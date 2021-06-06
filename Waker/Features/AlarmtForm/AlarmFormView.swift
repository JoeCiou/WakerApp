//
//  AlarmFormView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/4.
//

import SwiftUI

struct AlarmFormView: View {
    @ObservedObject var viewModel: AlarmFormViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: TimeHeader(hour: $viewModel.hour, minute: $viewModel.minute)) {
                        HStack {
                            Text("標籤")
                            Spacer()
                            TextField("", text: $viewModel.remark)
                                .multilineTextAlignment(.trailing)
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

struct TimeHeader: View {
    @Binding var hour: Int
    @Binding var minute: Int
    
    var body: some View {
        HStack() {
            Text("時間").font(.headline)
            Spacer()
            DatePicker("", selection: Binding<Date>(
                get: { DateComponents(calendar: Calendar.current, hour: hour, minute: minute).date! },
                set: {
                    hour = Calendar.current.component(.hour, from: $0)
                    minute = Calendar.current.component(.minute, from: $0)
                }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(GraphicalDatePickerStyle())
        }.frame(minHeight: 100, alignment: .center)
    }
}

struct AlarmFormView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmFormView(viewModel: AlarmFormViewModel(repository: AlarmMockRepository()))
    }
}
