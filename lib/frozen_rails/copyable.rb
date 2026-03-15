module Copyable
  extend ActiveSupport::Concern

  private

  def copy_directory(source, target, **options)
    base = File.join(self.class.source_root, source)
    Dir.glob("#{base}/**/*").each do |path|
      next if File.directory?(path)
      rel = path.delete_prefix("#{base}/")
      copy_file "#{source}/#{rel}", "#{target}/#{rel}", **options
    end
  end
end
