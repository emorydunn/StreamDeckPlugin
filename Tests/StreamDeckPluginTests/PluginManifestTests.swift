//
//  PluginManifestTests.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import XCTest
@testable import StreamDeck

final class PluginManifestTests: XCTestCase {
    
    func testEncode() {
        let manifest = PluginManifest(
            name: "Counter",
            description: "Count things. On your Stream Deck!",
            category: "Counting Actions",
            author: "Emory Dunn",
            icon: "counter",
            version: "0.1",
            os: [
                .mac(minimumVersion: "10.15")
            ],
            software: .minimumVersion("4.1"),
            sdkVersion: 2,
            codePath: "counter-plugin",
            actions: [
                PluginAction(
                    name: "Increment",
                    uuid: "photo.lostcause.counter.increment",
                    icon: "Icons/plus",
                    states: [
                        PluginActionState(image: "Icons/plus")
                    ],
                    tooltip: "Increment the count."),
                PluginAction(
                    name: "Decrement",
                    uuid: "photo.lostcause.counter.decrement",
                    icon: "Icons/minus",
                    states: [
                        PluginActionState(image: "Icons/minus")
                    ],
                    tooltip: "Decrement the count.")
            ])
        
        let generator = GenerateManifest()
        let data = try! generator.encode(manifest: manifest)
        
        let json = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(json, """
            {
              "Author" : "Emory Dunn",
              "Version" : "0.1",
              "Software" : {
                "MinimumVersion" : "4.1"
              },
              "CodePath" : "counter-plugin",
              "Actions" : [
                {
                  "Icon" : "Icons/plus",
                  "Name" : "Increment",
                  "UUID" : "photo.lostcause.counter.increment",
                  "Tooltip" : "Increment the count.",
                  "States" : [
                    {
                      "Image" : "Icons/plus"
                    }
                  ]
                },
                {
                  "Icon" : "Icons/minus",
                  "Name" : "Decrement",
                  "UUID" : "photo.lostcause.counter.decrement",
                  "Tooltip" : "Decrement the count.",
                  "States" : [
                    {
                      "Image" : "Icons/minus"
                    }
                  ]
                }
              ],
              "Category" : "Counting Actions",
              "SDKVersion" : 2,
              "Icon" : "counter",
              "Name" : "Counter",
              "Description" : "Count things. On your Stream Deck!",
              "OS" : [
                {
                  "Platform" : "mac",
                  "MinimumVersion" : "10.15"
                }
              ]
            }
            """)

    }
}
