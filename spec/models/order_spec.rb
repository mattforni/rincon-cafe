require 'rails_helper'

describe Order do
  BELONGS_TO = [:user]

  PRESENCE = [
    :beverage,
    :location,
    :temperature,
    :user
  ]

  before(:each) do
    @user = create(:user)
    @order = Record.validates(create(:order, {user: @user}))
  end

  describe 'associations' do
    BELONGS_TO.each do |belongs_to|
      it "belongs_to :#{belongs_to}" do
        @order.belongs_to belongs_to, @order.record.send(belongs_to)
      end
    end
  end

  describe 'validations' do
    PRESENCE.each do |field|
      it "has :#{field} field" do
        @order.field_presence field
      end
    end
  end
end

