//: A SwiftUI based Playground for presenting user interface
  
import SwiftUI
import UIKit
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


/// An implementation of bullet item using UIKit's UILabel.
///
/// This implementation utilize NSMutableAttributedString and NSMutableParagraphStyle
/// to create a hanging-paragraph style. This allows customizable bullet width.
///
/// Disclaimer: Part of the solution comes from StackOverflow.
/// See: https://stackoverflow.com/a/62788230
struct UIKitBulletItem: View {
    var bullet: String = "•"
    var bulletWidth: CGFloat?
    var bulletAlignment: NSTextAlignment?
    var content: String
    @State private var height: CGFloat = .zero
    
    private func bulletItem(bullet: String,
                            bulletWidth: CGFloat,
                            bulletAlignment: NSTextAlignment = .left,
                            content: String) -> NSAttributedString {
        
        var tabStops: [NSTextTab] {
            if bulletAlignment == .right {
                return [
                    NSTextTab(textAlignment: .right, location: bulletWidth - 10),
                    NSTextTab(textAlignment: .left, location: bulletWidth)
                ]
            } else {
                return [
                    NSTextTab(textAlignment: .left, location: bulletWidth)
                ]
            }
        }
        
        var formatPattern: String {
            if bulletAlignment == .right {
                return "\t%@\t%@"
            } else {
                return "%@\t%@"
            }
        }
        
        // Hanging paragraph style
        let hangingIndent = NSMutableParagraphStyle()
        hangingIndent.headIndent = bulletWidth
        hangingIndent.firstLineHeadIndent = -bulletWidth
        hangingIndent.tabStops = tabStops
        
        return NSAttributedString(string: String(format: formatPattern, bullet, content),
                                  attributes: [
                                    .paragraphStyle: hangingIndent
                                  ])
    }

    var body: some View {
        UIKitText(attributedString: bulletItem(bullet: bullet,
                                               bulletWidth: bulletWidth ?? 25.0,
                                               bulletAlignment: bulletAlignment ?? .left,
                                               content: content),
                  dynamicHeight: $height)
        .frame(minHeight: height)
    }
    
    struct UIKitText: UIViewRepresentable {
        typealias UIViewType = UILabel
        var attributedString: NSAttributedString
        @Binding var dynamicHeight: CGFloat
        
        func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
            let lbl = UILabel()
            lbl.numberOfLines = 0
            lbl.lineBreakMode = .byWordWrapping
            lbl.setContentCompressionResistancePriority(.defaultLow,
                                                        for: .horizontal)
            
            return lbl
        }
        
        func updateUIView(_ uiView: UIViewType,
                          context: UIViewRepresentableContext<Self>) {
            // Attributed text may get updated. The height of the UILabel needs to
            // be recalculated.
            uiView.attributedText = attributedString

            DispatchQueue.main.async {
                dynamicHeight = uiView.sizeThatFits(
                    CGSize(width: uiView.bounds.width,
                           height: CGFloat.greatestFiniteMagnitude)
                ).height
            }
        }
    }
}

// -----------------------------------------------

struct SimpleList: View, ListExtension {
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var contentFrameMaxWidth: CGFloat? = .infinity
    var contentFrameAlignment: Alignment = .leading
    var borderWidth: CGFloat = 0.0
    
    var body: some View {
        simpleList(listItems,
                   listItemSpacing: listItemSpacing,
                   contentFrameMaxWidth: contentFrameMaxWidth,
                   contentFrameAlignment: contentFrameAlignment,
                   borderWidth: borderWidth)
    }
}

struct BulletList: View, ListExtension {
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: String = "•"
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    var contentFrameMaxWidth: CGFloat? = .infinity
    var contentFrameAlignment: Alignment = .leading
    var borderWidth: CGFloat = 0.0

    var body: some View {
        bulletList(listItems,
                   listItemSpacing: listItemSpacing,
                   bullet: bullet,
                   bulletWidth: bulletWidth,
                   bulletAlignment: bulletAlignment,
                   contentFrameMaxWidth: contentFrameMaxWidth,
                   contentFrameAlignment: contentFrameAlignment,
                   borderWidth: borderWidth)
    }
}

struct OrderedList: View, ListExtension {
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var prefix: String = ""
    var toNumber: ((Int) -> String) = { "\($0 + 1)" }
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    var contentFrameMaxWidth: CGFloat? = .infinity
    var contentFrameAlignment: Alignment = .leading
    var borderWidth: CGFloat = 0.0
    
    var body: some View {
        orderedList(listItems,
                    listItemSpacing: listItemSpacing,
                    prefix: prefix,
                    toNumber: toNumber,
                    bulletWidth: bulletWidth,
                    bulletAlignment: bulletAlignment,
                    contentFrameMaxWidth: contentFrameMaxWidth,
                    contentFrameAlignment: contentFrameAlignment,
                    borderWidth: borderWidth)
    }
}

struct UIKitList: View, ListExtension {
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: ((Int) -> String) = { _ in "•" }
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: NSTextAlignment?
    
    var body: some View {
        uikitList(listItems,
                  listItemSpacing: listItemSpacing,
                  bullet: bullet,
                  bulletWidth: bulletWidth,
                  bulletAlignment: bulletAlignment)
    }
}

protocol ListExtension {

}
extension ListExtension {
    /// Generate a simple list
    /// - Parameters:
    ///   - listItems: List items
    ///   - listItemSpacing: List items spacing. Nullable
    ///   - contentFrameMaxWidth: List item text frame max width. Nullable. Default to .infinity
    ///   - contentFrameAlignment: List item text frame alignment. Default is .leading
    ///   - borderWidth: Border width. Default is 0.0
    /// - Returns: A list as SwiftUI View
    @ViewBuilder func simpleList(_ listItems: [String],
                                 listItemSpacing: CGFloat? = nil,
                                 contentFrameMaxWidth: CGFloat? = .infinity,
                                 contentFrameAlignment: Alignment = .leading,
                                 borderWidth: CGFloat = 0.0) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems, id: \.self) { data in
                Text(data)
                    .frame(maxWidth: contentFrameMaxWidth,
                           alignment: contentFrameAlignment)
                    .border(.orange, width: borderWidth)
            }
        }
        .padding(2)
        .border(.green, width: borderWidth)
    }
    
    /// Generate a bullet list
    /// - Parameters:
    ///   - listItems: List items
    ///   - listItemSpacing: List items spacing. Nullable
    ///   - bullet: Bullet icon. Default is "•"
    ///   - bulletWidth: Bullet width. Nullable. Default is 25.0pt
    ///   - bulletAlignment: Bullet alinment. Nullable. Default is .leading
    ///   - contentFrameMaxWidth: List item text frame max width. Nullable. Default to .infinity
    ///   - contentFrameAlignment: List item text frame alignment. Default is .leading
    ///   - borderWidth: Border width. Default is 0.0
    /// - Returns: A bullet list as SwiftUI View
    @ViewBuilder func bulletList(_ listItems: [String],
                                 listItemSpacing: CGFloat? = nil,
                                 bullet: String = "•",
                                 bulletWidth: CGFloat? = nil,
                                 bulletAlignment: Alignment = .leading,
                                 contentFrameMaxWidth: CGFloat? = .infinity,
                                 contentFrameAlignment: Alignment = .leading,
                                 borderWidth: CGFloat = 0.0) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(bullet)
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                        .border(Color.blue,
                                width: borderWidth)
                    Text(data)
                        .frame(maxWidth: contentFrameMaxWidth,
                               alignment: contentFrameAlignment)
                        .border(Color.orange,
                                width: borderWidth)
                }
            }
        }
        .padding(2)
        .border(.green, width: borderWidth)
    }
    
    /// Generate an ordered list
    /// - Parameters:
    ///   - listItems: List items
    ///   - listItemSpacing: List items spacing. Nullable
    ///   - prefix: Bullet prefix
    ///   - toNumber: Convert list item array index to a displayable value. Default is index+1
    ///   - bulletWidth: Bullet width. Nullable. Default is 25.0pt
    ///   - bulletAlignment: Bullet alinment. Nullable. Default is .leading
    ///   - contentFrameMaxWidth: List item text frame max width. Nullable. Default to .infinity
    ///   - contentFrameAlignment: List item text frame alignment. Default is .leading
    ///   - borderWidth: Border width. Default is 0.0
    /// - Returns: An ordered list as SwiftUI View
    @ViewBuilder func orderedList(_ listItems: [String],
                                  listItemSpacing: CGFloat? = nil,
                                  prefix: String = "",
                                  toNumber: (@escaping (Int) -> String) = { "\($0 + 1)" },
                                  bulletWidth: CGFloat? = nil,
                                  bulletAlignment: Alignment = .leading,
                                  contentFrameMaxWidth: CGFloat? = .infinity,
                                  contentFrameAlignment: Alignment = .leading,
                                  borderWidth: CGFloat = 0.0) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%@.", prefix, toNumber(idx))
                    Text(stg)
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                        .border(Color.blue,
                                width: borderWidth)
                    Text(listItems[idx])
                        .frame(maxWidth: contentFrameMaxWidth,
                               alignment: contentFrameAlignment)
                        .border(Color.orange,
                                width: borderWidth)
                }
            }
        }
        .padding(2)
        .border(.green, width: borderWidth)
    }
    
    /// Generate a UIKit list
    /// - Parameters:
    ///   - listItems: List items
    ///   - listItemSpacing: List items spacing. Nullable
    ///   - bullet: A bullet closure. Default return value is "•"
    ///   - bulletWidth: Bullet width. Nullable. Default to 25.0pt
    ///   - bulletAlignment: Bullet alignment. Nullable. Default is .left
    /// - Returns: A bullet or ordered list as SwiftUI View
    @ViewBuilder func uikitList(_ listItems: [String],
                                listItemSpacing: CGFloat? = nil,
                                bullet: (@escaping (Int) -> String) = { _ in "•" },
                                bulletWidth: CGFloat? = nil,
                                bulletAlignment: NSTextAlignment?) -> some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems.indices, id: \.self) { idx in
                UIKitBulletItem(bullet: bullet(idx),
                                bulletWidth: bulletWidth,
                                bulletAlignment: bulletAlignment,
                                content: listItems[idx])
            }
        }
    }
}

extension MasterPageView {
    /// Heading 1
    /// - Parameter content: Content
    /// - Returns: A first-level heading in SwiftUI View
    @ViewBuilder func heading1(_ content: String) -> some View {
        Text(content).font(.title).bold().padding(top: 20, bottom: 5)
    }
    
    /// Heading 2
    /// - Parameter content: Content
    /// - Returns: A second-level heading in SwiftUI View
    @ViewBuilder func heading2(_ content: String) -> some View {
        Text(content).font(.title2).underline().padding(top: 20, bottom: 5)
    }
    
    /// Heading 3
    /// - Parameter content: Content
    /// - Returns: A third-level heading in SwiftUI View
    @ViewBuilder func heading3(_ content: String) -> some View {
        Text(content).font(.title3).italic().padding(top: 20, bottom: 5)
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
}

extension MasterPageView {
    var data1: [String] {
        return ["Item 1", "Item #2", "The third item"]
    }
    
    var data2: [String] {
        var array: [String] = []
        for idx in stride(from: 1, to: 6, by: 1) {
            array.append("This is list item \(idx). Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.")
        }
        return array
    }
    
    var data3: [String] {
        return [
            "Short item",
            "Long item. With a few more words",
            "Very long item. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean varius."
        ]
    }
}

struct MasterPageView: View {
    @State var withBorder: Bool = false
    @State var toInfinity: Bool = true
    @State var alignLeft: Bool = true
    
    @State var showOptionsSheet: Bool = false
    
    var borderWidth: CGFloat {
        get {
            return withBorder ? 1 : 0
        }
    }
    
    var textFrameMaxWidth: CGFloat? {
        get {
            return toInfinity ? .infinity : nil
        }
    }
    
    var textFrameAlignment: Alignment {
        get {
            return alignLeft ? .leading : .center
        }
    }
    
    let grayColor = Color(red: 0.85, green: 0.85, blue: 0.85)
        
    var body: some View {
        Group {
            HStack {
                Text("Bullet List Demo").font(.title3)
                Spacer()
                Button {
                    showOptionsSheet.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                }
            }
            .padding(10)
            .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.65, alpha: 1)))
            .sheet(isPresented: $showOptionsSheet) {
                VStack(spacing: 0) {
                    Button {
                        showOptionsSheet.toggle()
                    } label: {
                        VStack(spacing: 2) {
                            Capsule()
                                .fill(grayColor)
                                .frame(width: 50, height: 2)
                                .padding(0)
                            Capsule()
                                .fill(grayColor)
                                .frame(width: 50, height: 2)
                                .padding(0)
                        }
                    }
                    .padding(5)
                    VStack(alignment: .leading) {
                        Toggle("Show border", isOn: $withBorder)
                        Text("Caption frame:")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            .frame(alignment: .leading)
                        Toggle("maxWidth = infinity", isOn: $toInfinity)
                            .padding(left: 10)
                        Toggle("alignment = .leading", isOn: $alignLeft)
                            .padding(left: 10)
                    }
                    .padding(10)
                }
                .padding(0)
                .presentationDetents([.height(200)])
            }
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading,
                       spacing: 10) {
                    Group {
                        heading3("Simple list")
                        SimpleList(listItems: data2,
                                   listItemSpacing: 10,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                        heading3("Simple bullet list")
                        SimpleList(listItems: data2.map({ "•\t\($0)" }),
                                   listItemSpacing: 10,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                        heading3("Happy face bullet list")
                        SimpleList(listItems: data2.map({ "😀\t\($0)" }),
                                   listItemSpacing: 10,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                    }
                    Group {
                        heading3("Properly aligned bullet list")
                        BulletList(listItems: data2,
                                   listItemSpacing: 10,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                        heading3("With bullet width 20pt")
                        BulletList(listItems: data2,
                                   listItemSpacing: 10,
                                   bulletWidth: 20,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                        heading3("Double happy face bullet")
                        BulletList(listItems: data2,
                                   listItemSpacing: 10,
                                   bullet: "😀😀",
                                   bulletWidth: 50,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                        heading3("Right align bullet")
                        BulletList(listItems: data2,
                                   listItemSpacing: 10,
                                   bullet: "⭐️",
                                   bulletWidth: 40,
                                   bulletAlignment: .trailing,
                                   contentFrameMaxWidth: textFrameMaxWidth,
                                   contentFrameAlignment: textFrameAlignment,
                                   borderWidth: borderWidth)
                    }
                    Group {
                        heading3("Numeric (ordered) list")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                        heading3("Numeric list (number width 20pt)")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    bulletWidth: 20,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                        heading3("Numeric list with prefix")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    prefix: "B.",
                                    bulletWidth: 40,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                        heading3("With different starting point and increment value")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    toNumber: { idx in
                                        return "\(idx + 5)"
                                    },
                                    bulletWidth: 40,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                    }
                    Group {
                        heading3("Roman numeral ordered list")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    toNumber: { idx in
                                        return romanNumeralFor(idx+1)
                                    },
                                    bulletWidth: 40,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                        heading3("Right align lead number ordered list")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    toNumber: { idx in
                                        return romanNumeralFor(idx+1)
                                    },
                                    bulletWidth: 40,
                                    bulletAlignment: .trailing,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                        heading3("Different starting point")
                        OrderedList(listItems: data2,
                                    listItemSpacing: 10,
                                    toNumber: { idx in
                                        return romanNumeralFor(idx+15)
                                    },
                                    bulletWidth: 40,
                                    bulletAlignment: .trailing,
                                    contentFrameMaxWidth: textFrameMaxWidth,
                                    contentFrameAlignment: textFrameAlignment,
                                    borderWidth: borderWidth)
                    }
                    Group {
                        heading2("UIKit List")
                        
                        Group {
                            heading3("UIKit list - default")
                            UIKitList(listItems: data2)
                            
                            heading3("UIKit list in SwiftUI (default width is 25pt)")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "😀" })
                            heading3("UIKit list in SwiftUI (bullet width is 35pt)")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "😀" },
                                      bulletWidth: 35.0)
                            heading3("Right align bullet")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "😀" },
                                      bulletWidth: 50,
                                      bulletAlignment: .right)
                        }
                        Group {
                            heading3("Numeric list")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "\(idx+1)." },
                                      bulletWidth: 50)
                            heading3("Numeric list right aligned")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "\(idx+1)." },
                                      bulletWidth: 50,
                                      bulletAlignment: .right)
                        }
                        Group {
                            heading3("Roman numeral list")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "\(romanNumeralFor(idx+1))." },
                                      bulletWidth: 50)
                            heading3("Roman numeral list right aligned")
                            UIKitList(listItems: data2,
                                      bullet: { idx in "\(romanNumeralFor(idx+1))." },
                                      bulletWidth: 50,
                                      bulletAlignment: .right)
                        }
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

//struct MasterPage_Preview: PreviewProvider {
//    static var previews: some View {
//        MasterPageView().previewDevice(PreviewDevice(rawValue: "iPhone 13")).previewDisplayName("iPhone 13")
//    }
//}

let view = MasterPageView()
//let hostingVC = UIHostingController(rootView: view)
//PlaygroundPage.current.liveView = hostingVC
PlaygroundPage.current.setLiveView(view)
