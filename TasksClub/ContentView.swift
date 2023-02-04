//
//  ContentView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI
import UIKit

extension UINavigationBarAppearance {
    func setColor(title: UIColor? = nil, background: UIColor? = nil) {
        configureWithTransparentBackground()
        if let titleColor = title {
            largeTitleTextAttributes = [.foregroundColor: titleColor]
            titleTextAttributes = [.foregroundColor: titleColor]
        }
        backgroundColor = background
        UINavigationBar.appearance().scrollEdgeAppearance = self
        UINavigationBar.appearance().standardAppearance = self
    }
}
struct SymbolWidthPreferenceKey: PreferenceKey {

    static var defaultValue: Double = 0

    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = max(value, nextValue())
    }
}

struct SymbolWidthModifier: ViewModifier {

    @Binding var width: Double

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geo in
                Color
                    .clear
                    .preference(key: SymbolWidthPreferenceKey.self, value: geo.size.width)
            })
    }
}

extension Image {

    func sync(with width: Binding<Double>) -> some View {
         modifier(SymbolWidthModifier(width: width))
    }
}
extension View {
  func floatingActionButton<ImageView: View>(
    color: Color,
    image: ImageView,
    shadow: Color,
    action: @escaping () -> Void) -> some View {
    self.modifier(FloatingActionButton(color: color,
                                       image: image,
                                       action: action, shadow: shadow))
  }
}
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    // To make it works also with ScrollView
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
extension View {
  func sheet<Content, Tag>(
    tag: Tag,
    selection: Binding<Tag?>,
    content: @escaping () -> Content ) -> some View where Content: View, Tag: Hashable {
    let binding = Binding(
      get: {
        selection.wrappedValue == tag
      },
      set: { isPresented in
        if isPresented {
          selection.wrappedValue = tag
        } else {
          selection.wrappedValue = .none
        }
      }
    )
    return background(EmptyView().sheet(isPresented: binding, content: content))
  }
}
extension Date {
    var get12HourFormat: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        return formatter.string(from: self)
    }
    
    var get24HourFormat: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: self)
    }
}
extension String {
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}
extension Int {
        var secondaryKey: Int {
                1 << 16 + self
        }
}

