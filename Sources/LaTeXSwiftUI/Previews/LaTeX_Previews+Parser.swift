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
struct LaTeX_Previews_Block: PreviewProvider {
  
  static var previews: some View {
    VStack(alignment: .leading) {
      
      
      LaTeX("Euler's identity is $e^{i\\pi}+1=0$.")
        .font(.body)
        .parsingMode(.onlyEquations)
      
      
      LaTeX("Inline latex $x^2 + 2x - 3 = -\\frac{1}{2}$")
        .font(.body)
      
      LaTeX("Inline latex 2 \\(x^2 + 2x - 3 = -\\frac{1}{2} \\)")
        .font(.body)
      
      LaTeX("Block latex $$x^2 + 2x - 3 = -\\frac{1}{2}$$")
        .font(.body)
      
      LaTeX("Block latex 2 \\[ x^2 + 2x - 3 = -\\frac{1}{2} \\]")
        .font(.body)
      
      
      LaTeX(
        #"""
        \begin{equation}
          a^2 + b^2 = c^2 \\
          \int_a^b f(x) \, dx = F(b) - F(a) \\
          \lim_{x \to 0} \frac{\sin(x)}{x} = 1
        \end{equation}
        """#
      )
      .font(.system(size: 30))
      
      LaTeX(
        #"""
        $$
        \begin{matrix} 
        1 & 2 & 3 \\
        4 & 5 & 6 \\
        7 & 8 & 9
        \end{matrix}
        $$
        """#
      )
      .errorMode(.error)
      
      LaTeX(
        #"""
        $$
        \begin{align}
        a^2 + b^2 &= c^2 \\
        \int_a^b f(x) \, dx &= F(b) - F(a) \\
        \lim_{x \to 0} \frac{\sin(x)}{x} &= 1
        \end{align}
        $$
        """#
      )
      
      LaTeX(
        #"""
        \[
        u_3 = u_1 + 2d \\
        10 = 4 + 2d\\
        2d = 6 \\
        d = 3
        \]
        """#
      )
      
    }
    .previewLayout(.sizeThatFits)
    .previewDisplayName("Hello, LaTeX!")
    .padding(.horizontal)
  }
  
}
