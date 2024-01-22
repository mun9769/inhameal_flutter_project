//
//  inhameal_flutter_projectTests.swift
//  inhameal_flutter_projectTests
//
//  Created by moon on 1/22/24.
//

import XCTest

struct LunchData: Decodable, Hashable {
    let lunch: [Meal]
}

final class inhameal_flutter_projectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeWidgetData() throws {
        let widgetData = try JSONDecoder().decode(WidgetData.self, from: jsonData)
        
        print("--------------------------------------------------------------------------")
        print(widgetData)
        print("--------------------------------------------------------------------------")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}



let jsonData = """
{"lunch":[{"name":"meal_name","opentime":"openTime","menus":["김치","밥","오뚜기","햇반"],"price":"price"}],"dinner":[{"name":"meal_name","opentime":"openTime","menus":["김치","밥","오뚜기","햇반"],"price":"price"}]}
""".data(using: .utf8)!

let cafeData = """
{
  "lunch": [
    {
      "name": "Meal1",
      "menus": ["Menu1", "Menu2"],
      "openTime": "12:00 PM",
      "price": "$10.99"
    },
    {
      "name": "Meal2",
      "menus": ["Menu3", "Menu4"],
      "openTime": "1:00 PM",
      "price": "$12.99"
    }
  ],
  "dinner": [
    {
      "name": "Dinner1",
      "menus": ["Menu5", "Menu6"],
      "openTime": "7:00 PM",
      "price": "$15.99"
    },
    {
      "name": "Dinner2",
      "menus": ["Menu7", "Menu8"],
      "openTime": "8:00 PM",
      "price": "$18.99"
    }
  ]
}
""".data(using: .utf8)!
