module Api
  class TimeZoneResource < Api::BaseResource
    class TimeZoneModel
      class << self
        def all
          ActiveSupport::TimeZone.all.map { |i| new(i) }
        end

        def where(*_args)
          all
        end

        def order(*_args)
          all
        end

        def policy_class
          Class.new(ApplicationPolicy) do
            def show?
              true
            end

            def create?
              false
            end
          end
        end
      end

      attr_accessor :tz

      def initialize(tz)
        self.tz = tz
      end

      def id
        tz.name
      end

      def offset
        tz.formatted_offset
      end

      def tzinfo_name
        tz.tzinfo.name
      end
    end

    attributes :offset, :tzinfo_name
    model_name 'Api::TimeZoneResource::TimeZoneModel'
    paginator :none

    def fetchable_fields
      %i[id offset tzinfo_name]
    end

    def self.updatable_fields(_context)
      []
    end

    def self.creatable_fields(context)
      updatable_fields(context)
    end
  end
end
