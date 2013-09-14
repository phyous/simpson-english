#!/usr/bin/env ruby

# Command line parameters
NUM_SENTENCES =  ARGV[0].nil? ? 1 : ARGV[0].to_i
DICTIONARY_FILE = ARGV[1] || File.dirname(__FILE__) + "/simpson_frequencies.txt"

# Constants constants specific to simpsons_frequencies.txt
DICTIONARY_START_LINE = 5
DICTIONARY_REGEX = /^(\d*)\s*(\S*)\s*\((\d*)\)/
WORD_CAPTURE_GROUP = 2
FREQUENCY_CAPTURE_GROUP = 3

def parse_dictionary(file)
  # Get all lines starting from where dictionary begins
  words = File.open(file).readlines[DICTIONARY_START_LINE..-1]

  # Parse each word and put it in a frequency keyed dictionary
  dictionary = {}
  words.each do |dictionary_entry|
    parsed_entry = DICTIONARY_REGEX.match(dictionary_entry).to_a
    word = parsed_entry[WORD_CAPTURE_GROUP]
    frequency = parsed_entry[FREQUENCY_CAPTURE_GROUP].to_i
    if dictionary.include? frequency
      dictionary[frequency] += [word]
    else
      dictionary[frequency] = [word]
    end
  end
  dictionary
end

# Given a dictionary, get a random word weighted by frequency
def get_weighted_word(dictionary, sample_space)
  sample_point = Random.rand(sample_space)
  i = 0
  str = ""
  dictionary.each_pair do |freq, words|
    words.each do |word|
      i += freq
      str = word
      return word if (i > sample_point)
    end
  end
  str
end

def get_total_frequencies(dictionary)
  dictionary.inject(0) { |sum, n| sum + n[0]*n[1].size }
end

def generate_sentence(length, dictionary)
  total_count = get_total_frequencies(dictionary)
  (1..length).map {get_weighted_word(dictionary, total_count) }.join(' ').capitalize + "."
end

# Default to a sentence between 3-11 words
def sentence_length
  Random.rand(9)+3
end

dictionary = parse_dictionary(DICTIONARY_FILE)
NUM_SENTENCES.times{ puts generate_sentence(sentence_length, dictionary) }
