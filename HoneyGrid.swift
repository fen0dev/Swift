//
//  HoneyGrid.swift
//  QuizGame
//
//  Created by Giuseppe, De Masi on 15/02/22.
//

import SwiftUI

struct HoneyGrid <Content: View, Item>: View where Item: RandomAccessCollection {
    
    var content: (Item.Element)->Content
    var items: Item
    
    init(items: Item, @ViewBuilder content: @escaping (Item.Element)->Content) {
        self.content = content
        self.items = items
    }
    
    @State var width: CGFloat = 0
    
    var body: some View {
        
        //-20 is to remove the honey grid's spacing
        VStack(spacing: -20) {
            
            ForEach(setUpHoneyGrid().indices, id: \.self) {index in
                
                HStack(spacing: 4) {
                    
                    ForEach(setUpHoneyGrid()[index].indices, id: \.self) {subIndex in
                        
                        content(setUpHoneyGrid()[index][subIndex])
                            .frame(width: (width) / 4)
                            .offset(x: setOffset(index: index))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(name: "HoneyComb")
        .overlay(
            GeometryReader {proxy in
                Color.clear
                    .preference(key: WidthKey.self, value: proxy.frame(in: .named("HoneyComb")).width - proxy.frame(in: .named("HoneyComb")).minX)
                    .onPreferenceChange(WidthKey.self) { width in
                        self.width = width
                    }
            }
        )
    }
    
    //to avoid unoriented grids
    func setOffset(index: Int) -> CGFloat {
        let current = setUpHoneyGrid()[index].count
        let offset = (width / 4) / 2
        
        if index != 0 {
            let previous = setUpHoneyGrid()[index - 1].count
            
            if current == 1 && previous % 2 == 0 {
                return 0
            }
            
            if previous % current == 0 {
                return -offset - 2
            }
        }
        
        return 0
    }
    
    //generating honey grid
    //path will be 4,3,4,3...
    func setUpHoneyGrid() -> [[Item.Element]] {
        
        var rows: [[Item.Element]] = []
        var itemsAtRow: [Item.Element] = []
        
        var count: Int = 0
        
        items.forEach { item in
            
            itemsAtRow.append(item)
            count += 1
            
            if itemsAtRow.count >= 3 {
                //checking if empty and first row is always 4
                if rows.isEmpty && itemsAtRow.count == 4 {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
                
                //if previous contains 4 items then current 3
                //or vice versa
                else if let last = rows.last, last.count == 3 && itemsAtRow.count == 4 {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
                
                else if let last = rows.last, last.count == 4 && itemsAtRow.count == 3  {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
            }
            
            //checking for more items to put in the rows, if available
            if count == items.count {
                if let last = rows.last {
                    if rows.count >= 2 {
                        let previous = (rows[rows.count - 2].count == 4 ? 3 : 4)
                        
                        if (last.count + itemsAtRow.count) <= previous {
                            rows[rows.count - 1].append(contentsOf: itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                        else {
                            rows.append(itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                    }
                    else if (last.count + itemsAtRow.count) <= 4 {
                        rows[rows.count - 1].append(contentsOf: itemsAtRow)
                        itemsAtRow.removeAll()
                    }
                    else {
                        rows.append(itemsAtRow)
                        itemsAtRow.removeAll()
                    }
                }
                else {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
            }
        }
        
        return rows
    }
}

struct HoneyGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//preference key for width to keep
struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
