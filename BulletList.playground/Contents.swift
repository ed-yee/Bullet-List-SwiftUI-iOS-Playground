//: A SwiftUI based Playground for presenting user interface
  
import SwiftUI
import PlaygroundSupport

extension View {
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

protocol BaseView {
    var sampleData: [String] { get }
}

extension BaseView {
    var sampleData: [String] {
        get {
            var array: [String] = []
            for idx in stride(from: 1, to: 6, by: 1) {
                array.append("This is list item \(idx). Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.")
            }
            return array
        }
    }
    
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
    @ViewBuilder func simpleList(listItemSpacing: CGFloat = 10.0,
                                 withBorder: Bool = false,
                                 captionInfiniteWidth ciw: Bool = true
    ) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                Text(data)
                    .frame(maxWidth: (ciw ? .infinity : nil),
                           alignment: .leading)
                    .border(.orange, width: (withBorder ? 1 : 0))
            }
        }
        .padding(1)
        .border(.green, width: (withBorder ? 1 : 0))
    }
    
    
    
    /// Generate a bullet list
    /// - Parameters:
    ///   - leadIcon: Lead bullet icon. Default •
    ///   - listItemSpacing: Bullet list item spacingi n points. Default 10.0
    /// - Returns: Bullet (unordered) list
    @ViewBuilder func simpleBulletList(leadIcon: String = "•",
                                       listItemSpacing: CGFloat = 10.0,
                                       withBorder: Bool = false,
                                       captionInfiniteWidth ciw: Bool = true
    ) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                Text("\(leadIcon)\t\(data)")
                    .frame(maxWidth: (ciw ? .infinity : nil),
                           alignment: .leading)
                    .border(.orange, width: (withBorder ? 1 : 0))
            }
        }
        .padding(1)
        .border(.green, width: (withBorder ? 1 : 0))
    }
    
    /// Generate aligned bullet list
    /// - Parameters:
    ///   - leadIcon: Lead bullet icon. Default •
    ///   - listItemSpacing: Bullet list item spacing in points. Default 10.0
    ///   - bulletWidth: Bullet width in points. Default 25.0
    /// - Returns: Bullet (unordered) list
    @ViewBuilder func bulletList(leadIcon: String = "•",
                                 listItemSpacing: CGFloat = 10.0,
                                 bulletWidth: CGFloat = 25.0,
                                 withBorder: Bool = false,
                                 captionInfiniteWidth ciw: Bool = true
    ) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(leadIcon)
                        .frame(width: bulletWidth,
                               alignment: .leading)
                        .border(Color.blue,
                                width: (withBorder ? 1 : 0))
                    Text(data)
                        .frame(maxWidth: (ciw ? .infinity : nil),
                               alignment: .leading)
                        .border(Color.orange,
                                width: (withBorder ? 1 : 0))
                }
            }
        }
        .padding(1)
        .border(.green, width: (withBorder ? 1 : 0))
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
                                  alignment: Alignment = .leading,
                                  withBorder: Bool = false,
                                  captionInfiniteWidth ciw: Bool = true
    ) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%d.", prefix, (idx+1))
                    Text(stg)
                        .frame(width: bulletWidth,
                               alignment: alignment)
                        .border(Color.blue,
                                width: (withBorder ? 1 : 0))
                    Text(sampleData[idx])
                        .frame(maxWidth: (ciw ? .infinity : nil),
                               alignment: .leading)
                        .border(Color.orange,
                                width: (withBorder ? 1 : 0))
                }
            }
        }
        .padding(1)
        .border(.green, width: (withBorder ? 1 : 0))
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
                                       alignment: Alignment = .leading,
                                       withBorder: Bool = false,
                                       captionInfiniteWidth ciw: Bool = true
    ) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(sampleData.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%@.", prefix, romanNumeralFor(idx+1))
                    Text(stg)
                        .frame(width: bulletWidth,
                               alignment: alignment)
                        .border(Color.blue,
                                width: (withBorder ? 1 : 0))
                    Text(sampleData[idx])
                        .frame(maxWidth: (ciw ? .infinity : nil),
                               alignment: .leading)
                        .border(Color.orange,
                                width: (withBorder ? 1 : 0))
                }
            }
        }
        .padding(1)
        .border(.green, width: (withBorder ? 1 : 0))
    }

}

struct SimpleList: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Simple list")
            .font(.title3)
            .underline()

        simpleList(withBorder: withBorder,
                   captionInfiniteWidth: textInfiniteWidth)
    }
}

struct SimpleBulletList: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Simple bullet list")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        simpleBulletList(withBorder: withBorder,
                         captionInfiniteWidth: textInfiniteWidth)
    }
}

struct HappyFaceBulletList: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Happy face bullet list")
            .font(.title3)
            .underline()
            .padding(top:20)
        
        simpleBulletList(leadIcon: "😀",
                         withBorder: withBorder,
                         captionInfiniteWidth: textInfiniteWidth)
    }
}

struct AlignedBulletList1: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Properly aligned bullet list")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        bulletList(withBorder: withBorder,
                   captionInfiniteWidth: textInfiniteWidth)
    }
}

struct AlignedBulletList2: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Happy faces bullet list with different indentation")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        bulletList(leadIcon: "😀😀",
                   bulletWidth: 50,
                   withBorder: withBorder,
                   captionInfiniteWidth: textInfiniteWidth)
    }
}

struct NumericList1: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Numeric ordered list")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        numericList(withBorder: withBorder,
                    captionInfiniteWidth: textInfiniteWidth)
    }
}

struct NumericList2: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Numeric ordered list with prefix")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        numericList(prefix: "A.",
                    withBorder: withBorder,
                    captionInfiniteWidth: textInfiniteWidth)
    }
}

struct RomanNumeralList1: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Roman numeral ordered list")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        romanNumeralList(withBorder: withBorder,
                         captionInfiniteWidth: textInfiniteWidth)
    }
}

struct RomanNumeralList2: View, BaseView {
    var withBorder: Bool
    var textInfiniteWidth: Bool

    init(withBorder: Bool = false,
         setTextToInfiniteWidth: Bool = true) {
        self.withBorder = withBorder
        self.textInfiniteWidth = setTextToInfiniteWidth
    }

    var body: some View {
        Text("Right align lead number ordered list")
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        romanNumeralList(alignment: .trailing,
                         withBorder: withBorder,
                         captionInfiniteWidth: textInfiniteWidth)
    }
}

struct MasterPageView: View {
    @State var withBorder: Bool = false
    @State var toInfinity: Bool = true
    
    var body: some View {
        Group {
            VStack {
                Toggle("Show border", isOn: $withBorder)
                Toggle("Set Text maxWidth to infinity", isOn: $toInfinity)
            }
            .padding(10)
            .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.65, alpha: 1)))

            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading,
                       spacing: 10) {
                    Group {
                        SimpleList(withBorder: withBorder,
                                   setTextToInfiniteWidth: toInfinity)
                    }
                    Group {
                        SimpleBulletList(withBorder: withBorder,
                                         setTextToInfiniteWidth: toInfinity)
                        HappyFaceBulletList(withBorder: withBorder,
                                            setTextToInfiniteWidth: toInfinity)
                    }
                    Group {
                        AlignedBulletList1(withBorder: withBorder,
                                           setTextToInfiniteWidth: toInfinity)
                        AlignedBulletList2(withBorder: withBorder,
                                           setTextToInfiniteWidth: toInfinity)
                    }
                    Group {
                        NumericList1(withBorder: withBorder,
                                     setTextToInfiniteWidth: toInfinity)
                        NumericList2(withBorder: withBorder,
                                     setTextToInfiniteWidth: toInfinity)
                    }
                    Group {
                        RomanNumeralList1(withBorder: withBorder,
                                          setTextToInfiniteWidth: toInfinity)
                        RomanNumeralList2(withBorder: withBorder,
                                          setTextToInfiniteWidth: toInfinity)
                    }
                }
            }
            .frame(width: 292.5, // 390 pixels
                   height: 633, // 844 pixels
                   alignment: .leading)
            .padding(10)

        }
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
