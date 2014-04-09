require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  excluded_files = %w[Rakefile README.rdoc LICENSE config flugsio.cfg]

  Dir['*', 'config/*'].each do |file|
    next if excluded_files.include? file

    def file.target
      if %w[bin].include? self
	prefix = ""
      else
	prefix = "."
      end
      File.join(ENV['HOME'], "#{prefix}#{self.sub('.erb', '')}")
    end
    
    if File.exist?(file.target)
      if File.identical? file, file.target
        puts "identical #{file.target}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite #{file.target}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping #{file.target}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm -rf "#{file.target}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating #{file.target}"
    File.open(file.target) do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking #{file.target}"
    system %Q{ln -s "$PWD/#{file}" "#{file.target}"}
  end
end

