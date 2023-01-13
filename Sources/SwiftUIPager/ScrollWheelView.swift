//
//  ScrollWheelView.swift
//  LBPhotos
//
//  Created by Jake Zien on 12/29/22.
//

import Foundation
import SwiftUI

#if canImport(AppKit)
/// How the view passes events back to the representable view.
protocol ScrollViewDelegateProtocol {
  /// Informs the receiver that the mouse’s scroll wheel has moved.
  func scrollWheel(with event: NSEvent);
}

/// The AppKit view that captures scroll wheel events
class ScrollCaptureView: NSView {
  /// Connection to the SwiftUI view that serves as the interface to our AppKit view.
  var delegate: ScrollViewDelegateProtocol!
  /// Let the responder chain know we will respond to events.
  override var acceptsFirstResponder: Bool { true }
  /// Informs the receiver that the mouse’s scroll wheel has moved.
  override func scrollWheel(with event: NSEvent) {
    // pass the event on to the delegate
    delegate.scrollWheel(with: event)
  }
}

/// The SwiftUI view that serves as the interface to our AppKit view.
struct RepresentableScrollView: NSViewRepresentable, ScrollViewDelegateProtocol {
  /// The AppKit view our SwiftUI view manages.
  typealias NSViewType = ScrollCaptureView
  
  /// What the SwiftUI content wants us to do when the mouse's scroll wheel is moved.
  private var scrollAction: ((NSEvent) -> Void)?
  
  /// Creates the view object and configures its initial state.
  func makeNSView(context: Context) -> ScrollCaptureView {
    // Make a scroll view and become its delegate
    let view = ScrollCaptureView()
    view.delegate = self;
    return view
  }
  
  /// Updates the state of the specified view with new information from SwiftUI.
  func updateNSView(_ nsView: NSViewType, context: Context) {
  }
  
  /// Informs the representable view  that the mouse’s scroll wheel has moved.
  func scrollWheel(with event: NSEvent) {
    // Do whatever the content view wants
    // us to do when the scroll wheel moved
    if let scrollAction = scrollAction {
      scrollAction(event)
    }
  }

  /// Modifier that allows the content view to set an action in its context.
  func onScroll(_ action: @escaping (NSEvent) -> Void) -> Self {
    var newSelf = self
    newSelf.scrollAction = action
    return newSelf
  }
}
#endif

///// Our SwiftUI content view that we want to be able to scroll.
//struct ContentView: View {
//  /// The scroll offset -- when this value changes the view will be redrawn.
//  @State var offset: CGSize = CGSize(width: 0.0, height: 0.0)
//  /// The SwiftUI view that detects the scroll wheel movement.
//  var scrollView: some View {
//    // A view that will update the offset state variable
//    // when the scroll wheel moves
//    RepresentableScrollView()
//      .onScroll { event in
//        offset = CGSize(width: offset.width + event.deltaX, height: offset.height + event.deltaY)
//      }
//  }
//  /// The body of our view.
//  var body: some View {
//    // What we want to be able to scroll using offset(),
//    // overlaid (must be on top or it can't get the scroll event!)
//    // with the view that tracks the scroll wheel.
//    Image(systemName:"applelogo")
//      .scaleEffect(20.0)
//      .frame(width: 200, height: 200, alignment: .center)
//      .offset(offset)
//      .overlay(scrollView)
//  }
//}
