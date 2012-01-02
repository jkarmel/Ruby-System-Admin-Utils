require "fileutils"
require "shellwords"

module Scripting
  # Current User's home directory
  def self.Home
    File.expand_path '~'
  end 

  # Add lines to current User's bash profile and source. Should work for zsh
  # as well
  def self.append_and_source_bprofile(*bash_commands)
    self.append_to_file(self.Home + '/.bash_profile', *bash_commands)
    %x[source ~/.bash_profile]
  end

  def self.append_to_file(path, *strings)
    File.open(path, 'a') do |file|
      file.puts
      for string in strings 
        file.puts string
      end 
    end 
  end

  def self.headline(title)
    puts "\n\n**** #{title} ****\n"
  end

  def self.install_dmg dmg_file
    self.headline 'installing dmg at location ' + dmg_file
    # Command mounts volume and result a list of directories, the last
    # of which is the mounted volume
    mounted_volume = %x[hdiutil mount #{Shellwords.escape dmg_file}].split("\t")[-1][0..-2]
    puts "mounted volume #{mounted_volume}"
    Dir.new(mounted_volume).each do |relative_path|
      if relative_path.end_with? ".app" 
        FileUtils.cp_r mounted_volume + '/' +  relative_path, "/Applications"
        puts "installed application #{relative_path} to Applications directory"
      end 
    end
    Kernel.fork do 
      sleep 60 * 2 # Wait 2 mins to unmount
      %x[hdiutil unmount -force #{Shellwords.escape mounted_volume}]
    end
  end
end
