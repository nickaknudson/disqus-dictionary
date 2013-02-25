#!/usr/bin/env ruby

def word_exists_in_file(regexp)
  suggestion1, suggestion2 = nil
  f = File.open("/usr/share/dict/words", "r") #opens the file for reading
  f.each do |line|
    #print line
    if line.match regexp[0]
      return line
    elsif line.match regexp[1]
      suggestion1 = line
    elsif line.match regexp[2]
      suggestion2 = line
    end
  end
  if suggestion1 != nil
    return suggestion1
  elsif suggestion2 != nil
    return suggestion2
  else
    return "No Suggestion"
  end
end

def string_to_regexp(string)
  regexp = Array.new
  # exact match
  regexp.push Regexp.new "^#{string}$"

  # repeated letter match
  regexpstr = String.new("^")
  string.squeeze.each_char do |c|
    regexpstr.concat("#{c}+")
  end
  regexpstr.concat("$")
  regexp.push Regexp.new regexpstr, true

  # vowel substitution match
  regexpstr = String.new("^")
  vowels = ['a', 'e', 'i', 'o', 'u']
  string.squeeze.each_char do |c|
    if vowels.include? c
      regexpstr.concat("(a|e|i|o|u)+")
    else
      regexpstr.concat("#{c}+")
    end
  end
  regexpstr.concat("$")
  regexp.push Regexp.new regexpstr, true

  # return regexps
  return regexp
end

puts "Welcome to dictionary."
while true
  input = [(print '> '), gets.rstrip][1]
  regexp = string_to_regexp input
  puts word_exists_in_file regexp
end
