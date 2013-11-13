require 'roar/representer/json/hal'
require_relative 'pact_broker_urls'
require_relative 'version_representor'

module Roar
  module Representer
    module Feature

      module Hypermedia

        #Monkey patch alert! Get "no method rel for Nil" when there is an empty array
        #in links. Cannot reproduce this in the roar tests :(
        alias_method :original_compile_links_for, :compile_links_for

        def compile_links_for configs, *args
          original_compile_links_for(configs, *args).select(&:any?)
        end

      end
    end
  end
end


module PactBroker

  module Api

    module Representors

      module PacticipantCollectionRepresenter
        include Roar::Representer::JSON::HAL
        include PactBroker::Api::PactBrokerUrls


        collection :pacticipants, :class => PactBroker::Models::Pacticipant, :extend => PactBroker::Api::Representors::PacticipantRepresenter

        def pacticipants
          self
        end

        link :self do
          pacticipants_url
        end

        links :pacticipants do
          collect{ | pacticipant | {:href => pacticipant_url(pacticipant), :name => pacticipant.name } }
        end

      end
    end
  end
end