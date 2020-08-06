class KeyChecker
  attr_accessor :key_list, :procedure

  def initialize(key_list ,procedure)
    @key_list = key_list
		@procedure = procedure
  end
  
  def call(hash)
    key_list.each do |key|
      hash[key] = procedure.call(hash[key])
    end
  end
end