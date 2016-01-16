require "rspec"
require "fileutils"
require "pry"
require_relative "../lib/giterize"

RSpec.describe Giterize do
  let(:base_path) { "/tmp/giterize" }
  let(:git_path) { "#{base_path}/.git" }

  before(:each) do
    FileUtils.rm_rf(base_path)
    Dir.mkdir(base_path)
  end

  after(:each) do
    FileUtils.rm_rf(base_path)
  end

  it "initializes a git repo" do
    Giterize.new(base_path).process
    expect(Dir.exist?(git_path)).to eq true
  end

  it "adds a commit for each file of each version" do
    write_files
    Giterize.new(base_path).process
    expect(`cd #{base_path}; git diff HEAD^..HEAD`).to include("-test", "+test2")
  end

  def write_files
    filename_1 = "#{base_path}/test_file_v1.txt"
    filename_2 = "#{base_path}/test_file_v2.txt"
    File.open(filename_1, "w+") { |f| f.puts "test" }
    File.open(filename_2, "w+") { |f| f.puts "test2" }
  end
end
