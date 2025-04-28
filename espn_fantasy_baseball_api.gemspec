Gem::Specification.new do |spec|
  spec.name        = "espn_fantasy_baseball_api"
  spec.version     = "0.1.0"
  spec.authors     = ["zmoses"]
  spec.email       = ["zmoses93@gmail.com"]
  spec.summary     = "API wrapper for interacting with ESPN Fantasy Baseball teams"
  spec.description = "API wrapper for interacting with ESPN Fantasy Baseball teams"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "README.md"]
  end
end