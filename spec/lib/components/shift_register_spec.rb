require 'spec_helper'

module Dino
  module Components
    describe ShiftRegister do
      include BoardMock
      let(:options) { { board: board, pins: {clock: 12, data: 11, latch: 8} } }
      subject { ShiftRegister.new(options)  }

      describe '#initialize' do
        it 'should create a BaseOutput instance for each pin' do
          expect(subject.clock.class).to eq(Basic::DigitalOutput)
          expect(subject.latch.class).to eq(Basic::DigitalOutput)
          expect(subject.data.class).to eq(Basic::DigitalOutput)
        end
      end

      describe '#write' do
        before(:each) { subject }

        it 'should write a single byte as value and clock pin as aux to the data pin' do
          expect(subject.latch).to receive(:digital_write).with(board.low)
          expect(board).to receive(:write).with "11.11.255.12\n"
          expect(subject.latch).to receive(:digital_write).with(board.high)

          subject.write(255)
        end

        it 'should write an array of bytes as value and clock pin as aux to the data pin' do
          expect(subject.latch).to receive(:digital_write).with(board.low)
          expect(board).to receive(:write).with "11.11.255.12\n"
          expect(board).to receive(:write).with "11.11.0.12\n"
          expect(subject.latch).to receive(:digital_write).with(board.high)

          subject.write([255,0])
        end
      end
    end
  end
end
