module Sobek
  module IntegerUtils
    def self.included(mod)
      # To show quickly over/under flows
      (8..256).step(8) do |step|
        define_method "to_uint#{step}" do
          self % (2 ** step)
        end
      end
    end

    def gwei
      self * 1_000_000_000
    end
  end
end
