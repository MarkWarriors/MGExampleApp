import Foundation
import Swifter

public class MockServer {
  private var server: HttpServer?
  private var isStarted = false

  public init() {}

  public func start(port: UInt16 = 8123) {
    guard !isStarted else { return }
    server = HttpServer()
    guard let server = server else {
      print(">>> MOCK SERVER Error on initialization")
      return
    }

    server.middleware.append { r in
      return self.processRequest(r)
    }

    server["/static/:path"] = directoryBrowser("/")

    guard (try? server.start(port)) != nil else {
      print(">>> MOCK SERVER Error on start")
      return
    }
    isStarted = true
    print(">>> MOCK SERVER Started on port: \(port)")
  }

  private func processRequest(_ request: HttpRequest) -> HttpResponse {
    print(">>> MOCK SERVER received request at \(request.path)")
    guard let endpoint = request.path.components(separatedBy: "?").first else {
      print(">>> MOCK SERVER error no endpoint")
      return Response.Error.generic
    }

    guard let route = Routes.allRoutes()[endpoint] else {
      print(">>> MOCK SERVER error no route found")
      return Response.Error.generic
    }

    sleep(1)

    return route.handle(request: request)
  }
}
