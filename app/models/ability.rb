class Ability
  include CanCan::Ability

  def initialize(user)
    if user.try(:admin?)
      can :manage, :all
    elsif user
      can :create, Word
      can :create, Comment
      can :my_words, Word
      can :to_verify, Word
      can :index, Setting

      can [ :edit, :update, :delete ], Word do |word|
        word.user_id == user.id
      end

    else

    end
  end
end
