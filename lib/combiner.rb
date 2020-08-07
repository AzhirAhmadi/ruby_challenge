# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements

require 'pry'
class Combiner

	def initialize(&key_extractor)
		@key_extractor = key_extractor
	end

	def key(value)
		value.nil? ? nil : @key_extractor.call(value)
	end
	
	def combine(*enumerators)
		Enumerator.new do |yielder|
			last_values = Array.new(enumerators.size)
			done = enumerators.all? { |enumerator| enumerator.nil? }
			while not done
				last_values, enumerators = fetch_next(last_values, enumerators)

				done = enumerators.all? { |enumerator| enumerator.nil? } and last_values.compact.empty?
				unless done
					last_values, values = get_mins_list(last_values)
					yielder.yield(values)
				end
			end
		end
	end

	def fetch_next(last_values, enumerators)
		last_values.each_with_index do |value, index|
			if value.nil? and not enumerators[index].nil?
				begin
					last_values[index] = enumerators[index].next
				rescue StopIteration
					enumerators[index] = nil
				end
			end
		end
		return last_values, enumerators
	end

	def get_mins_list(last_values)
		min_key = last_values.map { |e| key(e) }.min{|a, b| compare(a, b)} 

		values = Array.new(last_values.size)

		last_values.each_with_index do |value, index|
			if key(value) == min_key
				values[index] = value
				last_values[index] = nil
			end
		end
		return last_values, values
	end

	def compare(a, b)
		if a.nil? and b.nil?
			0
		elsif a.nil?
			1
		elsif b.nil?
			-1
		else
			a <=> b
		end
	end
end