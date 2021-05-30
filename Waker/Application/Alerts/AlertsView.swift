//
//  AlertsView.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import SwiftUI

struct AlertsView: View {
    @ObservedObject var viewModel: AlertsViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.alerts.indices, id: \.self) { index in
                    let alert = viewModel.alerts[index]
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(alert.hour):\(alert.minute)")
                            Text(alert.name)
                                .font(.subheadline)
                        }
                        Toggle(
                            "", isOn: $viewModel.alerts[index].isOn
                        )
                    }
                }.onDelete(perform: { indexSet in
                    viewModel.deleteAlert(at: indexSet)
                })
            }
            .navigationTitle("鬧鐘")
            .navigationBarItems(leading: EditButton(), trailing: Button("New", action: {
                    viewModel.addAlert(Alert(name: "新鬧鐘", hour: 12, minute: 30))
                    }
                )
            )
        }
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView(viewModel: AlertsViewModel(provider: AlertMock()))
    }
}
