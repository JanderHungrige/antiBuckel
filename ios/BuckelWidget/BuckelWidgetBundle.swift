//
//  BuckelWidgetBundle.swift
//  BuckelWidget
//
//  Created by jwh on 06.01.26.
//

import WidgetKit
import SwiftUI

@main
struct BuckelWidgetBundle: WidgetBundle {
    var body: some Widget {
        BuckelWidget()
        BuckelWidgetControl()
        BuckelWidgetLiveActivity()
    }
}
