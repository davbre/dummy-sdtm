require 'rubygems'
require 'bundler/setup'
require 'faker'
require 'pry'
require 'active_model'
require 'time'
require 'yaml'
require 'pp'

require_relative 'lib/helpers.rb'

studyid = "ABC1"
treatments = ["Placebo", "Treatment 1"]
treatment_codes = ["PBO", "TRT1"]
treatment_ratios = [0.5, 0.5]
total_subjects = 30
sites = [ ["FRA", "Paris", "Nice"],
          ["DEU", "Berlin"],
          ["GBR", "London", "Manchester"] ]
sexes = ["F", "M"]
srand 1234 # set a seed to give reproducability of 'randomized' treatments


# max sites in any country
max_sites = sites.map { |s| s.length }.max
# total number of sites
total_sites = sites.flatten.length - sites.length

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


class SdtmDm
  include ActiveModel::Validations

  attr_accessor :studyid, :siteid, :usubjid, :invnam, :country, :sex, :armcd, :arm, :actarmcd, :actarm

  def initialize(studyid: nil, usubjid: nil, siteid: nil, invnam: nil, sex: nil, country: nil,
                 armcd: nil, arm: nil, actarmcd: nil, actarm: nil)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end    
  end

  validates_presence_of :studyid , :siteid, :usubjid, :invnam, :country, :sex, :armcd, :arm, :actarmcd, :actarm
  
end


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
            + subjnum.to_s.rjust((treatment_ratios.max*total_subjects/total_sites).floor.to_s.size+1,"0")
  country = sites[site_num-1][0]
  sex = sexes[rand(0..1)]

  arm_array_index = rand*treatments.length.floor
  armcd = treatment_codes[arm_array_index]
  arm = treatments[arm_array_index]

  # certain percentage screen failures
  if rand < 0.5 then
    actarmcd = "SCRNFAIL"
    actarm = "Screen Failure"
  else
    actarmcd = armcd
    actarm = arm
  end

  dm = SdtmDm.new(
                  studyid: studyid,
                  usubjid: usubjid,
                  siteid: siteid,
                  invnam: invnam,
                  sex: sex,
                  country: country,
                  armcd: armcd,
                  arm: arm,
                  actarmcd: actarmcd,
                  actarm: actarm
                 )
  pp dm
  pp dm.valid?
  # puts dm.errors.full_messages
end

# usubjids
# binding.pry


