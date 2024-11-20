//
//  LaTeX_Previews+UnicodeText.swift
//  LaTeXSwiftUI
//
//  Created by duy on 21/11/24.
//





import SwiftUI

@available(iOS 16.0, *)
struct LaTeX_Previews_UnicodeLatex: PreviewProvider {
  
  static var previews: some View {
    
    LaTeX(
        #"""
        
        \[ \text{Quá trình đi được từ A} = 36 \times 2 = 72 \text{ km} \]
        
        5. Tính quãng đường ô tô từ B đã đi được: 
        
        \[ \text{Quá trình đi được từ B} = 45 \times 2 = 90 \text{ km} \] 
        
        6. Tổng quãng đường là 72 km + 90 km = 162 km. 
        
        7. Quá trình ô tô từ A gặp ô tô từ B ở cách A:
        
        \[ 36 \times 2 = 72 \text{ km} \] 
        
        Vậy có 2 ô tô gặp nhau sau 2 giờ ở điểm quãng đường 108 km từ A.  
        """#
    )
    .font(.body)
    .parsingMode(.onlyEquations)
    
    
    
  }
}
