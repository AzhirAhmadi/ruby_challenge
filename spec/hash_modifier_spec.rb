require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'hash_modifier'
require 'pry'


describe HashModifier do
	context "#call" do
      it "should apply changes to all hash elements" do

        hash = {key1: 1, key2: 2}
        
        hash_modifier = HashModifier.new hash.keys, (Proc.new {|value| value*10})

        new_hash = hash_modifier.modify(hash)

        new_hash.each do |key, value|
          expect(value).to eq(hash[key]*10)
        end
      end

      it "should apply changes to selected hash elements " do

        hash = {key1: 1, key2: 2}
        
        hash_modifier = HashModifier.new %i(key1), (Proc.new {|value| value*10})
        
        new_hash = hash_modifier.modify(hash)

        new_hash.slice(:key1) do |key, value|
          expect(value).to eq(hash[key]*10)
        end

        new_hash.slice(:key2) do |key, value|
          expect(value).to eq(hash[key])
        end
      end
	end
end
