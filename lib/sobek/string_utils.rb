module Sobek
  module StringUtils
    def sob
      replace(self[2..-1]) if start_with? '0x'

      raise ArgumentError, "doesn't look like hex bytes" unless hex_bytes?

      parse
    end

    def desc2
      viewer = HexViewer.new(self)
      viewer.print
    end

    def parse
      res =
        if method_call?
          parse_method_call
        else
          parse_rest
        end

      res = res.first if res.length == 1
      res
    end

    def hex_bytes?
      even = length.even?
      hex_chars = match? /\A[0-9a-f]*\z/

      even && hex_chars
    end

    def method_call?
      (length - 8) % 64 == 0
    end

    def parse_method_call
      signature = slice(0..7)
      arguments = slice(8..-1)

      [signature, *arguments.parse_rest]
    end

    def parse_rest
      scan /.{64}/
    end

    def desc
      puts _desc

      self
    end

    def _desc
      [length_in_words, *converts].join(', ')
    end

    def length_in_words
      "#{length} long"
    end

    def converts
      in_utf = to_utf ? "'#{to_utf}'" : 'nothing'
      ["#{to_decimal} in decimal", "#{in_utf} in utf8"]
    end

    def to_decimal
      to_i(16)
    end

    def to_utf
      in_utf = [self].pack('H*').force_encoding('utf-8')

      if in_utf.valid_encoding?
        in_utf.delete("\u0000").gsub(/[^[:print:]]/,'(imprintable)')
      end
    end

    def with_unprintable_characters?
      match?(/[^[:print:]]/)
    end

    # https://github.com/se3000/ruby-eth/blob/master/lib/eth/utils.rb
    def keccak256
      Digest::SHA3.new(256).digest(self).unpack1('H*')
    end

    def to_call_arg
      unpack1('H*').ljust(64, '0')
    end

    def to_function_signature
      keccak256[0..7]
    end

    def format_address
      if valid_address?
        Eth::Utils.format_address self
      else
        self
      end
    end

    def valid_address?
      Eth::Utils.valid_address? self
    end
  end
end

=begin
    def arguments?
      length % 32 == 0
    end

    def to_address
      gsub('0x', '').rjust(64, '0')
    end

    def to_hex_number
      to_i.to_s(16).rjust(64, '0')
    end

    def encode_uuid
      delete('-').rjust(64, '0')
    end

    def encode_quantity
      to_i.to_s(16).prepend('0x')
    end

    def int_from_hex
      gsub('0x', '').to_i(16)
    end

    def bool_from_hex
      to_i(16) == 1
    end
  end
=end
