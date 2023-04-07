# Quick script for pulling Player Names from CSV File
# TODO Improvement for Later as a Rake Task
require 'csv'

pros = CSV.parse(File.read("mastersPlayerRankings2013.csv"), headers: true)

puts "==========PROS============"
print pros["player"]
