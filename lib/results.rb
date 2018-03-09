require_relative 'rubyify_keys'
require 'json'

module TFLJourneyPlanner

	module Results

		include HTTParty
		
		format :json

		def get_journeys(options)
			from = options[:from].gsub(" ", "%20")
			to = options[:to].gsub(" ", "%20")
			via = options[:via]
			national_search = options[:national_search] || false
			time  = options[:time]
			date = options[:date]
			time_is = options[:time_is] || "Departing"
			journey_preference = options[:journey_preference]
			mode = options[:mode]
			accessibility_preference = options[:accessibility_preference]
			from_name = options[:from_name]
			to_name = options[:to_name]
			via_name = options[:via_name]
			max_transfer_minutes = options[:max_transfer_minutes]
			max_walking_minutes = options[:max_walking_minutes]
			walking_speed = options[:walking_speed]
			cycle_preference = options[:cycle_preference]
			adjustment = options[:adjustment]
			bike_proficiency = options[:bike_proficiency]
			alternative_cycle = options[:alternative_cycle] || false
			alternative_walking = options[:alternative_walking] || true
			apply_html_markup = options[:apply_html_markup] || false
			use_multi_modal_call = options[:use_multi_modal_call] || false
			walking_optimization = options[:walking_optimization] || false
			taxi_only_trip = options[:taxi_only_trip] || false

			base_url = 'https://api.tfl.gov.uk/journey/journeyresults/' << from << '/to/' << to

			queryOptions = Hash.new()
			queryOptions['options'] = Hash.new()
			queryOptions['options']['query'] = Hash.new()
			queryOptions['options']['query']['via'] = via unless via.nil?
			queryOptions['options']['query']['app_key'] = app_key unless app_key.nil?
			queryOptions['options']['query']['app_id'] = app_id unless app_id.nil?
			queryOptions['options']['query']['nationalSearch'] = national_search unless national_search.nil?
			queryOptions['options']['query']['date'] = date unless date.nil?
			queryOptions['options']['query']['timeIs'] = time_is unless time_is.nil?
			queryOptions['options']['query']['journeyPreference'] = journey_preference unless journey_preference.nil?
			queryOptions['options']['query']['mode'] = mode unless mode.nil?
			queryOptions['options']['query']['accessibilityPreference'] = accessibility_preference unless accessibility_preference.nil?
			queryOptions['options']['query']['fromName'] = from_name unless from_name.nil?
			queryOptions['options']['query']['toName'] = to_name unless to_name.nil?
			queryOptions['options']['query']['viaName'] = via_name unless via_name.nil?
			queryOptions['options']['query']['maxTransferMinutes'] = max_walking_minutes unless max_walking_minutes.nil?
			queryOptions['options']['query']['walkingSpeed'] = walking_speed unless walking_speed.nil?
			queryOptions['options']['query']['cyclePreference'] = cycle_preference unless cycle_preference.nil?
			queryOptions['options']['query']['adjustment'] = adjustment unless adjustment.nil?
			queryOptions['options']['query']['alternativeCycle'] = alternative_cycle unless alternative_cycle.nil?
			queryOptions['options']['query']['alternativeWalking'] = alternative_walking unless alternative_walking.nil?
			queryOptions['options']['query']['applyHtmlMarkup'] = apply_html_markup unless apply_html_markup.nil?
			queryOptions['options']['query']['useMultiModalCall'] = use_multi_modal_call unless use_multi_modal_call.nil?
			queryOptions['options']['query']['walkingOptimization'] = walking_optimization unless walking_optimization.nil?
			queryOptions['options']['query']['taxiOnlyTrip'] = taxi_only_trip unless taxi_only_trip.nil?			
			
			results = self.class.get(base_url, queryOptions).rubyify_keys!
			puts "Gem results:"
			puts results
			results["journeys"]
		end

		def disambiguate results
			options = []
			find_common_names = lambda { |option| options << option["place"]["common_name"] }
			results["to_location_disambiguation"]["disambiguation_options"].each(&find_common_names) if results["to_location_disambiguation"]["disambiguation_options"]
			results["from_location_disambiguation"]["disambiguation_options"].each(&find_common_names) if results["from_location_disambiguation"]["disambiguation_options"]
			puts "Did you mean?\n\n"
			options.each {|o| puts o + "\n"}
			false
		end

		def process_journeys_from(results)
			puts results
			puts "process_journeys_from"
			if results["http_status"] != 200
				raise "Bad response from TFL: HTTP Code " << results['http_status']
			end

			return results["journeys"]
		end

	end

end


=begin
via: via, 
app_key: app_key, 
app_id: app_id, 
nationalSearch: national_search,
time: time,
date: date,
timeIs: time_is,
journeyPreference: journey_preference,
mode: mode,
accessibilityPreference: accessibility_preference,
fromName: from_name,
toName: to_name,
viaName: via_name,
maxTransferMinutes: max_transfer_minutes,
maxWalkingMinutes: max_walking_minutes,
walkingSpeed: walking_speed,
cyclePreference: cycle_preference,
adjustment: adjustment,
alternativeCycle: alternative_cycle, 
alternativeWalking: alternative_walking, 
applyHtmlMarkup: apply_html_markup, 
useMultiModalCall: use_multi_modal_call,
walkingOptimization: walking_optimization, 
taxiOnlyTrip: taxi_only_trip	
=end
