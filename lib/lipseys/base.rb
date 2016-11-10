module Lipseys
  class Base

    protected

    # Wrapper to `self.requires!` that can be used as an instance method.
    def requires!(*args)
      self.class.requires!(*args)
    end

    def self.requires!(hash, *params)
      params.each do |param|
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first)

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of: #{valid_options.join(', ')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param)
        end
      end
    end

    def content_for(xml_doc, field)
      node = xml_doc.css(field).first
      node.nil? ? nil : node.content.strip
    end

    def not_authenticated?(xml_doc)
      msg = content_for(xml_doc, 'CatalogError')
      msg =~ /Login failed/i
    end

  end
end