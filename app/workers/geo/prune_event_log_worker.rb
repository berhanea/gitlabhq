module Geo
  class PruneEventLogWorker
    include Sidekiq::Worker
    include CronjobQueue
    include ExclusiveLeaseGuard

    LEASE_TIMEOUT = 60.minutes

    def lease_timeout
      LEASE_TIMEOUT
    end

    def log_error(message, extra_args = {})
      args = { class: self.class.name, message: message }.merge(extra_args)
      Gitlab::Geo::Logger.error(args)
    end

    def perform
      return unless Gitlab::Geo.primary?

      try_obtain_lease do
        if Gitlab::Geo.secondary_nodes.empty?
          Geo::EventLog.delete_all
          return
        end

        cursor_last_event_ids = Gitlab::Geo.secondary_nodes.map do |node|
          node_status_service.call(node).cursor_last_event_id
        end

        # Abort when any of the nodes could not be contacted
        return if cursor_last_event_ids.include?(nil)

        Geo::EventLog.delete_all(['id < ?', cursor_last_event_ids.min])
      end
    end

    private

    def node_status_service
      @node_status_service ||= Geo::NodeStatusService.new
    end
  end
end
