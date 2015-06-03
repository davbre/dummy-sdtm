require 'rubygems'
require 'bundler/setup'
require 'faker'
require 'pry'

studyid = "ABC1"
treatments = ["PBO", "Trt 1"]
treatment_ratio = [0.5, 0.5]
total_subjects = 50
sites = [ ["FRA", "Paris", "Nice"],
          ["DEU", "Berlin"],
          ["GBR", "London", "Manchester"] ]
# max sites in any country
max_sites = sites.map { |s| s.length }.max

# Assign investigator names to sites and initialize a count of subjects
# assigned to them
investigators = []
sites.each do |country|
  tmparr = []
  country.each do |site|
    tmparr << ["Dr. " + Faker::Name.name, 0]
  end
  investigators << tmparr
end


usubjids = []
total_subjects.times do |i|

  country_num = rand(1..sites.length)
  site_num = rand(1..sites[country_num-1].length)

  siteid = country_num.to_s + \
           site_num.to_s.rjust(max_sites.to_s.size+1,"0")

  invnam = investigators[country_num-1][site_num-1][0]
  # increment running count of subjects assinged to investigator
  subjnum = (investigators[country_num-1][site_num-1][1] += 1)
  country = sites[country_num-1]

  usubjid = studyid + "-" + siteid + "-" \
            + subjnum.to_s.rjust((sites.length+1).to_s.size,"0")
  usubjids << usubjid
  country = sites[site_num-1][0]
  puts usubjid + " " + country + " " + invnam
end

# usubjids
# binding.pry


