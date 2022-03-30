class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      self.define_method("#{name}")  do
        self.instance_variable_get("@#{name}") 
      end
  

      self.define_method("#{name}=") do |arg| 
        self.instance_variable_set("@#{name}", arg)
      end
    end

  end
end
