//
//  Parser.swift
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

import Foundation

/// Parses LaTeX equations.
@available(iOS 16.0, *)
internal struct Parser {
  
  // MARK: Types
  
  /// An equation component.
  struct EquationComponent<T, U> {
    let regex: Regex<T>
    let terminatingRegex: Regex<U>
    let equation: Component.ComponentType
    let open: String
    let close: String
  }
  
  // MARK: Private properties
  
  /// An inline equation component.
  static let inline = EquationComponent(
    regex: #/\$(.+)\$/#,
    terminatingRegex: #/\$/#,
    equation: .inlineEquation,
    open: "$",
    close: "$")
  
  // \( 2x \times 3 = 4 \)
  static let inlineParentheses = EquationComponent(
    regex: #/\\\((.+)\\\)/#,
    terminatingRegex: #/\\\)/#,
    equation: .inlineEquation2,
    open: "\\(",
    close: "\\)")
  
  
  /// An TeX-style block equation component.
  static let tex = EquationComponent(
    regex: #/\$\$\s*(.+)\s*\$\$/#,
    terminatingRegex: #/\$\$/#,
    equation: .texEquation,
    open: "$$",
    close: "$$")
  
  /// A block equation.
  static let block = EquationComponent(
    regex: #/\\\[\s*(.+)\s*\\\]/#,
    terminatingRegex: #/\\\]/#,
    equation: .blockEquation,
    open: "\\[",
    close: "\\]")
  
  /// A named equation component.
  static let named = EquationComponent(
    regex: #/\\begin{equation}\s*(.+)\s*\\end{equation}/#,
    terminatingRegex: #/\\end{equation}/#,
    equation: .namedEquation,
    open: "\\begin{equation}",
    close: "\\end{equation}")
  
  /// A named no number equation component.
  static let namedNoNumber = EquationComponent(
    regex: #/\\begin{equation\*}\s*(.+)\s*\\end{equation\*}/#,
    terminatingRegex: #/\\end{equation\*}/#,
    equation: .namedNoNumberEquation,
    open: "\\begin{equation*}",
    close: "\\end{equation*}")
  
  // Order matters
  static let allEquations: [EquationComponent] = [
    inline,
    inlineParentheses,
    tex,
    block,
    named,
    namedNoNumber
  ]
  
}

// MARK: Static methods
@available(iOS 16.0, *)
extension Parser {
  
  /// Parses the input text for component blocks.
  ///
  /// - Parameters:
  ///   - text: The input text.
  ///   - mode: The rendering mode.
  /// - Returns: An array of component blocks.
  static func parse(_ text: String, mode: LaTeX.ParsingMode) -> [ComponentBlock] {
    let components = mode == .all ? [Component(text: text, type: .inlineEquation)] : parse(text)
    var blocks = [ComponentBlock]()
    var blockComponents = [Component]()
    for component in components {
      if component.type.inline {
        blockComponents.append(component)
      }
      else {
        blocks.append(ComponentBlock(components: blockComponents))
        blocks.append(ComponentBlock(components: [component]))
        blockComponents.removeAll()
      }
    }
    if !blockComponents.isEmpty {
      blocks.append(ComponentBlock(components: blockComponents))
    }
    return blocks
  }
  
  /// Parses an input string for LaTeX components.
  ///
  /// - Parameter input: The input string.
  /// - Returns: An array of LaTeX components.
  static func parse(_ input: String) -> [Component] {
    return parseV2(input)
//    // Get the first match of each each equation type
//    let matchArrays = allEquations.map { equationComponent in
//      let regexMatches = input.matches(of: equationComponent.regex)
//      return regexMatches.map({ (equationComponent, $0) })
//    }
//    
//    let matches = matchArrays.reduce([], +)
//    
//    // Filter the matches
//    let filteredMatches = matches.filter { match in
//      // We only want matches with ranges
//      let range = match.1.range
//      
//      // Make sure the inner component is non-empty
//      let text = Component(text: String(input[range]), type: match.0.equation).text
//      guard !text.isEmpty else {
//        return false
//      }
//      
//      // Make sure the starting terminator isn't escaped
//      guard range.lowerBound >= input.startIndex else {
//        return false
//      }
//      if range.lowerBound > input.startIndex, input[input.index(before: range.lowerBound)] == "\\" {
//        return false
//      }
//      
//      // Make sure the ending terminator isn't escaped
//      let endingTerminatorStartIndex = input.index(range.upperBound, offsetBy: -match.0.equation.rightTerminator.count)
//      guard endingTerminatorStartIndex >= input.startIndex else {
//        return false
//      }
//      if endingTerminatorStartIndex > input.startIndex, input[input.index(before: endingTerminatorStartIndex)] == "\\" {
//        return false
//      }
//      
//      // Make sure the range isn't in any other range.
//      // I.e. we only use top-level matches.
//      for subMatch in matches {
//        let subRange = subMatch.1.range
//        
//        if range.isSubrange(of: subRange) {
//          return false
//        }
//      }
//      
//      // The component has content and isn't escaped
//      return true
//    }
//    
//    // Get the first matched equation
//    guard let smallestMatch = filteredMatches.min(by: { $0.1.range.lowerBound < $1.1.range.lowerBound }) else {
//      return input.isEmpty ? [] : [Component(text: input, type: .text)]
//    }
//
//    // If the equation supports recursion, then we'll need to find the last
//    // match of its terminating regex component.
//    let equationRange: Range<String.Index> = smallestMatch.1.range
//
//    // We got our equation range, so lets return the components.
//    let stringBeforeEquation = String(input[..<equationRange.lowerBound])
//    let equationString = String(input[equationRange])
//    let remainingString = String(input[equationRange.upperBound...])
//    var components = [Component]()
//    if !stringBeforeEquation.isEmpty {
//      components.append(Component(text: stringBeforeEquation, type: .text))
//    }
//    components.append(Component(text: equationString, type: smallestMatch.0.equation))
//    if remainingString.isEmpty {
//      return components
//    }
//    else {
//      return components + parse(remainingString)
//    }
  }
  
  private static func parseV2(_ input: String) -> [Component] {
    var components: [Component] = [];
   
    let chars = Array(input)
    
    var text = "";
    
    func popUntil(startIndex: Int, stopChars: String, chars: [Character], checkEscaping: Bool) -> Int {
      if startIndex >= chars.count {
        return -1;
      }
      for i in startIndex..<(chars.count - stopChars.count + 1) {
        if stopChars == String(chars[i..<i+stopChars.count]) {
          if checkEscaping {
            if i > startIndex && chars[i - 1] != "\\" {
              return i + stopChars.count
            }
          } else {
            return i + stopChars.count
          }
        }
      }
      
      return -1;
    }
    
    func starting(startIndex: Int, what: String, chars: [Character]) -> Bool {
      if startIndex >= chars.count {
        return false;
      }
      
      if startIndex + what.count > chars.count {
        return false;
      }
      
      return what == String(chars[startIndex..<startIndex+what.count])
    }
    
    func commitText() {
      if !text.isEmpty {
        components.append(Component(text: text, type: .text))
      }
      text = "";
    }
    
    var i = 0;
    while i < chars.count {
      let current = chars[i];
      let next = i + 1 < chars.count ? chars[i + 1] : nil
      
      if current == "\\" && next == "$" {
        text += "\\$";
        i += 2;
        
        // \$$TeX$$
        let nextNext = i  < chars.count ? chars[i] : nil
        if nextNext == "$" {
          i += 1;
          text += "$";
        }
        
      } else if current == "\\" && next == "\\" {
        text += "\\\\";
        i += 2;
        
      } else if current == "$" && next == "$" {
        
        i += 2;
        
        let end = popUntil(startIndex: i, stopChars: "$$", chars: chars, checkEscaping: true);
        if end > 0 {
          commitText()
          components.append(Component(text: String(chars[i..<end]), type: .texEquation))
          i = end;
        } else {
          text += "$$";
        }
        
        
      } else if current == "$" {
        i += 1;
        let end = popUntil(startIndex: i, stopChars: "$", chars: chars, checkEscaping: true);
        if end > 0 {
          commitText()
          components.append(Component(text: String(chars[i..<end]), type: .inlineEquation))
          i = end;
        } else {
          text += "$"
        }
      }
      else {
        var foundPattern = false;
        for pattern in [inlineParentheses, block, named, namedNoNumber] {
          if starting(startIndex: i, what: pattern.open, chars: chars) {
            i += pattern.open.count;
            let end = popUntil(startIndex: i, stopChars: pattern.close, chars: chars, checkEscaping: true);
            if end > 0 {
              commitText()
              components.append(Component(text: String(chars[i..<end]), type: pattern.equation))
              i = end;
            } else {
              text += pattern.open;
            }
            foundPattern = true;
            break;
          }
        }
        
        if !foundPattern {
          text.append(current);
          i += 1;
        }
      }
    }
    
    
    commitText()
    
    // quick fix for case that mathjax does not render multlines tex $$1 + 2 \\ 2 + 3$$
    // it wont work for all cases, just a quick hack
    for (index, component) in components.enumerated() {
      if (component.type == .texEquation || component.type == .blockEquation)
          && component.text.contains("\\\\")
          && !component.text.contains("begin")
          && !component.text.contains("\\displaylines") {
        
        print(component.type, component.text)
        let newComponent: Component = .init(text: "\\displaylines{\n\(component.text)\n}", type: component.type)
        components[index] = newComponent;
      }
    }
    
    return components;
  }
  
  
  
}
