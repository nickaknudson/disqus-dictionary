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

def exact_match(word, hash)
  if hash.key? word[0]
    result = traverse_hash(word[1..-1], hash[word[0]])
    if result != nil
      return word[0] + result
    end
  end
  return nil
end

def match(word, hash)
  # exact match
  result = exact_match(word, hash)
  if result != nil
    return result
  else
    # capital match
    return exact_match(word.capitalize, hash)
  end
end

def vowel_match(word, hash)
  vowels = ['a', 'e', 'i', 'o', 'u']
  if vowels.include? word[0]
    vowels.delete word[0]
    vowels.each do |v|
      # traverse at same level
      result = match(v + word[1..-1], hash)
      if result != nil
        return result
      end
    end
  end
  return nil
end

def repeat_match(word, hash)
  if !word.squeeze.eql?(word)
    # single letter
    result = traverse_hash(word.squeeze, hash)
    if result != nil
      return result
    else
      # double letter
      result = match(word[0] + word.squeeze, hash)
      if result != nil
        return result
      end
    end
  end
  return nil
end

def traverse_hash(word, hash)
  if word.empty?
    if hash.key? 1 # we found a complete word
      return hash[1]
    end
  else
    # match
    result = match(word, hash)
    if result != nil
      return result
    else
      # repeated letter match
      result = repeat_match(word, hash)
      if result != nil
        return result
      else
        # vowel match
        result = vowel_match(word, hash)
        if result != nil
          return result
        end
      end
    end
  end
  return nil
end

def word_exists_in_hash(word, hash)
  result = traverse_hash word, hash
  if result != nil
    return result
  else
    return "No Suggestion"
  end
end

def format_input(input)
  input.chomp!
  input.strip!
  input.downcase!
  if input.ascii_only?
    return input
  else
    raise ArgumentError, "Not ASCII", caller
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


puts "Welcome to dictionary."
dict = load_dictionary
while true
  input = generate_word(dict)
  [(print "> #{input}"), gets.rstrip][1]
  finput = format_input input
  puts word_exists_in_hash finput, dict
end
