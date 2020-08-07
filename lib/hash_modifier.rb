class HashModifier
  attr_accessor :key_list, :procedure

  def initialize(key_list ,procedure)
    @key_list = key_list
		@procedure = procedure
  end
  
  def modify(hash)
    result = hash.clone
    key_list.each do |key|
      result[key] = procedure.call(hash[key])
    end
    
    result
  end
end