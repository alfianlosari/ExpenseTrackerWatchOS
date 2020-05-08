//
//  LogFormView.swift
//  ExpenseTrackerWatchOS WatchKit Extension
//
//  Created by Alfian Losari on 02/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogFormView: View {
    
    var logToEdit: ExpenseLog?
    var context: NSManagedObjectContext
    
    @State var name: String = ""
    @State var amount: Double = 0
    @State var category: Category = .utilities
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Amount", value: $amount, formatter: Utils.numberFormatter)
                Picker(selection: $category, label: Text("Category")) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized).tag(category)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }
            
            Section {
                Button(action: self.onSaveTapped) {
                    HStack {
                        Spacer()
                        Text("Save")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                .listRowPlatterColor(Color.blue)
                
                if self.logToEdit != nil {
                    Button(action: self.onDeleteTapped) {
                        HStack {
                            Spacer()
                            Text("Delete")
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                    }
                    .listRowPlatterColor(Color.red)
                }
            }
        }
    }
    
    private func onSaveTapped() {
        let log: ExpenseLog
        if let logToEdit = self.logToEdit {
            log = logToEdit
        } else {
            log = ExpenseLog(context: self.context)
            log.id = UUID()
            log.date = Date()
        }
        
        log.name = self.name
        log.category = self.category.rawValue
        log.amount = NSDecimalNumber(value: self.amount)
        do {
            try context.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onDeleteTapped() {
        guard let logToEdit = self.logToEdit else { return }
        self.context.delete(logToEdit)
        try? context.saveContext()
        self.presentationMode.wrappedValue.dismiss()
        
    }
}

