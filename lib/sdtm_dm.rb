class SdtmDm
  include ActiveModel::Validations

  attr_accessor :studyid, :siteid, :usubjid, :invnam, :country, :sex, :armcd, :arm, :actarmcd, :actarm,
                :rfstdtc, :rfendtc, :dthdtc, :dthfl, :age, :ageu

  def initialize(studyid: nil, usubjid: nil, siteid: nil, invnam: nil, sex: nil, country: nil,
                 armcd: nil, arm: nil, actarmcd: nil, actarm: nil, rfstdtc: nil, rfendtc: nil,
                 dthdtc: nil, dthfl: nil, age: nil, ageu: nil)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end    
  end

  # Required variables
  validates_presence_of :studyid , :siteid, :usubjid, :invnam, :country, :sex, :armcd, :arm, :actarmcd, :actarm
  
end