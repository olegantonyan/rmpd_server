RSpec::Matchers.define :permit do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end

def pundit_permit(*actions)
  instance_eval do
    actions.each do |action|
      it { is_expected.to permit(action) }
    end
  end
end

def pundit_forbid(*actions)
  instance_eval do
    actions.each do |action|
      it { is_expected.not_to permit(action) }
    end
  end
end

def pundit_policy_scope(user, records, expected_records)
  expect(Pundit.policy_scope(user, records)).to match_array expected_records
end
