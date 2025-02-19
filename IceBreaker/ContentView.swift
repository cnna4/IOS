//
//  ContentView.swift
//
//
//  Created by Chidi Nna on 1/28/25.
//

import SwiftUI
import FirebaseFirestore


struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtPrefName: String = ""
    @State var txtAnswer: String = ""
    @State var txtQuestion: String = ""
    
    @State var questions = [Question]()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Icebreaker")
                .bold()
                .font(.system(size: 41))
            Text("Made By Chidi Nna")
            Spacer()
            TextField("First Name", text: $txtFirstName)
            TextField("Last Name", text: $txtLastName)
            TextField("Preferred Name", text: $txtPrefName)
            Button(action: {
                setRandomQuestion()
            }){
                Text("Get a new random question")
                    .font(.system(size:28))
            }
            
                Text(txtQuestion)
            TextField("Answer", text: $txtAnswer)
            Button(action: {
                writeStudentToFirebase()
                resetTxtFields()
            }){
                Text("Submit")
                    .font(.system(size:28))
            }
            Spacer()
        }
        .padding(30)
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .onAppear(){
            getQuestionsFromFirebase()
            fetchAllQuestions()
        }
        
    }
    func setRandomQuestion(){
        let newQuestion = questions.randomElement()?.text
        if(newQuestion != nil){
            self.txtQuestion = newQuestion!
        }
    }
    
    func getQuestionsFromFirebase(){
        db.collection("questions")
            .getDocuments(){ (querySnapshot,err) in
                if let err = err { // error is not nil
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        if let question = Question(id: document.documentID, data: document.data()){
                            print("Question ID = \(question.id), text = \(question.text)")
                            self.questions.append(question)
                        }
                    }
                }
            }
    }
    
    func fetchAllQuestions() {
        db.collection("students").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                print("Fetched \(querySnapshot.documents.count) documents.")
                
                for document in querySnapshot.documents {
                    let data = document.data()
                    print("Document ID: \(document.documentID), Data: \(data)")
                }
            } else {
                print("No documents found in 'questions' collection.")
            }
        }
    }
    
    func resetTxtFields(){
        txtFirstName = ""
        txtLastName = ""
        txtPrefName = ""
        txtAnswer = ""
        txtQuestion = ""
    }
    
    func writeStudentToFirebase(){
        let data = [
            "first_name" : txtFirstName,
            "last_name" : txtLastName,
            "pref_name" : txtPrefName,
            "question" : txtQuestion,
            "answer" : txtAnswer,
            "class" : "iOS-Spring2025",
        ] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("students")
            .addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with the ID of: \(ref!.documentID)")
                }
            }
    }
}



#Preview {
    ContentView()
}
