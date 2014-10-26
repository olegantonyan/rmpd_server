#coding: utf-8

APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env]