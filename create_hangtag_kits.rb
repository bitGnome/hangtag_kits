#!/usr/bin/env ruby

require_relative 'hangtag_kit'

print "Path to kit csv data? "
kit_data_file_name = gets.chomp

begin
  kit_data_file = File.new(kit_data_file_name, "r")
rescue
  puts "Could not find kit_data_file located at : #{kit_data_file_name} - EXITING SCRIPT!!!"
  exit
end

kits = HangtagKit.new
kits.parse_csv(kit_data_file)

if kits.all_tags_exist?
  puts "Copying All Tag Files"
  kits.copy_tag_files
  puts "Creating the Kit InDD files"
  kits.create_kit_files
else
  puts
  puts "* * * * * * * * * * * * * * * * * * * *"
  puts "All tags could not be found EXITING!"
  puts "* * * * * * * * * * * * * * * * * * * *"
  puts
end

