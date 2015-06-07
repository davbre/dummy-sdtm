require 'rubygems'
require 'bundler/setup'
require 'faker'
require 'pry'
require 'active_model'
require 'active_support/core_ext' # for some time functions and more
require 'time'
require 'yaml'
require 'pp'
require 'simple-random'

require_relative 'lib/init.rb'
require_relative 'generators/init.rb'

study = YAML.load(File.read('config/dummy_study.yml'))
study.assign_random_investigator_names

srand 1234                         # set a seed to give reproducability of 'randomly' assigned variables
# ref_date = DateTime.new(2014,3,1)  # reference date/study start
controlled_terms = YAML::load_file "config/controlled_terms.yml"
lab_parameters = YAML::load_file "config/lab_parameters.yml"

dm = gen_dm(study,controlled_terms)
sv = gen_sv(study,controlled_terms,dm)
ex = gen_ex(study,controlled_terms,dm,sv)
lb = gen_lb(study,controlled_terms,sv,lab_parameters)

File.open("output/#{study.studyid}_dm.yml", 'w') {|f| f.write(YAML.dump(dm)) }
File.open("output/#{study.studyid}_sv.yml", 'w') {|f| f.write(YAML.dump(sv)) }
File.open("output/#{study.studyid}_ex.yml", 'w') {|f| f.write(YAML.dump(ex)) }
File.open("output/#{study.studyid}_lb.yml", 'w') {|f| f.write(YAML.dump(lb)) }

# usbjids
# binding.pry

