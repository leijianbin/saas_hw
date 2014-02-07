module FunWithStrings
  def palindrome?
    # your code here
    str = self
    str = str.downcase.gsub(/[^a-z]*/, "")
    str == str.reverse 
  end
  
  def count_words
    # your code here
    str = self
    word_hash = Hash.new
    str.downcase.scan(/\b\w+\b/) do |word| 
      if word_hash.has_key?(word)
        word_hash[word] += 1
      else
        word_hash[word] = 1
      end
    end
    return word_hash
  end

  def anagram_groups
    # your code here
    str = self
    anagram_arr = Array.new
    str.scan(/\b\w+\b/) do |word|
      flag = false 
      anagram_arr.each do |group|
        word1 = word.downcase.split('').sort
        word2 = group[0].downcase.split('').sort
        if word1 == word2
          group << word
          flag = true
          break
        end
      end
      if !flag
        new_group = Array.new
        new_group << word
        anagram_arr << new_group
      end 
    end
    return anagram_arr
  end

end

# make all the above functions available as instance methods on Strings:

class String
  include FunWithStrings
end

