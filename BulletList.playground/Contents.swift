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

public class SampleViewParameters {
    var listItemSpacing: CGFloat = 10.0
    var leadIcon: String = "•"
    var bulletWidth: CGFloat = 35.0
    var bulletAlignment: Alignment = .leading
    var bulletPrefix: String = ""
    
    var showBorders: Bool = false
    var captionInfiniteWidth: Bool = true
    var captionAlignLeft: Bool = true
    
    init(showBorders: Bool, captionInfiniteWidth: Bool, captionAlignLeft: Bool) {
        self.showBorders = showBorders
        self.captionInfiniteWidth = captionInfiniteWidth
        self.captionAlignLeft = captionAlignLeft
    }
    
    // Computed properties
    
    var frameMaxWidth: CGFloat? {
        get {
            return captionInfiniteWidth ? .infinity : nil
        }
    }
    
    var frameAlignment: Alignment {
        get {
            return captionAlignLeft ? .leading : .center
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return showBorders ? 1 : 0
        }
    }
    
    // Chainable functions
    
    func bullet(prefix: String = "",
                icon: String = "•",
                width: CGFloat = 25.0,
                alignment: Alignment = .leading) -> SampleViewParameters {
        bulletPrefix = prefix
        leadIcon = icon
        bulletWidth = width
        bulletAlignment = alignment
        return self
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
    var bulletWidth: CGFloat = 25.0
    var content: String
    @State private var height: CGFloat = .zero
    
    private func bulletItem(bullet: String,
                            bulletWidth: CGFloat,
                            content: String) -> NSAttributedString {
        let tabStops = [NSTextTab(textAlignment: .left,
                                  location: bulletWidth)]
        
        // Hanging paragraph style
        let hangingIndent = NSMutableParagraphStyle()
        hangingIndent.headIndent = bulletWidth
        hangingIndent.firstLineHeadIndent = -bulletWidth
        hangingIndent.tabStops = tabStops
        
        return NSAttributedString(string: "\(bullet)\t\(content)",
                                  attributes: [
                                    .paragraphStyle: hangingIndent
                                  ])
    }

    
    var body: some View {
        UIKitText(attributedString: bulletItem(bullet: bullet,
                                               bulletWidth: bulletWidth,
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
    
    var sampleMarkdown: String {
        get {
            return """
- This is the first markdown list item.
- This is the second item.
- The third item is longer than the other items in the list.
- The End!
"""
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
    /// - Parameter params: List parameters
    /// - Returns: Simple list view
    @ViewBuilder func simpleList(_ params: SampleViewParameters) -> some View {
        VStack(alignment: .leading,
               spacing: params.listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                Text(data)
                    .frame(maxWidth: params.frameMaxWidth,
                           alignment: params.frameAlignment)
                    .border(.orange, width: params.borderWidth)
            }
        }
        .padding(2)
        .border(.green, width: params.borderWidth)
    }
        
    /// Generate a bullet list without proper alignment
    /// - Parameter params: List parameters
    /// - Returns: Bullet list view
    @ViewBuilder func simpleBulletList(_ params: SampleViewParameters) -> some View {
        VStack(alignment: .leading,
               spacing: params.listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                Text("\(params.leadIcon)\t\(data)")
                    .frame(maxWidth: params.frameMaxWidth,
                           alignment: params.frameAlignment)
                    .border(.orange, width: params.borderWidth)
            }
        }
        .padding(2)
        .border(.green, width: params.borderWidth)
    }
    
    /// Generate a bullet list with proper alignment
    /// - Parameter params: List parameters
    /// - Returns: Bullet list view
    @ViewBuilder func bulletList(_ params: SampleViewParameters) -> some View {
        VStack(alignment: .leading,
               spacing: params.listItemSpacing) {
            ForEach(sampleData, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(params.leadIcon)
                        .frame(width: params.bulletWidth,
                               alignment: .leading)
                        .border(Color.blue,
                                width: params.borderWidth)
                    Text(data)
                        .frame(maxWidth: params.frameMaxWidth,
                               alignment: params.frameAlignment)
                        .border(Color.orange,
                                width: params.borderWidth)
                }
            }
        }
        .padding(2)
        .border(.green, width: params.borderWidth)
    }
       
    /// Generate a numeric list
    /// - Parameter params: List parameters
    /// - Returns: Numeric list view
    @ViewBuilder func numericList(_ params: SampleViewParameters) -> some View {
        VStack(alignment: .leading,
               spacing: params.listItemSpacing) {
            ForEach(sampleData.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%d.", params.bulletPrefix, (idx+1))
                    Text(stg)
                        .frame(width: params.bulletWidth,
                               alignment: params.bulletAlignment)
                        .border(Color.blue,
                                width: params.borderWidth)
                    Text(sampleData[idx])
                        .frame(maxWidth: params.frameMaxWidth,
                               alignment: params.frameAlignment)
                        .border(Color.orange,
                                width: params.borderWidth)
                }
            }
        }
        .padding(2)
        .border(.green, width: params.borderWidth)
    }
        
    /// Generate a roman numeral list
    /// - Parameter params: List parameters
    /// - Returns: Roman numeral list view
    @ViewBuilder func romanNumeralList(_ params: SampleViewParameters) -> some View {
        VStack(alignment: .leading,
               spacing: params.listItemSpacing) {
            ForEach(sampleData.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = String(format: "%@%@.", params.bulletPrefix, romanNumeralFor(idx+1))
                    Text(stg)
                        .frame(width: params.bulletWidth,
                               alignment: params.bulletAlignment)
                        .border(Color.blue,
                                width: params.borderWidth)
                    Text(sampleData[idx])
                        .frame(maxWidth: params.frameMaxWidth,
                               alignment: params.frameAlignment)
                        .border(Color.orange,
                                width: params.borderWidth)
                }
            }
        }
        .padding(2)
        .border(.green, width: params.borderWidth)
    }

    @ViewBuilder func uikitList(_ params: SampleViewParameters) -> some View {
        VStack(alignment: .leading,
               spacing: params.listItemSpacing) {
            let simpleData = [
                "Item 1",
                "Item 2. This is a longer bullet list item.",
                "Item 3. Short one",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut elementum orci tellus, eu auctor purus egestas placerat. Nam nec eros ut lacus pretium laoreet."]
            ForEach(simpleData, id: \.self) { data in
                UIKitBulletItem(bullet: params.leadIcon,
                                bulletWidth: params.bulletWidth,
                                content: data)
            }
//            ForEach(sampleData, id: \.self) { data in
//                UIKitBulletItem(bullet: params.leadIcon,
//                                bulletWidth: params.bulletWidth,
//                                content: data)
//            }
        }
    }
}

struct SimpleList: View, BaseView {
    var sampleParams: SampleViewParameters?
    var title: String
    
    init(_ title: String, _ parameters: SampleViewParameters) {
        self.sampleParams = parameters
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .underline()

        if let sampleParams = self.sampleParams {
            simpleList(sampleParams)
        }
    }
}

struct SimpleBulletList: View, BaseView {
    var sampleParams: SampleViewParameters?
    var title: String
    
    init(_ title: String, _ parameters: SampleViewParameters) {
        self.sampleParams = parameters
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        if let sampleParams = sampleParams {
            simpleBulletList(sampleParams)
        }
    }
}

struct AlignedBulletList: View, BaseView {
    var sampleParams: SampleViewParameters?
    var title: String
    
    init(_ title: String, _ parameters: SampleViewParameters) {
        self.sampleParams = parameters
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .underline()
            .padding(top: 20)

        if let sampleParams = sampleParams {
            bulletList(sampleParams)
        }
    }
}

struct NumericList: View, BaseView {
    var sampleParams: SampleViewParameters?
    var title: String
    
    init(_ title: String, _ parameters: SampleViewParameters) {
        self.title = title
        self.sampleParams = parameters
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        if let sampleParams = sampleParams {
            numericList(sampleParams)
        }
    }
}

struct RomanNumeralList: View, BaseView {
    var sampleParams: SampleViewParameters?
    var title: String
    
    init(_ title: String, _ parameters: SampleViewParameters) {
        self.title = title
        self.sampleParams = parameters
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        if let sampleParams = sampleParams {
            romanNumeralList(sampleParams)
        }
    }
}

struct UIKitList: View, BaseView {
    var sampleParams: SampleViewParameters?
    var title: String
    
    init(_ title: String, _ parameters: SampleViewParameters) {
        self.title = title
        self.sampleParams = parameters
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .underline()
            .padding(top: 20)
        
        if let sampleParams = sampleParams {
            uikitList(sampleParams)
        }
    }
}

struct MasterPageView: View {
    @State var withBorder: Bool = false
    @State var toInfinity: Bool = true
    @State var alignLeft: Bool = true
    
    @State var showOptionsSheet: Bool = false
    
    let grayColor = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    var params: SampleViewParameters {
        get {
            return SampleViewParameters(showBorders: withBorder,
                                        captionInfiniteWidth: toInfinity,
                                        captionAlignLeft: alignLeft)
        }
    }
    
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
                        SimpleList("Simple list", params)
                    }
                    Group {
                        SimpleBulletList(
                            "Simple bullet list",
                            params)
                        SimpleBulletList(
                            "Happy face bullet list",
                            params.bullet(icon: "😀"))
                    }
                    Group {
                        AlignedBulletList(
                            "Properly aligned bullet list",
                            params)
                        AlignedBulletList(
                            "Happy faces bullet list with different indentation",
                            params.bullet(icon: "😀😀",
                                          width: 50.0))
                    }
                    Group {
                        NumericList(
                            "Numeric ordered list",
                            params)
                        NumericList(
                            "Numeric ordered list with prefix",
                            params.bullet(prefix: "A.",
                                          width: 30.0))
                    }
                    Group {
                        RomanNumeralList(
                            "Roman numeral ordered list",
                            params)
                        RomanNumeralList(
                            "Right align lead number ordered list",
                            params.bullet(alignment: .trailing))
                    }
                    Group {
                        UIKitList(
                            "UIKit list in SwiftUI (35pt width)",
                            params.bullet(icon: "😀", width: 35.0))
                        AlignedBulletList(
                            "SwiftUI aligned list (25pt width)",
                            params.bullet(icon: "😀"))
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
