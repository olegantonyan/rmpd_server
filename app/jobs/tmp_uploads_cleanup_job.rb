class TmpUploadsCleanupJob < ApplicationJob
  def perform
    Dir.glob(Upload.tmp_path.join('**', '*')).reject { |f| File.directory?(f) }.each do |f|
      File.delete(f) if (Time.current - File.mtime(f)) > 604_800 # 7 days
    end
  end
end
