class Comment < ActiveRecord::Base
  after_create :set_ticket_state

  belongs_to :state
  belongs_to :ticket
  belongs_to :author, class_name: "User"
  scope :persisted, lambda { where.not(id: nil) }

  validates :text, presence: true
  delegate :project, to: :ticket

  private
    def set_ticket_state
      ticket.state = state
      ticket.save!
    end  
end
