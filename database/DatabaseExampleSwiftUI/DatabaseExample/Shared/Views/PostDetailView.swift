//
//  Copyright (c) 2021 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI

struct PostDetailView: View {
  @ObservedObject var post: PostViewModel
  @State private var comment: String = ""
  var screenWidth = UIScreen.main.bounds.width

  var body: some View {
    VStack {
      // post card displaying post details
      VStack(alignment: .leading) {
        HStack(spacing: 1) {
          Image(systemName: "person.fill")
          Text(post.author)
          Spacer()
          Image(systemName: "star")
          Text("\(post.starCount)")
        }
        Text(post.title)
          .font(.system(size: 27))
          .bold()
        Text(post.body)
      }
      .padding()
      .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
      // comments for the particular post
      List {
        ForEach(post.comments) { comment in
          VStack(alignment: .leading) {
            HStack(spacing: 1) {
              Image(systemName: "person")
              Text(comment.author)
            }
            Text(comment.text)
              .font(.body)
          }
          .padding()
        }
      }
      // textfield for user entering comments
      HStack {
        TextField("Comment", text: $comment)
          .padding()
          .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
        Button(action: {
          post.didTapSendButton(commentField: comment)
          comment = ""
          #if canImport(UIKit)
            hideKeyboard()
          #endif
        }) {
          Text("Send")
        }
      }
      .frame(
        width: screenWidth * 0.85,
        alignment: .center
      )
      Spacer()
        .frame(idealHeight: 10)
        .fixedSize()
    }
    .padding()
    .frame(
      width: screenWidth * 0.9,
      alignment: .center
    )
    .onAppear {
      post.fetchComments()
    }
    .onDisappear {
      post.onDetailViewDisappear()
    }
    .navigationBarTitle(post.title)
  }
}

#if canImport(UIKit)
  extension View {
    func hideKeyboard() {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
      )
    }
  }
#endif

struct PostDetailView_Previews: PreviewProvider {
  static var examplePost = PostViewModel(
    id: "postID",
    uid: "userID",
    author: "userEmail",
    title: "postTitle",
    body: "postBody"
  )
  static var previews: some View {
    PostDetailView(post: examplePost)
  }
}
