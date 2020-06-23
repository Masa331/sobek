# "A very strong secret password :)" : "412076657279207374726f6e67207365637265742070617373776f7264203a29"
module Sobek
  class HexViewer
    class Line
      attr_reader :raw

      def initialize(raw)
        @raw = raw
      end

      def length
        raw.length
      end

      def hexa
        raw.scan(/.{2}/).map do |hex|
          Hex.new hex.to_i 16
        end
      end

      def ascii
        raw.scan(/.{2}/).map do |hex|
          Ascii.new hex.to_i 16
        end
      end
    end

    module Classifications
      def type
        case dec
        when 0 then :null # => grey 242, '0'
        when 1..31, 127 then :non_printable # => magenta 197, '•'
        when 32..126 then :printable # => cyan 81, original
        else :non_ascii # => orange 208, '×'
        end
      end

      def null?
        type == :null
      end

      def non_printable?
        type == :non_printable
      end

      def printable?
        type == :printable
      end

      def non_ascii?
        type == :non_ascii
      end
    end

    class Hex
      include Classifications

      attr_reader :dec

      def initialize(dec)
        @dec = dec
      end

      def to_s
        dec.to_s 16
      end
    end

    class Ascii
      include Classifications

      attr_reader :dec

      def initialize(dec)
        @dec = dec
      end

      def to_s
        case type
        when :null # => grey 242, '0'
          '0'
        when :non_printable # => magenta 197, '•'
          '•'
        when :printable # => cyan 81, original
          dec.chr
        else # => orange 208, '×'
          '×'
        end
      end
    end

    def initialize(string)
      @string = string
    end

    def lines
      lines = @string.scan(/.{64}/).map do |raw|
        Line.new raw
      end

      formatted_lines = lines.map do |line|
        { separated: line.hexa.join(' '),
          ascii: line.ascii.join('')
        }
      end
    end

    def formatted_lines
      lines.map do |line|
        [line[:separated], line[:ascii]].join(' | ')
      end
    end

    def print
      formatted_lines.each do |line|
        puts line
      end
    end
  end
end
