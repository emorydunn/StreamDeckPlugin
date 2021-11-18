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
                .mac(minimumVersion: "10.15"),
                .win(minimumVersion: "10")
            ],
            applicationsToMonitor: ApplicationsToMonitor(mac: ["com.test.app"]),
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
                    tooltip: "Decrement the count.")
            ])
        
        let generator = ExportCommand()
        let data = try! generator.encode(
            manifest: manifest,
            outputFormatting: [
                .prettyPrinted,
                .withoutEscapingSlashes,
                .sortedKeys
            ])
        
        let json = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(json, """
            {
              "Actions" : [
                {
                  "Icon" : "Icons/plus",
                  "Name" : "Increment",
                  "States" : [
                    {
                      "Image" : "Icons/plus"
                    }
                  ],
                  "Tooltip" : "Increment the count.",
                  "UUID" : "photo.lostcause.counter.increment"
                },
                {
                  "Icon" : "Icons/minus",
                  "Name" : "Decrement",
                  "States" : [
                    {
                      "Image" : "Icons/minus"
                    }
                  ],
                  "Tooltip" : "Decrement the count.",
                  "UUID" : "photo.lostcause.counter.decrement"
                }
              ],
              "ApplicationsToMonitor" : {
                "Mac" : [
                  "com.test.app"
                ],
                "Windows" : [

                ]
              },
              "Author" : "Emory Dunn",
              "Category" : "Counting Actions",
              "CodePath" : "counter-plugin",
              "Description" : "Count things. On your Stream Deck!",
              "Icon" : "counter",
              "Name" : "Counter",
              "OS" : [
                {
                  "MinimumVersion" : "10.15",
                  "Platform" : "mac"
                },
                {
                  "MinimumVersion" : "10",
                  "Platform" : "windows"
                }
              ],
              "SDKVersion" : 2,
              "Software" : {
                "MinimumVersion" : "4.1"
              },
              "Version" : "0.1"
            }
            """)

    }
}
