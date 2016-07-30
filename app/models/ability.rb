class Ability
  include CanCan::Ability

  def initialize(user)
    if user.try(:admin?)
      can :manage, :all
    elsif user
      can :create, Word
      can :my_words, Word
      can :to_verify, Word

      can [ :edit, :update, :delete ], Word do |word|
        word.user_id == user.id
      end

    else

    end
  end
end
