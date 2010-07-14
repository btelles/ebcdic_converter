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
             'R'  => '9'
  }
  EBCDIC = EBCDICPOS.merge(EBCDICNEG)
end

class String
  def ebcdic_to_i
    stripped_me = strip
    if stripped_me.size > 0
      last_digit = stripped_me[-1..-1]
      last_digit =~ /^\d$/ ?
        stripped_me.to_i :
        to_ebcdic(stripped_me)
    else
      0
    end
  end

  private 

  def to_ebcdic(stripped_me)
    last_digit = stripped_me[-1..-1]
    EbcdicConverter::EBCDICPOS.keys.include?(last_digit) ?
      unsigned_ebcdic(stripped_me) :
      unsigned_ebcdic(stripped_me) * -1
  end

  def unsigned_ebcdic(stripped_me)
    (stripped_me[0..-2]+EbcdicConverter::EBCDIC[stripped_me[-1..-1]]).to_i
  end
end
