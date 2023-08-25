//
//  File.swift
//
//
//  Created by songjunliang on 2023/8/22.
//  https://stackoverflow.com/questions/56784722/swiftui-send-email

import MessageUI
import SwiftUI
import UIKit

public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding public var result: Result<MFMailComposeResult, Error>?
    let subject: String?
    let toRecipients: [String]?
    
    public static var canSendMail: Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    public init(result: Binding<Result<MFMailComposeResult, Error>?>, subject: String? = nil, toRecipients: [String]? = nil) {
        self._result = result
        self.subject = subject
        self.toRecipients = toRecipients
    }

    public init(subject: String? = nil, toRecipients: [String]? = nil) {
        self._result = Binding<Result<MFMailComposeResult, Error>?>.constant(nil)
        self.subject = subject
        self.toRecipients = toRecipients
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>)
        {
            _presentation = presentation
            _result = result
        }

        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?)
        {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        if let subject = self.subject {
            vc.setSubject(subject)
        }
        vc.setToRecipients(toRecipients)
        return vc
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                       context: UIViewControllerRepresentableContext<MailView>) {}
}
