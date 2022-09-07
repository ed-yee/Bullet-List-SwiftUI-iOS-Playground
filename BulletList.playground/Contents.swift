//: A SwiftUI based Playground for presenting user interface
  
import SwiftUI
import PlaygroundSupport

struct TabOptions {
    var alignment: NSTextAlignment
    var location: CGFloat
}

/// This define a concept of "margin". It is spacing outside of a View.
/// It actually wraps a View with HStack and set the padding values
struct Margin: ViewModifier {
    let margins: EdgeInsets
    
    func body(content: Content) -> some View {
        HStack(alignment: .top, spacing: 0) {
            content
        }.padding(EdgeInsets(top: margins.top,
                             leading: margins.leading,
                             bottom: margins.bottom,
                             trailing: margins.trailing))
    }
}

extension View {
    /// Set margin aginst some of the edges.
    /// - Parameters:
    ///   - top: Top margin in points. Default 0.0
    ///   - right: Right margin in points. Default 0.0
    ///   - bottom: Bottom margin in points. Default 0.0
    ///   - left: Left margin in points. Default 0.0
    /// - Returns: Modified View
    func margin(top: CGFloat = 0.0,
                right: CGFloat = 0.0,
                bottom: CGFloat = 0.0,
                left: CGFloat = 0.0) -> some View {
        modifier(Margin(margins: EdgeInsets(top: top,
                                            leading: left,
                                            bottom: bottom,
                                            trailing: right)))
    }
    
    /// Set vertical and/or horizontal maring
    /// - Parameters:
    ///   - topBottom: Top and bottom margin in points. Default 0.0
    ///   - leftRight: Left and right margin in points. Default 0.0
    /// - Returns: Modified View
    func margin(topBottom: CGFloat = 0.0,
                leftRight: CGFloat = 0.0) -> some View {
        modifier(Margin(margins: EdgeInsets(top: topBottom,
                                            leading: leftRight,
                                            bottom: topBottom,
                                            trailing: leftRight)))
    }
    
    /// Set margin to all sides
    /// - Parameter all: Margin in points. Default 0.0
    /// - Returns: A modified View
    func margin(_ all: CGFloat = 0.0) -> some View {
        modifier(Margin(margins: EdgeInsets(top: all,
                                            leading: all,
                                            bottom: all,
                                            trailing: all)))
    }
    
    /// Set padding to one or more sides
    /// - Parameters:
    ///   - top: Top padding in points. Default 0.0
    ///   - right: Right padding in points. Default 0.0
    ///   - bottom: Bottom padding in points. Default 0.0
    ///   - left: Left padding in points. Default 0.0
    /// - Returns: Modified View
    func padding(top: CGFloat = 0.0,
                right: CGFloat = 0.0,
                bottom: CGFloat = 0.0,
                left: CGFloat = 0.0) -> some View {
        self.padding(EdgeInsets(top: top,
                                leading: left,
                                bottom: bottom,
                                trailing: right))
    }
    
    /// This is similar to padding(_ edges: Edge.Set, _ length: CGFloat? = nil) except this is more specific to top-bottom and left-right paddings.
    /// - Parameters:
    ///   - topBottom: Top and bottom padding in points. Default 0.0
    ///   - leftRight: Left and right padding in points. Default 0.0
    /// - Returns: Modified View
    func padding(topBottom: CGFloat = 0.0,
                 leftRight: CGFloat = 0.0) -> some View {
        self.padding(EdgeInsets(top: topBottom,
                                leading: leftRight,
                                bottom: topBottom,
                                trailing: leftRight))
    }
}

struct MasterPageView: View {
    var sampleData: [String] = [
        "This is list item 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
        "This is list item 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
        "This is list item 3. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
        "This is list item 4. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
    ]

    /// Convert number to Roman numerals
    ///
    /// Source:
    /// Convert numbers to Roman Numerials in Swift, by Eric Callanan
    /// https://swdevnotes.com/swift/2021/convert-numbers-to-roman-numerials-in-swift/
    ///
    /// - Parameter n: Source number
    /// - Returns: Roman numerals
    func romanNumeralFor(_ n:Int) -> String {
        guard n > 0 && n < 4000 else {
            return "Number must be between 1 and 3999"
        }
        
        var returnString = ""
        let arabicNumbers = [1000,  900, 500,  400, 100,   90,  50,   40,  10,    9,   5,    4,  1]
        let romanLetters  = [ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var num = n
        for (ar, rome) in zip(arabicNumbers, romanLetters) {
            let repeats = num / ar
            returnString += String(repeating: rome, count: repeats)
            num = num % ar
        }
        return returnString
    }
    
    /// Generate a list
    /// - Parameter listItemSpacing: LIst item spacing in points. Default 10.0
    /// - Returns: Simple list
    @ViewBuilder func simpleList(listItemSpacing: CGFloat = 10.0) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                Text(data)
            }
        }
        .padding(10)
        .border(.gray, width: 1)
        .margin(top: 0, right: 20, bottom: 0, left: 20)
    }
    
    /// Generate a bullet list
    /// - Parameters:
    ///   - leadIcon: Lead bullet icon. Default •
    ///   - listItemSpacing: Bullet list item spacingi n points. Default 10.0
    /// - Returns: Bullet (unordered) list
    @ViewBuilder func simpleBulletList(leadIcon: String = "•",
                                       listItemSpacing: CGFloat = 10.0) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                Text("\(leadIcon)\t\(data)")
            }
        }
        .padding(10)
        .border(.gray, width: 1)
        .margin(leftRight: 20)
    }
    
    /// Generate aligned bullet list
    /// - Parameters:
    ///   - leadIcon: Lead bullet icon. Default •
    ///   - listItemSpacing: Bullet list item spacing in points. Default 10.0
    ///   - bulletWidth: Bullet width in points. Default 25.0
    /// - Returns: Bullet (unordered) list
    @ViewBuilder func alignedBulletList(leadIcon: String = "•",
                                        listItemSpacing: CGFloat = 10.0,
                                        bulletWidth: CGFloat = 25.0) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(leadIcon)
                        .frame(width: bulletWidth,
                               alignment: .leading)
                    Text(data)
                }
            }
        }
        .padding(10)
        .border(.gray, width: 1)
        .margin(leftRight: 20)
    }
    
    /// Generate numeric bullet list
    /// - Parameters:
    ///   - prefix: Bullet prefix. Default empty string
    ///   - listItemSpacing: Bullet list item spacing in points. Default 10.0
    ///   - bulletWidth: Bullet width in points. Default 30.0
    ///   - alignment: Bullet alignment. Default leading (left)
    /// - Returns: Numeric ordered list
    @ViewBuilder func numericList(prefix: String = "",
                                  listItemSpacing: CGFloat = 10.0,
                                  bulletWidth: CGFloat = 30.0,
                                  alignment: Alignment = .leading) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%d.", prefix, (idx+1))
                    Text(stg)
                        .frame(width: bulletWidth,
                               alignment: alignment)
                    Text(sampleData[idx])
                }
            }
        }
        .padding(10)
        .border(.gray, width: 1)
        .margin(leftRight: 20)
     }
    
    /// Generate Roman numeral bullet list
    /// - Parameters:
    ///   - prefix: Bullet prefix. Default empty string
    ///   - listItemSpacing: Bullet list item spacing in points. Default 10.0
    ///   - bulletWidth: Bullet width in points. Default 30.0
    ///   - alignment: Bullet alignment. Default leading (left)
    /// - Returns: Roman numeral ordered list
    @ViewBuilder func romanNumeralList(prefix: String = "",
                                       listItemSpacing: CGFloat = 10.0,
                                       bulletWidth: CGFloat = 30.0,
                                       alignment: Alignment = .leading) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%@.", prefix, romanNumeralFor(idx+1))
                    Text(stg)
                        .frame(width: bulletWidth,
                               alignment: alignment)
                    Text(sampleData[idx])
                }
            }
        }
        .padding(10)
        .border(.gray, width: 1)
        .margin(leftRight: 20)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading,
                   spacing: 10) {
                Group {
                    Text("Simple list")
                        .font(.title3)
                    
                    simpleList()
                }
                Group {
                    Text("Simple bullet list")
                        .font(.title3)
                        .padding(top: 20)
                    
                    simpleBulletList()

                    Text("Happy face bullet list")
                        .font(.title3)
                        .padding(top:20)
                    
                    simpleBulletList(leadIcon: "😀")
                }
                Group {
                    Text("Properly aligned bullet list")
                        .font(.title3)
                        .padding(top: 20)
                    
                    alignedBulletList()

                    Text("Happy faces bullet list with different indentation")
                        .font(.title3)
                        .padding(top: 20)
                    
                    alignedBulletList(leadIcon: "😀😀", bulletWidth: 50)
                }
                Group {
                    Text("Numeric ordered list")
                        .font(.title3)
                        .padding(top: 20)
                    numericList()
                    
                    Text("Numeric ordered list with prefix")
                        .font(.title3)
                        .padding(top: 20)
                    numericList(prefix: "A.")
                }
                Group {
                    Text("Roman numeral ordered list")
                        .font(.title3)
                        .padding(top: 20)
                    romanNumeralList()
                    
                    Text("Right align lead number ordered list")
                        .font(.title3)
                        .padding(top: 20)
                    romanNumeralList(alignment: .trailing)
                }
                
                

            }
        }
        .frame(width: 375,
               height: 812,
               alignment: .leading)
        .padding(10)
    }
}

struct MasterPage_Preview: PreviewProvider {
    static var previews: some View {
        MasterPageView().previewDevice(PreviewDevice(rawValue: "iPhone 13")).previewDisplayName("iPhone 13")
    }
}

let view = MasterPageView()
//let hostingVC = UIHostingController(rootView: view)
//PlaygroundPage.current.liveView = hostingVC
PlaygroundPage.current.setLiveView(view)
