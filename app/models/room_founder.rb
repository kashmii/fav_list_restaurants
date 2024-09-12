class RoomFounder < ApplicationRecord
  belongs_to :room

  # 部屋、創設者ともに重複してはならない
  validates :founder_id, presence: true, uniqueness: true
  validates :room_id, presence: true, uniqueness: true
end
