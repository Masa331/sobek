require 'sobek'

String.include Sobek::StringUtils
Array.include Sobek::ArrayUtils
Integer.include Sobek::IntegerUtils

module DarkMagic
  def q=(result)
    $sobek_last_hex = result
  end

  def q
    $sobek_last_hex
  end

  def method_missing(name, *args)
    if name.to_s.hex_bytes?
      res = name.to_s
      self.q = res

      res
    else
      super
    end
  end

  def respond_to?(name, _ = false)
    name.to_s.hex_bytes? || super
  end
end

Object.include DarkMagic
