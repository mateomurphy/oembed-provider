module XmlFormatter
  def self.call(object, env)
    object.to_xml root: 'oembed', dasherize: false
  end
end
