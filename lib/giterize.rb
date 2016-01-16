class Giterize
  def initialize(path)
    @path = path
  end

  def process
    Dir.chdir(@path)
    `git init`
    commit_files
  end

  private

  def commit_files
    Dir.foreach(@path) do |file|
      next if [".", "..", ".git"].include?(file)
      new_name = drop_version(file)
      `mv #{file} #{new_name}; git add #{new_name}; git commit -m "adding #{file} as #{new_name}"`
    end
  end

  def drop_version(f)
    f.gsub(/_v\d+/, "")
  end
end
