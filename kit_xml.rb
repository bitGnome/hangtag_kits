class KitXml
  
  require 'builder'
  
  def initialize
    # If the XML directory does not exist create one
    unless File.directory?("./XML")
      Dir.mkdir("./XML")
    end
  end
  
  def create(kit_rm, tags)
    
    # Create the XML files
    xml_file_name = "./XML/#{kit_rm}.xml"
    xml_file = File.new(xml_file_name, File::CREAT|File::RDWR)
    
    xml = Builder::XmlMarkup.new(:target => xml_file, :indent => 1)
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    
    xml.Root( "xmlns:aid" => "http://ns.adobe.com/AdobeInDesign/4.0/" ) do
      xml.Kit_Header("Kit# #{kit_rm}", "aid:pstyle"  => "Kit_Header")
      
      tag_index = 0
      
      tags.each do |tag|
        xml.tag!("tag#{tag_index}", "href"  => tag)
        tag_index += 1
      end

    end
    
    xml_file.close
    
  end
  
end