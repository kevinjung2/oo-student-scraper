require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    name = doc.css("h4.student-name").map{ |student| student.text }
    location = doc.css("p.student-location").map{ |location| location.text }
    url = doc.css("a").map{ |student| student["href"] }
    url.shift
    name.each.with_index do |student, inx|
      students << {name: student, location: location[inx], profile_url: url[inx]}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile = {
    :profile_quote=>doc.css("div.profile-quote").text,
    :bio=>doc.css("p").text
    }
    doc.css("div.social-icon-container").children.css("a").each do |a|
      profile[:twitter] = a.attributes['href'].value if a.children[0].values[1] == "../assets/img/twitter-icon.png"
      profile[:linkedin] = a.attributes['href'].value if a.children[0].values[1] == "../assets/img/linkedin-icon.png"
      profile[:github] = a.attributes['href'].value if a.children[0].values[1] == "../assets/img/github-icon.png"
      profile[:blog] = a.attributes['href'].value if a.children[0].values[1] == "../assets/img/rss-icon.png"
    end
    profile
  end

end
