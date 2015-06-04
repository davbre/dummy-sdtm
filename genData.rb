require 'rubygems'
require 'bundler/setup'
require 'faker'
require 'pry'
require 'active_model'
require 'active_support/core_ext' # for some time functions and more
require 'time'
require 'yaml'
require 'pp'

require_relative 'lib/init.rb'


study = YAML.load(File.read('config/dummy_study.yml'))
study.assign_random_investigator_names

srand 1234                         # set a seed to give reproducability of 'randomly' assigned variables
ref_date = DateTime.new(2014,3,1)  # reference date/study start
controlled_terms = YAML::load_file "config/controlled_terms.yml"

gen_dm(study,controlled_terms)

# binding.pry

# File.open("output/#{study.studyid}_dm.yml", 'w') {|f| f.write(YAML.dump(dm_dataset)) }

# usubjids
# binding.pry

