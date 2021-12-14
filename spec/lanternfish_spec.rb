require 'spec_helper'
require_relative '../lib/lanternfish'

describe Lanternfish::GrowthModel do

  subject(:sample_fish) { Lanternfish::GrowthModel.new(sample_seed_file) }

  describe '#initialize' do

    context 'with an empty seed file' do
      let(:sample_seed_file) { './spec/samples/empty_sample.json' }

      it 'raises an error' do
        expect { subject }.to raise_error Lanternfish::Error
      end
    end

    context 'with a non json seed file' do
      let(:sample_seed_file) { './spec/samples/non_json_sample.json' }

      it 'raises an error' do
        expect { subject }.to raise_error Lanternfish::Error
      end
    end

    context 'with an invalid seed file' do
      let(:sample_seed_file) { './spec/samples/initialize_sample.json' }

      it 'raises an error' do
        expect { subject }.to raise_error Lanternfish::Error
      end
    end

    context 'with a valid seed file' do

      let(:sample_seed_file) { './spec/samples/integration_sample.json' }

      it 'does not raise an error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe '#populate_fish' do

    let(:sample_seed_file) { './spec/samples/integration_sample.json' }
    let(:fish_population) { [2, 1, 0, 4, 2, 3, 1, 5, 7] }
    let(:new_fish_population) { [1, 0, 4, 2, 3, 1, 7, 7, 2] }

    it 'calculates the new population state' do
      expect(subject.populate_fish(fish_population)).to eq new_fish_population
    end
  end

  describe '#project_fish_growth' do

    let(:sample_seed_file) { './spec/samples/integration_sample.json' }

    it 'determines the correct growth for an interval of 1' do
      expect(subject.project_fish_growth(1)).to eq 5
    end

    it 'determines the correct growth for an interval of 18' do
      expect(subject.project_fish_growth(18)).to eq 26
    end

    it 'determines the correct growth for an interval of 80' do
      expect(subject.project_fish_growth(80)).to eq 5934
    end

    it 'determines the correct growth for an interval of 256' do
      expect(subject.project_fish_growth(256)).to eq 26984457539
    end
  end
end
