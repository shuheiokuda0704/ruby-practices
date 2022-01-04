# frozen_string_literal: true

require 'rspec'
require_relative '../bowling'

RSpec.describe Bowling do
  describe '#score' do
    context 'No arguments' do
      example 'Argument Error' do
        expect { Bowling.new }.to raise_error
      end
    end

    context 'Invalid arguments' do
      example 'score is 0' do
        bowling = Bowling.new(input: 'ABC')
        expect(bowling.score).to eq 0
      end
    end

    context 'Correct arguments' do
      example 'Perfect (300)' do
        bowling = Bowling.new(input: 'X,X,X,X,X,X,X,X,X,X,X,X')
        expect(bowling.score).to eq 300
      end

      example '0' do
        bowling = Bowling.new(input: '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
        expect(bowling.score).to eq 0
      end

      example 'SampleA input: 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5 score: 139' do
        bowling = Bowling.new(input: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
        expect(bowling.score).to eq 139
      end

      example 'SampleB input: 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X score: 164' do
        bowling = Bowling.new(input: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
        expect(bowling.score).to eq 164
      end

      example 'SampleC input: 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4 score: 107' do
        bowling = Bowling.new(input: '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
        expect(bowling.score).to eq 107
      end

      example 'SampleD input: 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0 score: 134' do
        bowling = Bowling.new(input: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
        expect(bowling.score).to eq 134
      end

      example 'SampleE input: 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8 score: 144' do
        bowling = Bowling.new(input: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
        expect(bowling.score).to eq 144
      end
    end
  end
end
