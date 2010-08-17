#
# This module adds one method to String that will
# convert the string to a signed ebcdic integer
# ebcdic is just the use of the last digit in a string
# as a signed character.
#
#
module EbcdicConverter
  EBCDICPOS = {
             'A'  =>  '1',
             'B'  =>  '2',
             'C'  =>  '3',
             'D'  =>  '4',
             'E'  =>  '5',
             'F'  =>  '6',
             'G'  =>  '7',
             'H'  =>  '8',
             'I'  =>  '9',
             '{'  =>  '0'
  }
  EBCDICNEG = {
             'J'  => '1',
             'K'  => '2',
             'L'  => '3',
             'M'  => '4',
             'N'  => '5',
             'O'  => '6',
             'P'  => '7',
             'Q'  => '8',
             'R'  => '9',
             '}'  =>  '0'
  }
  EBCDIC = EBCDICPOS.merge(EBCDICNEG)
end

class String
  # extends the string class to convert
  # one ebcdic representation to a number
  # For example:
  #
  # '12C' => 123
  # '12L' => -123
  #
  def ebcdic_to_i(*options)
    unless options.empty?
      @strict = options[0][:strict]
    end
    stripped_me = strip
    if stripped_me.size > 0
      last_digit = stripped_me[-1..-1]
      last_digit =~ /^\d$/ ?
        stricted(stripped_me.to_i) :
        one_char_to_ebcdic(stripped_me)
    else
      0
    end
  end

  # Converts existing number to ebcdic. 
  # For example
  #
  # '123'  => '12C'
  # '-123' => '12L'
  def to_ebcdic
    new_str = self.dup
    self[0..0] == '-' ?
      new_str[1..-2] << EbcdicConverter::EBCDICNEG.invert[new_str[-1..-1]] :
      new_str[0..-2] << EbcdicConverter::EBCDICPOS.invert[new_str[-1..-1]]
  end


  private 

  def stricted(integer)
    if @strict
      raise "Invalid EBCDIC Numberin #{self.to_s}"
    else
      integer
    end
  end

  def one_char_to_ebcdic(stripped_me)
    last_digit = stripped_me[-1..-1]
    EbcdicConverter::EBCDICPOS.keys.include?(last_digit) ?
      unsigned_ebcdic(stripped_me) :
      unsigned_ebcdic(stripped_me) * -1
  end

  def unsigned_ebcdic(stripped_me)
    (stripped_me[0..-2]+EbcdicConverter::EBCDIC[stripped_me[-1..-1]]).to_i
  end
end
