//
//  FlocusPomodoroWidgetLiveActivity.swift
//  FlocusPomodoroWidget
//
//  Created by Yuhaya Lissera on 09/07/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FlocusPomodoroWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FlocusPomodoroWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlocusPomodoroWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FlocusPomodoroWidgetAttributes {
    fileprivate static var preview: FlocusPomodoroWidgetAttributes {
        FlocusPomodoroWidgetAttributes(name: "World")
    }
}

extension FlocusPomodoroWidgetAttributes.ContentState {
    fileprivate static var smiley: FlocusPomodoroWidgetAttributes.ContentState {
        FlocusPomodoroWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FlocusPomodoroWidgetAttributes.ContentState {
         FlocusPomodoroWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FlocusPomodoroWidgetAttributes.preview) {
   FlocusPomodoroWidgetLiveActivity()
} contentStates: {
    FlocusPomodoroWidgetAttributes.ContentState.smiley
    FlocusPomodoroWidgetAttributes.ContentState.starEyes
}
