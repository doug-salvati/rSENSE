class Tag < ActiveRecord::Base
belongs_to :project

  def name=(val)
    write_attribute(:name, val.downcase)
  end

  validates :name, length: {
    minimum: 1,
    too_short:  ' (Name\'s Label) is too short (Minimum is one character)',
    maximum: 20
  }

  validates_uniqueness_of :name, scope: :project, case_sensitive: false
  validates :project, presence: true
end
