//
//  FLNativeView.swift
//  flutter_nuvei_sdk
//
//  Created by Trinh Danh on 21/3/24.
//

import Flutter
import UIKit
import NuveiSimplyConnectSDK

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.yellow
//        let nativeLabel = UILabel()
//        nativeLabel.text = "Native text from iOS"
//        nativeLabel.textColor = UIColor.white
//        nativeLabel.textAlignment = .center
//        nativeLabel.frame = CGRect(x: 0, y: 0, width: 280, height: 48.0)
        
        do {
            let creditCardField = try NuveiFields.createCreditCardField()
            var allTextFields = [UITextField]()
            var allLabels = [UILabel]()
            creditCardField.onInputUpdated = { hasFocus in
                print(hasFocus)
                print(allTextFields[0].text ?? "")
                print(allTextFields[1].text ?? "")
                print(allTextFields[2].text ?? "")
                print(allTextFields[3].text ?? "")
                // TODO: Implement input update callback
            }
            creditCardField.onInputValidated = { errors in
                // TODO: Implement validations callback
                print(allLabels[1].text ?? "")
                print(allLabels[3].text ?? "")
                print(allLabels[5].text ?? "")
                print(allLabels[7].text ?? "")
            }
            _view.addSubview(creditCardField)
            allTextFields = _view.findTextFields()
            allLabels = _view.findLabels()
            print("tesstttt")
        } catch {
            print("Error info: \(error)")
            // TODO: Handle exception
        }
        
        let textFieldsWithTags = _view.findTextFieldsWithTags()
        for (textField, tagID) in textFieldsWithTags {
            print("Tag ID của UITextField là: \(tagID)")
        }
    }
}

extension UIView {
    func findTextFields() -> [UITextField] {
        var textFields = [UITextField]()
        for subview in subviews {
            if let textField = subview as? UITextField {
                textFields.append(textField)
            } else {
                textFields += subview.findTextFields()
            }
        }
        return textFields
    }
    
    func findLabels() -> [UILabel] {
        var textFields = [UILabel]()
        for subview in subviews {
            if let textField = subview as? UILabel {
                textFields.append(textField)
            } else {
                textFields += subview.findLabels()
            }
        }
        return textFields
    }
    
    func findTextFieldsWithTags() -> [(textField: UITextField, tagID: Int)] {
            var textFieldsWithTags = [(UITextField, Int)]()
            for subview in subviews {
                if let textField = subview as? UITextField {
                    textFieldsWithTags.append((textField, textField.tag))
                } else {
                    textFieldsWithTags += subview.findTextFieldsWithTags()
                }
            }
            return textFieldsWithTags
        }
}
