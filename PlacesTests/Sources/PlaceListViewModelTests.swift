//
//  PlaceListViewModelTests.swift
//  PlacesTests
//
//

import XCTest
import AdyenNetworking
import Combine
@testable import PlacesUIKit

final class PlaceListViewModelTests: XCTestCase {
    let timeout: TimeInterval = 2
    
    func testFetchPlaces() throws {
        let viewModel = PlaceListViewModel(apiClient: mockPlacesAPIClient())
        let data = try data(fromJsonFile: "places")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                throw URLError(.badServerResponse)
            }
            return (response, data)
        }
        var cancellables = Set<AnyCancellable>()
        let expectation = expectation(description: "fetch places")
        expectation.expectedFulfillmentCount = 2
        viewModel.$places
            .receive(on: DispatchQueue.main)
            .sink { state in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchPlaces()
        wait(for: [expectation], timeout: timeout)
        
        XCTAssert(viewModel.places.count == 10)
        guard let place = viewModel.places.first else {
            XCTFail("first place")
            throw XCTestError(.failureWhileWaiting)
        }
        XCTAssertEqual(place.name, "Trustco Bank", "place name failed")
    }
}

private extension PlaceListViewModelTests {
    func data(fromJsonFile: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "places", withExtension: "json") else {
            throw URLError(.resourceUnavailable)
        }
        let data = try Data(contentsOf: url)
        return data
    }
    
    func mockPlacesAPIClient() -> APIClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let apiClient = APIClient(apiContext: PlacesAPIContext(), configuration: configuration)
        return apiClient
    }
}
