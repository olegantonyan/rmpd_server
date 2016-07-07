class Deviceapi::Protocol::Incoming::AckFail < Deviceapi::Protocol::Incoming::BaseAck
  def ok
    false
  end
end
