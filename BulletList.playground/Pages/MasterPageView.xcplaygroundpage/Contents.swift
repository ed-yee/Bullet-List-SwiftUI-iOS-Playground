//: A SwiftUI based Playground for presenting user interface
  
import SwiftUI
import UIKit
import Foundation
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

// MARK: Text extensions

struct Heading: ViewModifier {
    var level: Int = 1
    
    func body(content: Content) -> some View {
        if level == 1 {
            content.font(.title).bold().padding(top: 20, bottom: 5)
        } else if level == 2 {
            content.font(.title2).underline().padding(top: 20, bottom: 5)
        } else if level == 3 {
            content.font(.title3).italic().padding(top: 20, bottom: 5)
        }
    }
}

extension Text {
    func heading1() -> some View {
        modifier(Heading(level: 1))
    }
    
    func heading2() -> some View {
        modifier(Heading(level: 2))
    }
    
    func heading3() -> some View {
        modifier(Heading(level: 3))
    }
}

// MARK: Roman number protocol

protocol RomanNumberProtocol {}
extension RomanNumberProtocol {
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

// MARK: Sample Data

protocol BulletListSampleData {}
extension BulletListSampleData {
    var data1: [String] {
        return [
            "Short item",
            "Long item. With a few more words",
            "Very long item. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean varius."
        ]
    }
    
    var data2: [String] {
        return ["Item 1", "Item #2", "The third item"]
    }
    
    var data3: [String] {
        var array: [String] = []
        for idx in stride(from: 1, to: 6, by: 1) {
            array.append("This is list item \(idx). Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.")
        }
        return array
    }
}

enum BulletListDataSets: String, CaseIterable, Identifiable {
    case data1
    case data2
    case data3
    
    var id: Self { self }
}

// MARK: UIParameters

class UIParameters: ObservableObject, BulletListSampleData {
    @Published var withBorder: Bool = false
    @Published var toInfinity: Bool = true
    @Published var alignLeft: Bool = true
    @Published var dataSet: BulletListDataSets = .data1
    
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

    var data: [String] {
        get {
            switch dataSet {
            case .data1: return data1
            case .data2: return data2
            case .data3: return data3
            }
        }
    }
}

// MARK: Bullet list page wrapper

struct BulletListWrapperView<C>: View where C: View {
    @ViewBuilder var content: C
    
    @EnvironmentObject var uiParams: UIParameters

    @State var showUIParametersView = false
    
    let grayColor = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    var body: some View {
        content
            .toolbar {
                Button {
                    showUIParametersView.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                }

            }
            .sheet(isPresented: $showUIParametersView) {
                VStack(spacing: 0) {
                    Button {
                        showUIParametersView.toggle()
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
                        HStack {
                            Text("Dataset")
                            Spacer()
                            Picker("Dataset", selection: $uiParams.dataSet) {
                                ForEach(BulletListDataSets.allCases) { ds in
                                    Text(ds.rawValue.capitalized).tag(ds)
                                }
                            }
                        }
                        Toggle("Show border", isOn: $uiParams.withBorder)
                        Text("Caption frame:")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            .frame(alignment: .leading)
                        Toggle("maxWidth = infinity", isOn: $uiParams.toInfinity)
                            .padding(left: 10)
                        Toggle("alignment = .leading", isOn: $uiParams.alignLeft)
                            .padding(left: 10)
                    }
                    .padding(10)
                }
                .padding(0)
                .presentationDetents([.height(250)])
            }
    }
}

// MARK: Simple list

struct SimpleList: View {
    @EnvironmentObject var uiParams: UIParameters

    var listItems: [String]
    var listItemSpacing: CGFloat? = nil

    var body: some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems, id: \.self) { data in
                Text(data)
                    .frame(maxWidth: uiParams.textFrameMaxWidth,
                           alignment: uiParams.textFrameAlignment)
                    .border(.orange, width: uiParams.borderWidth)
            }
        }
       .padding(2)
       .border(.green, width: uiParams.borderWidth)
    }
}

struct SimpleListView: View {
    @EnvironmentObject var uiParams: UIParameters
    
    var body: some View {
        BulletListWrapperView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("Basic").heading3()
                    SimpleList(listItems: uiParams.data,
                               listItemSpacing: 10)
                    Text("With a bullet").heading3()
                    SimpleList(listItems: uiParams.data.map({ "•\t\($0)" }),
                               listItemSpacing: 10)
                    Text("With a happy face bullet").heading3()
                    SimpleList(listItems: uiParams.data.map({ "😀\t\($0)" }),
                               listItemSpacing: 10)
                }
                .padding(15)
            }
        }
        .environmentObject(uiParams)
        
    }
}

// MARK: Real bullet list

struct BulletList: View {
    @EnvironmentObject var uiParams: UIParameters
    
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: String = "•"
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(bullet)
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                        .border(Color.blue,
                                width: uiParams.borderWidth)
                    Text(data)
                        .frame(maxWidth: uiParams.textFrameMaxWidth,
                               alignment: uiParams.textFrameAlignment)
                        .border(Color.orange,
                                width: uiParams.borderWidth)
                }
            }
        }
       .padding(2)
       .border(.green, width: uiParams.borderWidth)

    }
}

struct RealBulletListView: View {
    @EnvironmentObject var uiParams: UIParameters
    
    var body: some View {
        BulletListWrapperView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("Properly aligned bullet list").heading3()
                    BulletList(listItems: uiParams.data,
                               listItemSpacing: 10)
                    Text("With bullet width 20pt").heading3()
                    BulletList(listItems: uiParams.data,
                               listItemSpacing: 10,
                               bulletWidth: 20)
                    Text("Double happy face bullet").heading3()
                    BulletList(listItems: uiParams.data,
                               listItemSpacing: 10,
                               bullet: "😀😀",
                               bulletWidth: 50)
                    Text("Right align bullet").heading3()
                    BulletList(listItems: uiParams.data,
                               listItemSpacing: 10,
                               bullet: "⭐️",
                               bulletWidth: 40,
                               bulletAlignment: .trailing)
                }
                .padding(15)
            }
        }
        .environmentObject(uiParams)
    }
}

// MARK: Ordered list

struct OrderedList: View {
    @EnvironmentObject var uiParams: UIParameters
    
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var toNumber: ((Int) -> String) = { "\($0 + 1)." }
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    let stg = toNumber(idx)
                    Text(stg)
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                        .border(Color.blue,
                                width: uiParams.borderWidth)
                    Text(listItems[idx])
                        .frame(maxWidth: uiParams.textFrameMaxWidth,
                               alignment: uiParams.textFrameAlignment)
                        .border(Color.orange,
                                width: uiParams.borderWidth)
                }
            }
        }
       .padding(2)
       .border(.green, width: uiParams.borderWidth)

    }
}

struct OrderedListView: View {
    @EnvironmentObject var uiParams: UIParameters
    
    var body: some View {
        BulletListWrapperView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("Numeric list").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10)
                    Text("Number bullet with specific width - 25pt)").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10,
                                bulletWidth: 25)
                    Text("Multi-level list").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10,
                                toNumber: { idx in
                                    return "B.\(idx+1)"
                                },
                                bulletWidth: 40)
                    Text("With different starting point").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10,
                                toNumber: { idx in
                                    return "\(idx + 5)."
                                },
                                bulletWidth: 40)
                }
                .padding(15)
            }
        }
        .environmentObject(uiParams)
    }
}

// MARK: Roman numeral list

struct RomanNumeralListView: View, RomanNumberProtocol {
    @EnvironmentObject var uiParams: UIParameters
    
    var body: some View {
        BulletListWrapperView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("Roman numeral ordered list").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10,
                                toNumber: { idx in
                                    return "\(romanNumeralFor(idx+1))."
                                },
                                bulletWidth: 40)
                    Text("Right align lead number ordered list").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10,
                                toNumber: { idx in
                                    return "\(romanNumeralFor(idx+1))."
                                },
                                bulletWidth: 40,
                                bulletAlignment: .trailing)
                    Text("Different starting point").heading3()
                    OrderedList(listItems: uiParams.data,
                                listItemSpacing: 10,
                                toNumber: { idx in
                                    return "\(romanNumeralFor(idx+15))."
                                },
                                bulletWidth: 40,
                                bulletAlignment: .trailing)
                }
                .padding(15)
            }
        }
        .environmentObject(uiParams)
    }
}

// MARK: Ultimate list

struct SuperBulletList: View {
    @EnvironmentObject var uiParams: UIParameters

    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: ((Int) -> String) = { i in "•" }
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    Text(bullet(idx))
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                        .border(Color.blue,
                                width: uiParams.borderWidth)
                    Text(listItems[idx])
                        .frame(maxWidth: uiParams.textFrameMaxWidth,
                               alignment: uiParams.textFrameAlignment)
                        .border(Color.orange,
                                width: uiParams.borderWidth)
                }
            }
        }
       .padding(2)
       .border(.green, width: uiParams.borderWidth)

    }
}

struct UltimateListView: View, RomanNumberProtocol {
    @EnvironmentObject var uiParams: UIParameters
      
    var body: some View {
        BulletListWrapperView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("Default bullet (•) list").heading3()
                    SuperBulletList(listItems: uiParams.data,
                                    listItemSpacing: 10)
                    Text("Happy face bullet list").heading3()
                    SuperBulletList(listItems: uiParams.data,
                                    listItemSpacing: 10,
                                    bullet: { idx in "😀" })
                    Text("Ordered list").heading3()
                    SuperBulletList(listItems: uiParams.data,
                                    listItemSpacing: 10,
                                    bullet: { "\($0 + 1)." },
                                    bulletWidth: 40)
                    Text("Right aligned Roman numeral list").heading3()
                    SuperBulletList(listItems: uiParams.data,
                                    listItemSpacing: 10,
                                    bullet: { "\(romanNumeralFor($0+1))." },
                                    bulletWidth: 40,
                                    bulletAlignment: .trailing)
                }
                .padding(15)
            }
        }
        .environmentObject(uiParams)
    }
}

// MARK: Router

class Router: ObservableObject {
    @Published var path = NavigationPath()
}

// MARK: - Master page view

struct BulletListCategory: Identifiable, Hashable {
    static func == (lhs: BulletListCategory, rhs: BulletListCategory) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var name: String
    var view: AnyView
    var id: String {
        name
    }
}

struct MasterPageView: View {
    @EnvironmentObject var router: Router
    @StateObject var uiParams = UIParameters()
    
    private let simpleList = "Simple List"
    private let realBullet = "Real Bullet List"
    private let orderedList = "Ordered List"
    private let romanList = "Roman Numeral List"
    private let ultimateList = "Ultimate List"
    private let uikitList = "UIKit List"
    
    var bulletListCategories: [BulletListCategory] {
        get {
            let list = [
                BulletListCategory(name: simpleList,
                                   view: AnyView(SimpleListView()
                                                )),
                BulletListCategory(name: realBullet,
                                   view: AnyView(RealBulletListView()
                                                )),
                BulletListCategory(name: orderedList,
                                   view: AnyView(OrderedListView()
                                                )),
                BulletListCategory(name: romanList,
                                   view: AnyView(RomanNumeralListView()
                                                )),
                BulletListCategory(name: ultimateList,
                                   view: AnyView(UltimateListView()
                                                )),
            ]
            
            return list
        }
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(bulletListCategories) { category in
                    NavigationLink(category.name, value: category)
                }
            }.navigationDestination(for: BulletListCategory.self, destination: { category in
                category.view
                    .navigationTitle(category.name)
                    .environmentObject(uiParams)
            }).navigationTitle("Bullet/Ordered List")
        }
    }
}

let view = MasterPageView()
    .environmentObject(Router())

//let hostingVC = UIHostingController(rootView: view)
//PlaygroundPage.current.liveView = hostingVC

PlaygroundPage.current.setLiveView(view)



