class SdtmDm
  include ActiveModel::Validations

  attr_accessor :studyid, :domain, :siteid, :subjid, :usubjid, :invnam,
                :country, :sex, :armcd, :arm, :actarmcd, :actarm, :rfstdtc,
                :rfendtc, :dthdtc, :dthfl, :age, :ageu

  def initialize(studyid: nil, domain: nil, siteid: nil, subjid: nil,
                 usubjid: nil, invnam: nil, country: nil, sex: nil, armcd: nil,
                 arm: nil, actarmcd: nil, actarm: nil, rfstdtc: nil,
                 rfendtc: nil, dthdtc: nil, dthfl: nil, age: nil, ageu: nil)

    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    @domain = self.class.to_s[-2..-1].upcase # last two letters of this class name to give the domain value
  end

  # Required variables
  validates_presence_of :studyid, :domain, :siteid, :subjid, :usubjid, :invnam,
      :country, :sex, :armcd, :arm, :actarmcd, :actarm
  
end