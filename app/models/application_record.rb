class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Global validations and methods for all models
  
  # Strip whitespace from string attributes before validation
  before_validation :strip_whitespace

  # Scope for recently created records
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }

  private

  def strip_whitespace
    self.class.column_names.each do |column|
      if self[column].is_a?(String)
        self[column] = self[column].strip unless self[column].nil?
      end
    end
  end
end
