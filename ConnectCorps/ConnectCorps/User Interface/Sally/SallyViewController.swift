//
//  SallyViewController.swift
//

import UIKit
import MessageKit
import ApiAI
import AVKit

let me = Sender(id: "Me", displayName: "Me")

enum ApiAIAction: String, Codable {
    case sleepOn = "sleep_tracking.on"
    case sleepOff = "sleep_tracking.off"
}

struct ApiAIFulfillment: Codable {
    let speech: String
}

struct ApiAIResult: Codable {
    let action: String
    let parameters: [String: String]?
    let fulfillment: ApiAIFulfillment
}

struct ApiAIResponse: Codable {
    let result: ApiAIResult
}

struct Message: MessageType {
	let sender: Sender
	let messageId: String
	let sentDate: Date
	let data: MessageData
	
	init(message: String, fromUser: Bool) {
		sender = fromUser ? me : .init(id: "Sally", displayName: "Sally")
		messageId = UUID().uuidString
		sentDate = Date()
		data = .text(message)
	}
}

class SallyViewController: MessagesViewController {
	
	let synth = AVSpeechSynthesizer()
	var effect: SystemSoundID!
	let gen = UIImpactFeedbackGenerator(style: .light)
	
	var messages: [MessageType] = []
	
	@IBAction func homeTapped(_ sender: Any) {
		dismiss(animated: true)
	}
	
	func append(message: String, fromUser: Bool) {
		self.messages.append(Message(message: message, fromUser: fromUser))
		self.messagesCollectionView.reloadData()
		self.messagesCollectionView.scrollToBottom(animated: true)
		
		if fromUser {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				AudioServicesPlaySystemSound(self.effect)
				self.gen.impactOccurred()
				self.gen.prepare()
			}
		} else {
			let utterance = AVSpeechUtterance(string: message)
			self.synth.speak(utterance)
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		
		messageInputBar.delegate = self
//		messageInputBar.padding.bottom = 16
//		messageInputBar.padding.top = 16
		
		let topInset: CGFloat = messageInputBar.inputTextView.textContainerInset.top // 8
		let bottomInset: CGFloat = messageInputBar.inputTextView.textContainerInset.bottom // 8
		
		let radius = (topInset + 22 + bottomInset) / 2
		
		messageInputBar.inputTextView.layer.borderWidth = 1 / UIScreen.main.scale
		
//		messageInputBar.inputTextView.textContainerInset.top = topInset
//		messageInputBar.inputTextView.textContainerInset.bottom = bottomInset
		messageInputBar.inputTextView.textContainerInset.left = radius - 4
		messageInputBar.inputTextView.layer.cornerRadius = radius
//
//		messageInputBar.inputTextView.placeholderLabelInsets.top = topInset
//		messageInputBar.inputTextView.placeholderLabelInsets.bottom = bottomInset
		messageInputBar.inputTextView.placeholderLabelInsets.left = radius
		
		messagesCollectionView.messageCellDelegate = self
		
		let file = Bundle.main.url(forResource: "send_message", withExtension: "aif")!
		var effect: SystemSoundID = 0
		AudioServicesCreateSystemSoundID(file as CFURL, &effect)
		self.effect = effect
		
		gen.prepare()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.append(message: "Hi! What's on your mind?", fromUser: false)
			self.messageInputBar.inputTextView.becomeFirstResponder()
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		messageInputBar.inputTextView.becomeFirstResponder()
	}

}

extension SallyViewController: MessageInputBarDelegate {

    func parseResponse(_ resp: ApiAIResponse) {
        let speech = resp.result.fulfillment.speech
        self.append(message: speech, fromUser: false)

        guard let action = ApiAIAction(rawValue: resp.result.action) else { return }
        switch action {
        case .sleepOff:
            UserDefaults.standard.set(true, forKey: "disableSleepDetection")
        case .sleepOn:
            UserDefaults.standard.set(false, forKey: "disableSleepDetection")
        }
//
//        switch action {
//        case .lightOn:
//            EV3LightBulb().turnOn()
//        case .lightOff:
//            EV3LightBulb().turnOff()
//        case .acOn:
//            EV3AC().turnOn()
//        case .acOff:
//            EV3AC().turnOff()
//        case .switchOn, .scheduleOn:
//            parseScheduledCommand(resp: resp) { $0.turnOn() }
//        case .switchOff, .scheduleOff:
//            parseScheduledCommand(resp: resp) { $0.turnOff() }
//        }
    }

	func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
		inputBar.inputTextView.text = ""
		self.append(message: text, fromUser: true)
		
		let request = apiAI.textRequest()!
		request.query = [text]
		request.setCompletionBlockSuccess({ request, response in
			let data: Data
			
			if let dict = response as? [String: Any] {
				data = try! JSONSerialization.data(withJSONObject: dict)
			} else {
				data = response as! Data
			}
			
            guard let resp = try? JSONDecoder().decode(ApiAIResponse.self, from: data)
                else { return }

            DispatchQueue.main.async {
                self.parseResponse(resp)
            }
		}) { _, _ in }
		apiAI.enqueue(request)
	}
	
}

extension SallyViewController: MessagesDataSource {
	
	func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
		if message.sender == me {
			return Avatar(image: #imageLiteral(resourceName: "cubeicon"), initals: "K")
		} else {
            return Avatar(image: UIImage(named: "Sally"), initals: "S")
		}
	}
	
	func currentSender() -> Sender {
		return me
	}
	
	func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
	
}

extension SallyViewController: MessagesLayoutDelegate {
	func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return indexPath.section == 0 ? CGSize(width: 0, height: 44) : .zero
	}
	
	func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return indexPath.section == messages.count - 1 ? CGSize(width: 0, height: 16) : .zero
	}
	
	func messageFooterView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageFooterView? {
		return messagesCollectionView.dequeueMessageFooterView(for: indexPath)
//		return MessageFooterView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 44)))
	}
}

extension SallyViewController: MessagesDisplayDelegate {
	
	func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		return .bubbleTail(message.sender == me ? .bottomRight : .bottomLeft, .pointedEdge)
	}
	
}

extension SallyViewController: MessageCellDelegate {
	
	func didSelectURL(_ url: URL) {
		UIApplication.shared.open(url)
	}
	
}
