class HangtagKit
  
  require 'csv'
  require 'find'
  require 'fileutils'
  require_relative 'kit_xml'
  
  def parse_csv(raw_kit_data)
    csv_data = CSV.read(raw_kit_data)
    headers = csv_data.shift.map {|i| i }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    @kit_data_hash = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end
  
  def all_tags_exist?
    
    tag_not_found = Hash.new
    @tag_file_name = Hash.new
    @kits = Hash.new
    kit_rm_number = String.new
    
    @kit_data_hash.each do |row|
      
      kit_files = Array.new
      
      row.each do |key, tag_info|
        
        unless tag_info.eql?("")
          rm_number = tag_info.split.fetch(0)

          if key.eql?("Hangtag Kit 1#")
            kit_rm_number = rm_number
          else
            
            kit_files << "/Users/brett_piatt/Devel/HangTags/S13/Kits/PDF/#{rm_number}.pdf"
            
            if File.exists?("./Tags/InDD/#{rm_number}.indd")
              @tag_file_name[rm_number] = "./Tags/InDD/#{rm_number}.indd"
            elsif File.exists?("./Tags/PDF/#{rm_number}.pdf")
              @tag_file_name[rm_number] = "./Tags/PDF/#{rm_number}.pdf"
            else
              tag_not_found[rm_number] = tag_info
            end
            
          end
        end
        
      end
      
      @kits[kit_rm_number] = kit_files
      
    end
    
    if tag_not_found.length > 0
      puts
      puts "Could not find InDD or PDF files for the following tags"
      puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
       
      tag_not_found.each do |key, value|
        puts value
      end
      
      puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      
      return false
    
    else
      return true      
    end
  
  end
  
  def copy_tag_files
    @tag_file_name.each do |key, full_file_name|
      if full_file_name.match("pdf")
        FileUtils.cp(full_file_name, "./Tags/Collected/PDF/")
      else
        FileUtils.cp(full_file_name, "./Tags/Collected/InDD/")
      end
    end 
  end
  
  def create_kit_files
    
    @kits.each do |key, tags|
      FileUtils.cp("./Template/kit.indd", "./kit_InDD/#{key}.indd")
      kit_xml = KitXml.new
      kit_xml.create(key, tags)
    end
    
  end
  
end