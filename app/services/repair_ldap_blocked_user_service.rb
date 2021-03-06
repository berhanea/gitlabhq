# frozen_string_literal: true

class RepairLdapBlockedUserService
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def execute
    user.block if ldap_hard_blocked?
  end

  private

  def ldap_hard_blocked?
    user.ldap_blocked? && !user.ldap_user?
  end
end
