import PackageDescription
import Foundation

struct LoadablePackage: Codable {
  public var name = ""
  public var dependencies: [String: Int] = [:]
	public var urls: [String: String] = [:]
	public var caches: [String: String] = [:]
}

let data = try? Data(contentsOf: URL(fileURLWithPath: "package.json"))
let pack = try JSONDecoder().decode(LoadablePackage.self, from: data!)

let package = Package(
    name: pack.name, targets: [],
    dependencies: pack.dependencies.map { (lib, version) in
      let path: String
      if let cache = pack.caches[lib],
					let dir = opendir(cache) {
        path = cache
        closedir(dir)
      } else {
        path = pack.urls[lib] ?? ""
      }
      return .Package(url: path, majorVersion: pack.dependencies[lib] ?? 0 ) 
    }
)
