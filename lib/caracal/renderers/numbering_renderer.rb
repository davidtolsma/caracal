require 'nokogiri'

require 'caracal/core/models/list_style_model'
require 'caracal/core/models/list_model'
require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class NumberingRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------
      
      # This method produces the xml required for the `word/numbering.xml` 
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'w:numbering', root_options do
            
            # add abstract definitions
            document.toplevel_lists.each_with_index do |model, i|
              xml.send 'w:abstractNum', { 'w:abstractNumId' => i + 1 } do
                model.level_map.each do |(level, type)|
                  if s = document.find_list_style(type, level)
                    xml.send 'w:lvl', { 'w:ilvl' => s.style_level } do
                      xml.send 'w:start',      { 'w:val' => s.style_start }
                      xml.send 'w:numFmt',     { 'w:val' => s.style_format }
                      xml.send 'w:lvlRestart', { 'w:val' => s.style_restart }
                      xml.send 'w:lvlText',    { 'w:val' => s.style_value }
                      xml.send 'w:lvlJc',      { 'w:val' => s.style_align }
                      xml.send 'w:pPr' do
                        xml.send 'w:ind', { 'w:left' => s.style_left, 'w:firstLine' => s.style_indent }
                      end
                      xml.send 'w:rPr' do
                        xml.send 'w:u', { 'w:val' => 'none' }
                      end
                    end
                  end
                end
              end
            end
            
            # bind individual tables to abstract definitions
            document.toplevel_lists.each_with_index do |model, i|
              xml.send 'w:num', { 'w:numId' => i + 1 } do
                xml.send 'w:abstractNumId', { 'w:val' => i + 1 }
              end
            end
          end
          
        end
        builder.to_xml(save_options)
      end
      
      
      
      #-------------------------------------------------------------
      # Private Methods
      #------------------------------------------------------------- 
      private
      
      def root_options
        {
          'xmlns:mc'  => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
          'xmlns:o'   => 'urn:schemas-microsoft-com:office:office',
          'xmlns:r'   => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
          'xmlns:m'   => 'http://schemas.openxmlformats.org/officeDocument/2006/math',
          'xmlns:v'   => 'urn:schemas-microsoft-com:vml',
          'xmlns:wp'  => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
          'xmlns:w10' => 'urn:schemas-microsoft-com:office:word',
          'xmlns:w'   => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
          'xmlns:wne' => 'http://schemas.microsoft.com/office/word/2006/wordml',
          'xmlns:sl'  => 'http://schemas.openxmlformats.org/schemaLibrary/2006/main',
          'xmlns:a'   => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'xmlns:pic' => 'http://schemas.openxmlformats.org/drawingml/2006/picture',
          'xmlns:c'   => 'http://schemas.openxmlformats.org/drawingml/2006/chart',
          'xmlns:lc'  => 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas',
          'xmlns:dgm' => 'http://schemas.openxmlformats.org/drawingml/2006/diagram'
        }
      end
   
    end
  end
end