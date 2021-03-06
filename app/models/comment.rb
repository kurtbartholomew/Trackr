class Comment < ActiveRecord::Base
  before_create :set_previous_state
  after_create :set_ticket_state
  after_create :associate_tags_with_ticket
  after_create :author_watches_ticket

  belongs_to :state
  belongs_to :ticket
  belongs_to :author, class_name: "User"
  belongs_to :previous_state, class_name: "State"
  attr_accessor :tag_names
  scope :persisted, lambda { where.not(id: nil) }

  validates :text, presence: true
  delegate :project, to: :ticket

  private
    def set_ticket_state
      ticket.state = state
      ticket.save!
    end  
    def set_previous_state
      self.previous_state = ticket.state
    end
    def associate_tags_with_ticket
      if tag_names
        tag_names.split.each do |name|
          ticket.tags << Tag.find_or_create_by(name: name)
        end  
      end
    end
    def author_watches_ticket
      if author.present? && !ticket.watchers.include?(author)
        ticket.watchers << author
      end
    end
end
