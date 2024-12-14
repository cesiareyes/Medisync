//
//  MessagesView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct MessagesView: View {
    @ObservedObject var messagesViewModel: MessagesViewModel
    @State private var messageContent: String = ""
    @State private var selectedReceiver: String? = nil
    @State private var messageSubject: String = "General"
    @State private var isMessageFormVisible: Bool = false
    
    var availableUsers: [User]

    var body: some View {
        VStack {
            if !isMessageFormVisible && selectedReceiver == nil{
                Button(action: {
                    isMessageFormVisible.toggle()
                }) {
                    HStack {
                        Text("New Message")
                            .font(.headline)
                        Image(systemName: "square.and.pencil")
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.purple)
                    .cornerRadius(8)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
            if isMessageFormVisible {
                VStack {
                    HStack {
                        Button(action: {
                            isMessageFormVisible = false
                            clearMessageForm()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.purple)
                                    .clipShape(Circle())
                                Text("Back")
                                    .font(.headline)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Text("Select Receiver")
                        Spacer()
                        ReceiverPicker(selectedReceiver: $selectedReceiver, availableUsers: availableUsers)
                    }
                    
                    HStack {
                        Text("Select Subject")
                        Spacer()
                        SubjectPicker(messageSubject: $messageSubject)
                    }
                    Spacer()
                    
                    MessageInputView(messageContent: $messageContent, sendMessage: {
                        guard let receiver = selectedReceiver else { return }
                        let sender = messagesViewModel.currentUserName
                        let subject = messageSubject
                        let content = messageContent
                        
                        messagesViewModel.sendMessage(from: sender, to: receiver, subject: subject, content: content)
                        // After sending, hide the form
                        isMessageFormVisible = false
                        clearMessageForm()
                    })
                }
                .padding()
            } else {
                if messagesViewModel.messages.isEmpty {
                    Text("No Messages")
                        .font(.headline)
                        .padding()
                } else {
                    if selectedReceiver == nil {
                        MessagesListView(messages: messagesViewModel.messages, currentUserName: messagesViewModel.currentUserName, selectedReceiver: $selectedReceiver)
                    } else {
                        VStack {
                            HStack {
                                Button(action: {
                                    selectedReceiver = nil // Deselect the conversation
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.left")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.purple)
                                            .clipShape(Circle())
                                        Text("Back")
                                            .font(.headline)
                                    }
                                    .padding()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            ConversationView(
                                messagesViewModel: messagesViewModel,
                                messages: messagesViewModel.messages,
                                currentUserName: messagesViewModel.currentUserName,
                                messageContent: $messageContent,
                                selectedReceiver: selectedReceiver!
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    private func clearMessageForm() {
        messageContent = ""
        selectedReceiver = nil  // Make sure to set it to nil
        messageSubject = "General"
    }

    private func fetchData() {
        AuthenticationManager.shared.fetchUserName { name in
            if let name = name {
                messagesViewModel.currentUserName = name
                messagesViewModel.fetchMessages()
            }
        }
        messagesViewModel.fetchUsers()
    }

}
