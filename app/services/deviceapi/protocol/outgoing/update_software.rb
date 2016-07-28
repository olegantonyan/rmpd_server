class Deviceapi::Protocol::Outgoing::UpdateSoftware < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    return unless device
    clean_previous_commands
    enqueue(json(options[:distribution_url]))
  end

  def max_retries
    1
  end

  private

  def json(url)
    { distribution_url: url }
  end
end
