//
//  LogListView.swift
//  ExpenseTrackerWatchOS WatchKit Extension
//
//  Created by Alfian Losari on 02/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogListView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @State var logToEdit: ExpenseLog?
    @State var isAddPresented: Bool = false
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    var result: FetchedResults<ExpenseLog>
    
    var body: some View {
        ZStack {
            ScrollView {
                Button(action: {
                    self.isAddPresented = true
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle")
                        Text("Add Log")
                        Spacer()
                    }
                    .foregroundColor(Color(hexString: "#F92365"))
                }
                
                ForEach(self.result) { (log: ExpenseLog) in
                    Button(action: {
                        self.logToEdit = log
                    }) {
                        LogRowView(log: .constant(log))
                    }
                }
                .sheet(item: self.$logToEdit) { (log: ExpenseLog) in
                    LogFormView(
                        logToEdit: log,
                        context: self.context,
                        name: log.name ?? "",
                        amount: log.amount?.doubleValue ?? 0,
                        category: Category(rawValue: log.category ?? "") ?? .food
                    )
                }
            }
            
            if result.isEmpty {
                Text("No expenses data\nPlease add an expense first.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding()
            }
        }
        .navigationBarTitle("Expenses")
        .sheet(isPresented: $isAddPresented) {
            LogFormView(context: self.context)
        }
    }
}

struct LogRowView: View {
    
    @Binding var log: ExpenseLog
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CategoryImageView(category: log.categoryEnum, color: log.categoryEnum.color)
                Text(log.nameText)
                    .font(.body)
            }
            HStack(alignment: .firstTextBaseline) {
                Text(log.amountText)
                    .font(.headline)
                
                Spacer()
                Text(log.dateText)
                    .font(.footnote)
            }
        }
    }
}
