//
//  ButtonTests.swift
//  WrapKitTests
//
//  Created by Улан Бейшенкулов on 25/3/24.
//

import XCTest
import WrapKit
import UIKit

class ButtonTests: XCTestCase {
    func test_onPressClosureTriggeredOnButtonPress() {
        DispatchQueue.main.async {
            let onPressExpectation = self.expectation(description: "onPress closure was not triggered")
            let button = self.makeSUT()
            
            button.onPress = {
                onPressExpectation.fulfill()
            }
            
            button.sendActions(for: .touchUpInside)
            self.wait(for: [onPressExpectation], timeout: 0.1)
            
            let onPressExpectation2 = self.expectation(description: "onPress closure was not triggered")
            button.sendActions(for: .touchUpInside)
            button.onPress = {
                onPressExpectation2.fulfill()
            }
            
            self.wait(for: [onPressExpectation2], timeout: 0.1)
        }
    }
    
    private func makeSUT() -> Button {
        let button = Button()
        return button
    }
}
