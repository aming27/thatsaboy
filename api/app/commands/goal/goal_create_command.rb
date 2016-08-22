# Create a goal command
class Goal::GoalCreateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :target
  attr_accessor :person_repository

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_repository.find(x.id) }
  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target,    presence: true,
                        numericality: {
                          only_integer: true,
                          greater_than: 0,
                          less_than: 1000
                        }

  # Sets all variables
  # @param [Object] params
  # @see Family:Child
  # @see User::AuthorizationService
  # @see Goal::GoalRepository
  # @see Family::PersonRepository
  def initialize(params)
    super(params)
    @child_model = Family::Child
    @authorization_service = User::AuthorizationService.get
    @goal_repository = Goal::GoalRepository.get
    @person_repository = Family::PersonRepository.get(@child_model)
  end


  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    child = @person_repository.find(id)
    goal = Goal::Goal.new(user, child, target, name, photo_url)
    goal = @goal_repository.save!(goal)
    { id: goal.id }
  end
end