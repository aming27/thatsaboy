# Common methods for commands
class Core::Command
  include ActiveModel::Validations

  # Fulfill input with attributes
  # @param [Hash] attributes
  def initialize(attributes = {})
    attributes.each do |name, value|
      if self.methods.include? (name+'=').to_sym
        self.method((name+'=').to_sym).call(value)
      end
    end
  end

  # Run command
  def execute
  end
end


