# Coefficients 2 JSON:
# Converts a plain text file containing a table of data to JSON

# Copyright (C) 2018  Scott Egerton

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require 'json'

path_input = 'coeffs.txt'
path_output = 'coeffs.json'

categories = { 'ALU' => %w[adds ands cmps eors movs orrs subs],
               'Shifts' => %w[lsls lsrs rors],
               'Stores' => %w[str strb strh],
               'Loads' => %w[ldr ldrb ldrh],
               'Multiplies' => %w[muls] }

coefficients_categories = %w[
  Previous_Instruction
  Subsequent_Instruction
  Operand1
  Operand2
  Bit_Flip1
  Bit_Flip2
  Hamming_Weight_Operand1_Previous_Instruction
  Hamming_Weight_Operand2_Previous_Instruction
  Hamming_Distance_Operand1_Previous_Instruction
  Hamming_Distance_Operand2_Previous_Instruction
  Hamming_Weight_Operand1_Subsequent_Instruction
  Hamming_Weight_Operand2_Subsequent_Instruction
  Hamming_Distance_Operand1_Subsequent_Instruction
  Hamming_Distance_Operand2_Subsequent_Instruction
  Operand1_Bit_Interactions
  Operand2_Bit_Interactions
  Bit_Flip1_Bit_Interactions
  Bit_Flip2_Bit_Interactions
]

def add_names(coefficients)
  categories_no_alu = %w[Shifts Stores Loads Multiplies]
  coefficients.map { |category| categories_no_alu.zip(category).to_h }
end

# Read in the file into a 2D array of floats
input = File.readlines(path_input).map do |line| # Read each line
  line.split.map(&:to_f) # Split each line into a list of numbers
end

# Keep the constants separate as these will not go under the Coefficients
# section.
constants = input.shift(1).transpose

grouped = []

# Get all of the coefficients from the input and store them stored by
# instruction category within the individual Coefficients category.
grouped.push(add_names(input.shift(4).transpose)) # Previous Instruction
grouped.push(add_names(input.shift(4).transpose)) # Subsequent Instruction
grouped.push(input.shift(32).transpose) # Operand 1
grouped.push(input.shift(32).transpose) # Operand 2
grouped.push(input.shift(32).transpose) # Bit Flip 1
grouped.push(input.shift(32).transpose) # Bit Flip 2
grouped.push(add_names(input.shift(4).transpose)) # Hamming Weights
grouped.push(add_names(input.shift(4).transpose))
grouped.push(add_names(input.shift(4).transpose))
grouped.push(add_names(input.shift(4).transpose))
grouped.push(add_names(input.shift(4).transpose)) # Hamming Distance
grouped.push(add_names(input.shift(4).transpose))
grouped.push(add_names(input.shift(4).transpose))
grouped.push(add_names(input.shift(4).transpose))
grouped.push(input.shift(496).transpose) # Bit interactions
grouped.push(input.shift(496).transpose)
grouped.push(input.shift(496).transpose)
grouped.push(input.shift(496).transpose)

# Build the data structure from the data
json = categories.each_with_index.map do |category, i|
  {
    category[0] =>
  {
    'Coefficients' =>
      coefficients_categories.each_index.map do |j|
        {
          coefficients_categories[j] => grouped[j][i]
        }
      end.inject(:merge),
    'Constant' => constants[i].reduce,
    'Instructions' => category[1]
  }
  }
end.inject(:merge)

# Open the output file for writing
# (This will create it if it doesn't already exist)
output_file = File.open(path_output, 'w')

# Generate the JSON and save it to the output file as well as write it to stdout
output_file.puts JSON.pretty_generate(json)
puts JSON.pretty_generate(json)
