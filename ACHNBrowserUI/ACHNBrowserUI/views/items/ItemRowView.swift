//
//  ItemRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    @EnvironmentObject private var collection: UserCollection
    
    let item: Item
    
    @State private var displayedVariant: String?

    private func bellsView(title: String, price: Int) -> some View {
        HStack(spacing: 2) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.text)
            Text("\(price)")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.bell)
        }
    }
        
    var body: some View {
        HStack(spacing: 8) {
            StarButtonView(item: item)
            if item.image == nil && displayedVariant == nil {
                Image(item.appCategory.iconName())
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                ItemImage(path: displayedVariant ?? item.image,
                          size: 100)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.text)
                Text(item.obtainedFrom ?? "unknown source")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                if item.buy != nil {
                    bellsView(title: "Buy for:", price: item.buy!)
                }
                if item.sell != nil {
                    bellsView(title: "Sell for:", price: item.sell!)
                }
                if item.variants != nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 2) {
                            ForEach(item.variants!, id: \.self) { variant in
                                ItemImage(path: variant,
                                         size: 25)
                                    .cornerRadius(4)
                                    .background(Rectangle()
                                        .cornerRadius(4)
                                        .foregroundColor(self.displayedVariant == variant ? Color.gray : Color.clear))
                                    .onTapGesture {
                                        FeedbackGenerator.shared.triggerSelection()
                                        self.displayedVariant = variant
                                }
                            }
                        }.frame(height: 30)
                    }
                }
                
                if item.formattedStartTime() != nil && item.formattedEndTime() != nil {
                    HStack {
                        Image(systemName: "clock.fill").foregroundColor(.secondaryText)
                        Text("\(item.formattedStartTime()!) - \(item.formattedEndTime()!)h")
                            .foregroundColor(.secondaryText)
                            .font(.caption)
                    }.padding(.top, 4)
                } else if item.startTimeAsString() != nil {
                    Text(item.startTimeAsString()!)
                        .foregroundColor(.secondaryText)
                        .font(.caption)
                }
            }
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(item: static_item)
                    .environmentObject(UserCollection())
                ItemRowView(item: static_item)
                    .environmentObject(UserCollection())
                ItemRowView(item: static_item)
                    .environmentObject(UserCollection())
            }
        }
    }
}

