require_relative '../lib/lanternfish'

SEED_FILE = ARGV[0]
INTERVAL = ARGV[1]
DEBUG_MODE = ARGV[2] || false

growth_model = Lanternfish::GrowthModel.new(SEED_FILE, DEBUG_MODE)

puts "Initial seed: #{growth_model.initial_population_seed}"
puts "Initial state: #{growth_model.initial_population_state}"

initial_population = growth_model.calculate_fish_population(growth_model.initial_population_state)
puts "Initial population size: #{initial_population}"

puts "Population growth projection over #{INTERVAL} days..."
puts growth_model.project_fish_growth INTERVAL
