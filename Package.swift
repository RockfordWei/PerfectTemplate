import PackageDescription
import Foundation

struct PackageSource: Codable {
  public var url = ""
  public var cache = ""
  public var majorVersion = 0
}

struct LoadablePackage: Codable {
  public var name = ""
  public var dependencies: [String: PackageSource] = [:]
}

let data = try? Data(contentsOf: URL(fileURLWithPath: "package.json"))
let pack = try JSONDecoder().decode(LoadablePackage.self, from: data!)

let package = Package(
    name: pack.name, targets: [],
    dependencies: pack.dependencies.map { (lib, source) in
      let path: String
      if let dir = opendir(source.cache) {
        path = source.cache
        closedir(dir)
      } else {
        path = source.url
      }
      return .Package(url: path, majorVersion: source.majorVersion ) 
    }
)
