class Study
  include ActiveModel::Validations

  attr_accessor :studyid, :treatments, :treatment_codes, :treatment_ratios,
    :treatment_doses, :total_subjects, :num_visits, :visit_duration,
    :visit_unit, :age_range, :sites, :investigators, :ref_date,
    :screen_fail_proportion, :screening_days , :discontinue_proportion,
    :mean_aes_per_year, :default_mean_aes_per_year,
    :ae_serious_proportion, :default_ae_serious_proportion,
    :ae_severity_proportions, :default_ae_severity_proportions

  validate :check_treatments, :check_ae_serious_proportion, :check_ae_severity_proportions

  def initialize(studyid: nil, treatments: nil, treatment_codes: nil,
    treatment_ratios: nil, treatment_doses: nil,total_subjects: nil,
    num_visits: nil, visit_duration: nil, visit_unit: nil, age_range: nil,
    sites: nil, screen_fail_proportion: 0.1, screening_days: 14,
    discontinue_proportion: 0.15)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end


  # maximum number of sites within a country
  def max_sites
    @sites.map { |s| s.length }.max
  end

  # total number of sites
  def total_sites
    @sites.flatten.length - sites.length
  end

  def check_treatments
    if !(@treatments.length == @treatment_codes.length && @treatments.length == @treatment_ratios.length)
      errors.add(:treatments, "No. treatments, treatment codes and ratios must all be equal")
    end
    if treatment_ratios.inject{|sum,x| sum + x } != 1
      errors.add(:treatment_ratios, "Treatment ratios must add to 1")
    end
  end

  # TODO
  def check_ae_serious_proportion
    true
  end

  # TODO
  def check_ae_severity_proportions
    true
  end
  

  # Assign investigator names to sites and initialize a count of subjects
  # assigned to them
  def assign_random_investigator_names
    @investigators = []
    @sites.each do |country|
      tmparr = []
      country.each do |site|
        tmparr << ["Dr. " + Faker::Name.name, 0]
      end
      investigators << tmparr
    end
    @investigators
  end


end