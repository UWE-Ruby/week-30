require_relative 'spec_helper'

describe Battleship do

  before do
    subject.add_player 'frank'
    subject.add_player 'ivan'
    subject.place_ship 'frank', :tugboat, :horizontal, 1, 1
    subject.place_ship 'ivan', :carrier, :vertical, 1, 1
  end

  profile :file => STDOUT, :printer => :graph do

    it "should perform" do
      subject.shoot 'frank', 1, 1
    end

  end

end
