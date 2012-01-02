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
end