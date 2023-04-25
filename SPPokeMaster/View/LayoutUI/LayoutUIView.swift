//
//  LayoutUIView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/19.
//

import SwiftUI

struct LayoutUIView: View {
    
    @State var selectedIndex = 0
    
    let names = [
        "oneCat | Wei Wang",
        "tyrone | Pu Song",
        "ty | Songpu"
    ]
    
    var body: some View {
        HStack(alignment: .select) {
            Text("User:")
                .font(.footnote)
                .alignmentGuide(.select) { d in
                    d[.bottom] + CGFloat(self.selectedIndex) * 20.3
//                    d[VerticalAlignment.center]
                }
                .background(Color.red)
            Image(systemName: "person.circle")
                .background(Color.yellow)
                .alignmentGuide(.select) { d in
                    d[VerticalAlignment.center]
                }
            VStack(alignment: .leading) {
                ForEach(0..<names.count) { index in
                    Group {
                        if index == self.selectedIndex {
                            Text(self.names[index])
                                .foregroundColor(.green)
                                .alignmentGuide(.select) { d in
                                    d[VerticalAlignment.center]
                                }
                        } else {
                            Text(self.names[index])
                                .onTapGesture {
                                    self.selectedIndex = index
                                }
                        }
                    }
                }
            }
        }
        .animation(.linear(duration: 0.2))
//        .lineLimit(1)
//        .fixedSize()
//        .frame(width: 300, alignment: .leading)
//        .background(Color.purple)
    }
}

extension VerticalAlignment {
    
    struct MyCenter: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context.height / 2
        }
    }
    
    static let myCenter = VerticalAlignment(MyCenter.self)
    
    struct SelectAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }
    static let select = VerticalAlignment(SelectAlignment.self)
    
}

extension HorizontalAlignment {
    
    struct MyTrailing: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.trailing]
        }
    }
    static let myTrailing = HorizontalAlignment(MyTrailing.self)
    
    
    struct MyLeading: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.leading]
        }
    }
    static let myLeading = HorizontalAlignment(MyLeading.self)
    
}

struct LayoutUIView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutUIView()
    }
}
