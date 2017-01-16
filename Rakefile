require 'rake'

desc "install the dot files into user's home directory"
task :install do
  files_to_install.each do |file, link|
    process(file, link)
  end

  overrides.each do |file, link|
    process(file, link)
  end

  system('./install')
end

def files_to_install
  excluded_files = %w[install Rakefile README.rdoc LICENSE config baseq3 slash cmus overrides]
  without_prefix = %w[bin]

  Dir['*', 'config/*', 'cmus/*'].map { |file|
    next if excluded_files.include?(file)
    prefix = without_prefix.include?(file) ? "" : "."
    link = File.join(ENV['HOME'], "#{prefix}#{file}")
    [file, link]
  }.compact
end

def overrides
  replace_dir = "sed -r 's/^([^/]*\\/){2}/overrides\\/default\\//'"
  without_dir = "sed -r 's/^([^/]*\\/){2}//'"
  files = `(export overrides=$(find overrides/$(hostname) -type f); for f in $(echo $overrides | #{replace_dir}; find overrides/default -type f); do echo $f; done | sort | uniq -c | grep -P '^\\W*1 ' | sed -r 's/^\\s*[0-9]+\\s*//';) `.split("\n")

  files.map { |file|
    prefix = %w[bin].include?(file) ? "" : "."
    link = File.join(ENV['HOME'], "#{prefix}#{`echo #{file} | #{without_dir}`}")
    [file, link]
  }.compact
end

def process(file, link)
  replace_all = false
  if File.exist?(link)
    if File.identical? file, link
      puts "identical #{link}"
    elsif replace_all
      replace_file(file, link)
    else
      print "overwrite #{link}? [ynaq] "
      case $stdin.gets.chomp
      when 'a'
        replace_all = true
        replace_file(file, link)
      when 'y'
        replace_file(file, link)
      when 'q'
        exit
      else
        puts "skipping #{link}"
      end
    end
  else
    link_file(file, link)
  end
end

def replace_file(file, link)
  system %Q{rm -rf "#{link}"}
  #link_file(file)
end

def link_file(file, link)
  puts "linking #{file}, #{link}"
  #system %Q{ln -s "$PWD/#{file}" "#{link}"}
end

