#!/usr/bin/env ruby

require_relative 'hangtag_kit'
require 'fileutils'

unless File.directory?("./Tags/")
  raise "Could not find the ./Tags/! This directory must exist and contain all the needed tag files!"
end


print "Path to kit csv data? "
kit_data_file_name = gets.chomp

print "Path to tag PDFs? "
tag_PDF_path = gets.chomp

# Check to see if an XML directory already exists
if (Dir.exists?("./XML"))
  print "XML directory already exists! Delete Directory (y|n)? "
  deleteXMLDir = gets.chomp.downcase;
  
  if deleteXMLDir.include?('y')
    puts "Deleting XML directory!"
    FileUtils.rm_r './XML'
  else 
    puts "Exiting Script!"
    Process.exit
  end
end

unless tag_PDF_path.match("/.+\/$")
  tag_PDF_path += "/"
end

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
  kits.create_kit_files(tag_PDF_path)
else
  puts
  puts "* * * * * * * * * * * * * * * * * * * *"
  puts "All tags could not be found EXITING!"
  puts "* * * * * * * * * * * * * * * * * * * *"
  puts
end

