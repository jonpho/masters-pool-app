# Quick script for pulling Player Names from CSV File
# TODO Improvement for Later as a Rake Task
require 'csv'

pros = CSV.parse(File.read("Masters2023Pros.csv"), headers: true)
amateurs = CSV.parse(File.read("Masters2023Amateurs.csv"), headers: true)

puts "==========PROS============"
print pros["INVITEES"]
puts "========Amateurs=========="
print amateurs["INVITEES"]
