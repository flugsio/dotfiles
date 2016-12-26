require 'rake'
require 'erb'
require 'socket'

desc "install the dot files into user's home directory"
task :install do
  files_to_install.each do |file|
    process(file)
  end

  install_vundle
end

def install_vundle
  vundle_path = File.join(ENV['HOME'], ".vim/bundle/Vundle.vim")
  if not Dir.exist?(vundle_path)
    puts "Installing vundle"
    system "git clone https://github.com/gmarik/Vundle.vim.git #{vundle_path}"
  end
  system "vim -c VundleInstall -c qa"
end

def files_to_install
  excluded_files = %w[Rakefile README.rdoc LICENSE config baseq3 slash cmus]

  Dir['*', 'config/*', 'cmus/*'].map { |file|
    next if excluded_files.include? file

    def file.target
      if %w[bin].include? self
        prefix = ""
      else
        prefix = "."
      end
      File.join(ENV['HOME'], "#{prefix}#{self.sub('.erb', '')}")
    end
    file
  }.compact
end


def process(file)
  replace_all = false
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

def replace_file(file)
  system %Q{rm -rf "#{file.target}"}
  link_file(file)
end

def link_file(file)
  # sent implicit through binding
  hostname = Socket.gethostname

  if file =~ /.erb$/
    puts "generating #{file.target}"
    File.open(file.target, 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking #{file.target}"
    system %Q{ln -s "$PWD/#{file}" "#{file.target}"}
  end
end

