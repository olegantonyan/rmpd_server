class User::Registration < User
  attr_accessor :company_title

  before_validation do
    company = companies.build(title: company_title.blank? ? "#{self}'s company" : company_title)
    errors.add(:company_title, company.errors.full_messages.to_sentence) if company.invalid?
  end
end
