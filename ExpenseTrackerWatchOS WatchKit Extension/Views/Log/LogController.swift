//
//  LogController.swift
//  ExpenseTrackerWatchOS WatchKit Extension
//
//  Created by Alfian Losari on 02/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import CoreData

class LogController: WKHostingController<LogView> {
    
    override var body: LogView {
        return LogView(context: CoreDataStack.shared.viewContext)
    }
}

struct LogView: View {
    
    var context: NSManagedObjectContext
    
    var body: some View {
        LogListView()
            .environment(\.managedObjectContext, context)
    }
}



