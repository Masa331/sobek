require 'sobek'

String.include Sobek::StringUtils
Array.include Sobek::ArrayUtils

module DarkMagic
  def r=(result)
    $last_sob_result = result
  end

  def r
    $last_sob_result
  end

  def s=(result)
    $last_hex_string = result
  end

  def s
    $last_hex_string
  end

  def d
    $last_sob_result.desc if $last_sob_result
  end

  def method_missing(name, *args)
    if name.to_s.hex_bytes?
      res = name.to_s
      self.s = res

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
