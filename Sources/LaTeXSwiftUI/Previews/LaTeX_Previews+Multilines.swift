//
//  LaTeX_Previews+Color.swift
//  LaTeXSwiftUI
//
//  Copyright (c) 2023 Colin Campbell
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import SwiftUI

@available(iOS 16.0, *)
struct LaTeX_Previews_Multilines: PreviewProvider {
  
  static var previews: some View {
    VStack(alignment: .leading) {
      
      
      LaTeX(
        #"""
        \[
        C = 2(l + w) \\
        
        C = 2(0,095 + 5,4) \\
        
        C = 2 \times 5,495 \\
        
        C = 10,99 \, \text{m}
        \]
        """#
      )
      .font(.title)
      .parsingMode(.onlyEquations)
      .blockMode(.blockText)
      
    }
    .previewLayout(.sizeThatFits)
    .previewDisplayName("Hello, LaTeX!")
    .padding(.horizontal)
    .frame(minWidth: 300, minHeight: 400)
  }
  
}
