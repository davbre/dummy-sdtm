
def hlp_rand_in_range(from, to)
  rand * (to - from) + from
end

def hlp_rand_time(from, to=Time.now)
  Time.at(hlp_rand_in_range(from.to_f, to.to_f))
end

def hlp_rand_start_date(ref_date)
  hlp_rand_time(ref_date, ref_date + rand(0..365).days).to_date
end

def check_treatment_ratios


end


# http://stackoverflow.com/questions/5825680/code-to-generate-gaussian-normally-distributed-random-numbers-in-ruby
# class RandomGaussian
#   def initialize(mean = 0.0, sd = 1.0, rng = lambda { Kernel.rand })
#     @mean, @sd, @rng = mean, sd, rng
#     @compute_next_pair = false
#   end

#   def rand
#     if (@compute_next_pair = !@compute_next_pair)
#       # Compute a pair of random values with normal distribution.
#       # See http://en.wikipedia.org/wiki/Box-Muller_transform
#       theta = 2 * Math::PI * @rng.call
#       scale = @sd * Math.sqrt(-2 * Math.log(1 - @rng.call))
#       @g1 = @mean + scale * Math.sin(theta)
#       @g0 = @mean + scale * Math.cos(theta)
#     else
#       @g1
#     end
#   end
# end