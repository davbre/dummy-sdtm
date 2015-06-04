
def hlp_rand_in_range(from, to)
  rand * (to - from) + from
end

def hlp_rand_time(from, to=Time.now)
  Time.at(hlp_rand_in_range(from.to_f, to.to_f))
end

def check_treatment_ratios


end