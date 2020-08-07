require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'string'


describe String do
	context '#to_german_s' do
    it 'should change . tp ,' do
      string = 2.5
      expect(string.to_german_s).to eq('2,5')
    end
	end
end