require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'float'


describe Float do
	context '#to_german_s' do
    it 'should change . tp ,' do
      float = 2.5
      expect(float.to_german_s).to eq('2,5')
    end
	end
end
