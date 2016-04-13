Rails.application.config.active_job.queue_adapter = if Rails.env.test?
                                                      :inline
                                                    else
                                                      :sidekiq
                                                    end
