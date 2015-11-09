Rails.application.config.middleware.use ExceptionNotification::Rack,
  slack: {
    webhook_url: APP_CONFIG.fetch(:slack, {}).fetch(:webhook_url, nil),
    channel: '#exceptions',
    username: 'exception notifier',
    additional_parameters: {
      mrkdwn: true,
      icon_emoji: ':bug:'
    },
    attachments: [{
      fields: [{
        title: 'Enviroment',
        value: Rails.env,
        short: true
        }
      ],
      color: 'danger'
    }
    ]
  }
