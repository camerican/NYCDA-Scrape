require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'

doc = Nokogiri::parse(open("http://nycda.com/team", :allow_redirections => :safe))

# We'll load employees into a global employees variable for examination
# within our IRB terminal
$employees = []

# We'll define a basic employee object we can capture information within
class Employee
  def initialize options = {}
    @name = options[:name]
    @title = options[:title]
    @location = options[:location]
    @profile = options[:profile]
    @image = options[:image]
  end
end

doc.css('.team_member_listing').each_with_index do |employee,index|
  p employee.at_css('.caption span a').text
  p employee.at_css('.caption span a')[:href]
  p employee.at_css('.bio').text.strip.split("\n")[0]
  p employee.at_css('.city a').text.strip.split("\n")[0]
  p employee.at_css('.image_link')[:style].match(/url\(([^\)]+)\)/)[1]
  p "-------------------#{index}-----------------------"
  $employees.push(Employee.new(
    name: employee.at_css('.caption span a').text,
    profile: employee.at_css('.caption span a')[:href],
    title: employee.at_css('.bio').text.strip.split("\n")[0],
    location: employee.at_css('.city a').text.strip.split("\n")[0],
    image: employee.at_css('.image_link')[:style].match(/url\(([^\)]+)\)/)[1]
  ))
end
#p doc