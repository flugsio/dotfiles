#!/usr/bin/env ruby
# encoding: utf-8

def main(hex_string)
  hex_string ||= "FFFF"

  if hex_string.include?(".")
    first, second = hex_string.split('.')
    puts convert(first, true) + "|" + convert(second, false)
  else
    puts convert(hex_string, true)
  end
end

def convert(str, left_padding = true)
  ret = ""
  binary = str.to_i(16).to_s(2)
  if left_padding
    binary = binary.rjust(binary.length+(8-binary.length%8), "0")
  else
    binary = binary.rjust(binary.length+(4-binary.length%4), "0")
    binary = binary.ljust(binary.length+(8-binary.length%8), "0")
  end
  binary.chars.each_slice(8) do |a|
    n = 0x2800 +
      0x80 * a[7].to_i +
      0x20 * a[6].to_i +
      0x10 * a[5].to_i +
      0x8  * a[4].to_i +
      0x40 * a[3].to_i +
      0x4  * a[2].to_i +
      0x2  * a[1].to_i +
      0x1  * a[0].to_i
    ret += [n].pack("U")
  end
  ret#.encode('utf-8')
end


class Array
  def rjust!(n, x)
    insert(0, *Array.new([0, n-length].max, x))
  end

  def ljust!(n, x)
    fill(x, length...n)
  end
end

main ARGV.length > 0 ? ARGV[0] : ARGF.read

