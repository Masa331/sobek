module Sobek
  class HexViewer
    def initialize(string)
      @string = string
    end

    def call
      lines = @string.scan /.{64}/

      lines.map do |line|
        { separated: line.scan(/.{2}/).join(' '),
          ascii: 

        }
      end
    end

    private


  end
end
