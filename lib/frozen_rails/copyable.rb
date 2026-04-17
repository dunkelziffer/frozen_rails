module Copyable
  extend ActiveSupport::Concern

  private

  def copy_directory(source, target, hidden: true, **options)
    base = File.join(self.class.source_root, source)

    glob_options = hidden ? [ File::FNM_DOTMATCH ] : []

    Dir.glob("#{base}/**/*", *glob_options).each do |path|
      next if File.directory?(path)
      next if hidden && (File.basename(path) == "." || File.basename(path) == "..")

      rel = path.delete_prefix("#{base}/")
      copy_file "#{source}/#{rel}", "#{target}/#{rel}", **options
    end
  end
end
