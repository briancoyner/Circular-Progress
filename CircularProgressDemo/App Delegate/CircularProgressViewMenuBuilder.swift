//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation

import CircularProgress

struct CircularProgressViewMenuBuilder: MenuBuilder {

    let title = "Progress View Demos"

    func makeMenu() -> [Menu] {
        return [
            Menu(title: "Onboard Progress View", items: [
                MenuItem(
                    title: "Text Color Matches Tint Color",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: BasicCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: LocalizedProgressAdditionalContentLayoutStrategy()
                            )
                        )
                    }
                ),
                MenuItem(
                    title: "Text Color Is Black",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: BasicCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: LocalizedProgressAdditionalContentLayoutStrategy(textColor: .black)
                            )
                        )
                    }
                ),
                MenuItem(
                    title: "Text Color Is Purple",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: BasicCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: LocalizedProgressAdditionalContentLayoutStrategy(textColor: .purple)
                            )
                        )
                    }
                ),
                MenuItem(
                    title: "Small Rounded Rect",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: BasicCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: RoundedRectAdditionalContentLayoutStrategy()
                            )
                        )
                    }
                )
            ]),
            Menu(title: "Stroked Progress View", items: [
                MenuItem(
                    title: "Small Rounded Rect",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: InsetCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: RoundedRectAdditionalContentLayoutStrategy()
                            )
                        )
                    }
                ),
                MenuItem(
                    title: "Formatted Text",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: InsetCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: LocalizedProgressAdditionalContentLayoutStrategy()
                            )
                        )
                    }
                )
            ]),
            Menu(title: "Filled Progress View", items: [
                MenuItem(
                    title: "No Additional Content",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: FilledCircularProgressViewStrategy()
                        )
                    }
                ),
                MenuItem(
                    title: "Formatted Text",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: FilledCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: LocalizedProgressAdditionalContentLayoutStrategy(textColor: .white)
                            )
                        )
                    }
                ),
                MenuItem(
                    title: "Composite",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: FilledCircularProgressViewStrategy(
                                additionalContentLayoutStrategy: CompositeCircularProgressViewAdditionalContentLayoutStrategy(
                                    strategies: [
                                        RoundedRectAdditionalContentLayoutStrategy(),
                                        LocalizedProgressAdditionalContentLayoutStrategy(textColor: .white)
                                    ]
                                )
                            )
                        )
                    }
                )
            ]),
            Menu(title: "Other Fun", items: [
                MenuItem(
                    title: "Fireworks",
                    viewControllerProvider: {
                        CircularProgressViewSamplerViewController(
                            strategy: FireworksCircularProgressViewStrategy()
                        )
                    }
                )
            ])
        ]
    }
}
