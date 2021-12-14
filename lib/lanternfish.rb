# frozen_string_literal: true
require 'json'
require "pry"

module Lanternfish
  class Error < StandardError; end

  class GrowthModel

    attr_reader :seed_file, :initial_population_seed, :initial_population_state, :debug_mode

    def initialize(seed_file, debug_mode = false)
      @debug_mode = debug_mode
      @seed_file = seed_file
      @initial_population_seed = get_seed_file(seed_file)
      @initial_population_state = convert_initial_population_seed_to_state
    end

    def populate_fish(fish_state)
      puts "\nFish population: #{fish_state.to_s}" if @debug_mode
      validate_state(fish_state)

      fish_state << fish_state.shift # pops the front and appends it to the back
      fish_state[6] += fish_state[8] # resets the initial fish by putting the back into the 6 day interval slot

      puts "New population:  #{fish_state.to_s}" if @debug_mode
      fish_state
    end

    def project_fish_growth(interval)
      interval = Integer(interval)
      raise Lanternfish::Error if interval < 1

      growth_state = initial_population_state
      for i in 1..interval do
        growth_state = populate_fish(growth_state)
      end
      calculate_fish_population(growth_state)
    end

    def calculate_fish_population(fish_state)
      # determine # of fish based on given array of integers
      puts "Calculating population of #{fish_state.to_s}" if @debug_mode
      fish_state.sum
    end

    private

    def get_seed_file(file)
      raise Lanternfish::Error unless File.exists?(file)

      json_file = File.read(file)
      begin
        json = JSON.parse(json_file)
        initial_population_seed = Array(json['population'])
        validate_seed(initial_population_seed)
      rescue => e
        raise Lanternfish::Error.new('Could not read json file.')
      end
      initial_population_seed
    end

    def validate_seed(seed)
      raise Lanternfish::Error if seed.empty?
      seed.each do |timer|
        raise Lanternfish::Error if Integer(timer) > 8
      end
    end

    def convert_initial_population_seed_to_state
      # Each index is the number of fish with this internal timer
      #              [0,1,2,3,4,5,6,7,8]
      state = [0,0,0,0,0,0,0,0,0]
      for i in 0..(state.length - 1) do
        state[i] += initial_population_seed.count(i)
      end
      state
    end

    def validate_state(state)
      raise Lanternfish::Error unless state.to_a
      raise Lanternfish::Error unless state.length == 9

      state.each do |count|
        raise Lanternfish::Error if count < 0
      end
    end
  end
end
