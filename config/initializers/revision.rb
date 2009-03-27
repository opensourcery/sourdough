# Attempt to extract the currently running revision number.
# In production mode, attempts to use the Capistrano REVISION file.
# If development mode, attempts to use the .svn/entries file, then git-svn, and finally git-describe.
# If a revision can't be determined, the value is 'x'.
REVISION = begin
  revision_path = File.dirname(__FILE__) + '/../REVISION'
  entries_path = '.svn/entries'
  if ENV['RAILS_ENV'] == 'production'
    if File.exists?(revision_path)
      File.open(revision_path, "r") do |rev|
        rev.readline.chomp
      end
    end
  elsif ENV['RAILS_ENV'] == 'development'
    if File.exists?(entries_path)
      File.open(entries_path, "r") do |entries|
        entries.to_a[3].chomp
      end
    elsif File.exists? '.git'
      rev = 'x'
      # using detect so that success will short circuit
      [ "git svn find-rev HEAD", "git describe" ].detect do |cmd|
        possible_rev = `#{cmd}`
        rev = possible_rev.chomp if $?.success?
        $?.success?
      end
      rev
    else
      'x'
    end
  else
    'x'
  end
end

