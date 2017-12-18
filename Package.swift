import PackageDescription
import Foundation

struct LoadablePackage: Codable {
  public var name = ""
  public var dependencies: [String: String] = [:]
	public var dependencyVersions: [String: Int] = [:]
}

let data = try? Data(contentsOf: URL(fileURLWithPath: "package.json"))
let pack = try JSONDecoder().decode(LoadablePackage.self, from: data!)

let package = Package(
    name: pack.name, targets: [],
    dependencies: pack.dependencies.map { (lib, url) in
      return .Package(url: url, majorVersion: pack.dependencyVersions[lib] ?? 0 ) 
    }
)
