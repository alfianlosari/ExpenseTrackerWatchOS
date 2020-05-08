//
//  DashboardView.swift
//  ExpenseTrackerWatchOS WatchKit Extension
//
//  Created by Alfian Losari on 02/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    
    var body: some View {
        List {
            if totalExpenses != nil && totalExpenses! > 0 {
                VStack(alignment: .center, spacing: 2) {
                    Text("Total expenses")
                        .font(.footnote)
                    Text(totalExpenses!.formattedCurrencyText)
                        .font(.headline)
                    
                    if categoriesSum != nil  {
                        PieChartView(
                            data: categoriesSum!.map { ($0.sum, $0.category.color) },
                            style: Styles.pieChartStyleOne,
                            form: CGSize(width: 160, height: 110),
                            dropShadow: false
                        ).padding()
                    }
                }
                .listRowPlatterColor(.clear)
            }
            
            if categoriesSum != nil {
                ForEach(self.categoriesSum!) {
                    CategoryRowView(category: $0.category, sum: $0.sum)
                }
            }
            
            if totalExpenses == nil && categoriesSum == nil {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding()
            }
        }
        .listStyle(CarouselListStyle())
        .navigationBarTitle("Dashboard")
        .onAppear(perform: fetchTotalSums)
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else {
                self.totalExpenses = nil
                self.categoriesSum = nil
                return
            }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let sum: Double
    
    var body: some View {
        HStack {
            CategoryImageView(category: category)
            VStack(alignment: .leading) {
                Text(category.rawValue.capitalized)
                Text(sum.formattedCurrencyText).font(.headline)
            }
        }
        .listRowPlatterColor(category.color)
        .padding(.vertical, 4)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(context: CoreDataStack(modelName: "ExpenseTracker").viewContext)
    }
}
