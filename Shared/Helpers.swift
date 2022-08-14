//
//  Helpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/20/22.
//

import SwiftUI

struct WrapNavigation: ViewModifier {
    func body(content: Content) -> some View {
        NavigationView {
            content
        }
    }
}

extension View {
    func wrapNavigation() -> some View {
        modifier(WrapNavigation())
    }
}

#if os(iOS)
// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
#endif

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            #if os(iOS)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
            #endif
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

func unescapeString(_ string:String) -> String {
    return string.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t")
}

func normalizeString(string:String, caseInsensitive:Bool, ignoreDiacritics:Bool) -> String {
    var formatted = string
    if caseInsensitive { formatted = formatted.folding(options: .caseInsensitive, locale: .current)}
    if ignoreDiacritics { formatted = formatted.folding(options: .diacriticInsensitive, locale: .current)}
    return formatted
}
