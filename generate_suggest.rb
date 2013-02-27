#!/usr/bin/env ruby

def perform_mutation(char)
  vowels = ['a', 'e', 'i', 'o', 'u']
  if rand(100) < 50 && vowels.include?(char)
    vowels.delete char
    char = vowels[rand(vowels.length)]
  end
  if rand(100) < 50
    char = char.swapcase
  end
  if rand(100) < 50
    char = char + char
  end
  return char
end

def rand_char(hash)
  keys = hash.keys
  return keys[rand(keys.length)]
end

def generate_word(hash)
  char = rand_char hash
  if char.eql?(1)
    return ''
  else
    if rand(100) < 40 # 40% chance of mutation
      mchar = perform_mutation char
    else
      mchar = char
    end
    return mchar + (generate_word(hash[char]))
  end
end

def build_word(word, hash)
  if word.empty?
    hash.store(1, '')
    return hash
  else
    if hash.key?(word[0])
      hash.store(word[0], build_word(word[1..-1], hash[word[0]]))
      return hash
    else
      hash.store(word[0], build_word(word[1..-1], Hash.new))
      return hash
    end
  end
end

def load_dictionary
  dict = Hash.new
  f = File.open("/usr/share/dict/words", "r") #opens the file for reading
  f.each do |line| 
    build_word line.chomp, dict
  end
  return dict
end


puts "Welcome to word generate."
dict = load_dictionary
while true
  input = [(print '> '), gets.rstrip][1]
  puts generate_word dict
end