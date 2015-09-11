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
require 'csv'

require_relative 'lib/init.rb'
require_relative 'generators/init.rb'

study = YAML.load(File.read('config/dummy_study.yml'))
study.assign_random_investigator_names

srand 1234                         # set a seed to give reproducability of 'randomly' assigned variables
# ref_date = DateTime.new(2014,3,1)  # reference date/study start
controlled_terms = YAML::load_file "config/controlled_terms.yml"
lab_parameters = YAML::load_file "config/lab_parameters.yml"
ae_terms = YAML.load(File.read('config/ae_terms.yml'))

dm = gen_dm(study,controlled_terms)
sv = gen_sv(study,dm)
ex = gen_ex(study,dm,sv)
lb = gen_lb(study,dm,sv,lab_parameters)
ae = gen_ae(study,dm,sv,ae_terms) # last parameter is mean AEs per year
adae = gen_add_dm(dm,ae,["age","sex","country","arm","armcd","actarm","actarmcd","invnam","siteid"])
adlb = gen_add_dm(dm,lb,["age","sex","country","arm","armcd","actarm","actarmcd","invnam","siteid"])

csv_stem = "output/"

dm.write_csv(csv_stem + "dm.csv")
sv.write_csv(csv_stem + "sv.csv")
ex.write_csv(csv_stem + "ex.csv")
lb.write_csv(csv_stem + "lb.csv")
ae.write_csv(csv_stem + "ae.csv")
adae.write_csv(csv_stem + "adae.csv")
adlb.write_csv(csv_stem + "adlb.csv")

adlb_pc = gen_subset(inDs: lb,keep: ["lbstresn","actarm","sex","country","lbnrind","visit","lbtest"]) # dataset for parallel coordinates graph

adlb_csv = CSV.read(csv_stem + "adlb.csv", :headers => true)

adlb_pc_keep = ["lbstresn","actarm","sex","country","lbnrind","visit","lbtest"]
adlb_pc = adlb_csv.by_col!.delete_if { |col_name,col_values| !adlb_pc_keep.include? col_name }
File.open(csv_stem + "adlb_pc.csv", 'w') { |file| file.write(adlb_pc.to_csv) }

# write_dataset_to_csv(ex,csv_stem)

# binding.pry

# File.open("output/#{study.studyid}_dm.yml", 'w') {|f| f.write(YAML.dump(dm)) }
# File.open("output/#{study.studyid}_sv.yml", 'w') {|f| f.write(YAML.dump(sv)) }
# File.open("output/#{study.studyid}_ex.yml", 'w') {|f| f.write(YAML.dump(ex)) }
# File.open("output/#{study.studyid}_lb.yml", 'w') {|f| f.write(YAML.dump(lb)) }
# File.open("output/#{study.studyid}_ae.yml", 'w') {|f| f.write(YAML.dump(ae)) }

# usbjids
# binding.pry

