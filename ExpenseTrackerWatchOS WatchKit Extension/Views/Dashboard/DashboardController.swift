//
//  HostingController.swift
//  ExpenseTrackerWatchOS WatchKit Extension
//
//  Created by Alfian Losari on 02/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import WatchKit
import SwiftUI

class DashboardController: WKHostingController<DashboardView> {
    
    override var body: DashboardView {
        return DashboardView(context: CoreDataStack.shared.viewContext)
    }
}
