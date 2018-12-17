module Sobek
  module ArrayUtils
    def desc
      each_with_index do |part, index|
        puts "#{part}, part#{index}: #{part._desc}"
      end

      self
    end
  end
end
