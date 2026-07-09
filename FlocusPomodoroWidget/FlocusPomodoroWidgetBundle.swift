//
//  FlocusPomodoroWidgetBundle.swift
//  FlocusPomodoroWidget
//
//  Created by Yuhaya Lissera on 09/07/26.
//

import WidgetKit
import SwiftUI

@main
struct FlocusPomodoroWidgetBundle: WidgetBundle {
    var body: some Widget {
        FlocusPomodoroWidget()
        FlocusPomodoroWidgetControl()
        FlocusPomodoroWidgetLiveActivity()
    }
}
